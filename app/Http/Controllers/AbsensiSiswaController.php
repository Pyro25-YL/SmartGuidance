<?php

namespace App\Http\Controllers;

use App\Models\AbsensiSiswa;
use App\Models\AlamatSekolah;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class AbsensiSiswaController extends Controller
{
    /**
     * API Form data absensi siswa
     * GET /api/absensi-siswa/form?user_id=...
     */
    public function formApi(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'user_id' => ['required', 'exists:users,id'],
        ]);

        $user = User::findOrFail($validated['user_id']);

        // alamat sekolah (boleh null)
        $alamat = AlamatSekolah::first();

        // absensi terakhir siswa
        $lastAbsensi = AbsensiSiswa::where('user_id', $user->id)
            ->orderByDesc('jam_masuk')
            ->first();

        return response()->json([
            'success' => true,
            'data'    => [
                'user' => [
                    'id'           => $user->id,
                    'name'         => $user->name,
                    'nisn_nip'     => $user->nisn_nip,
                    'role'         => $user->role,
                    'jenis_kelamin'=> $user->jenis_kelamin,
                    'foto'         => $user->foto,
                    'foto_url'     => $user->foto
                        ? asset('storage/foto/' . $user->foto)
                        : null,
                ],
                'sekolah' => $alamat ? [
                    'latitude'           => (float) $alamat->latitude,
                    'longitude'          => (float) $alamat->longitude,
                    'radius_jarak_absen' => (int) $alamat->radius_jarak_absen,
                ] : null,
                'last_absensi' => $lastAbsensi ? [
                    'jam_masuk' => $lastAbsensi->jam_masuk?->toIso8601String(),
                    'status'    => $lastAbsensi->status,
                    'foto'      => $lastAbsensi->foto,
                ] : null,
            ],
        ]);
    }

    /**
     * API: simpan absensi masuk siswa
     * POST /api/absensi-siswa
     */
    public function storeApi(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'user_id'  => ['required', 'exists:users,id'],
            'lat'      => ['required', 'numeric', 'between:-90,90'],
            'lon'      => ['required', 'numeric', 'between:-180,180'],
            'status'   => ['nullable', 'string', 'max:20'],
            'foto'     => ['nullable', 'image', 'max:3072'], // maks 3MB
        ]);

        $user = User::findOrFail($validated['user_id']);

        // Ambil alamat sekolah
        $alamat = AlamatSekolah::first();
        if (! $alamat) {
            return response()->json([
                'success' => false,
                'message' => 'Alamat sekolah belum diset. Hubungi admin.',
            ], 422);
        }

        // Hitung jarak (meter) antara posisi siswa dan sekolah
        $jarakMeter = $this->haversine(
            $validated['lat'],
            $validated['lon'],
            (float) $alamat->latitude,
            (float) $alamat->longitude,
        );

        // Jika mau paksa dalam radius, aktifkan blok ini
        if ($jarakMeter > (int) $alamat->radius_jarak_absen) {
            return response()->json([
                'success' => false,
                'message' => 'Di luar radius absen.',
                'detail'  => 'Jarak Anda ~' . number_format($jarakMeter, 0) .
                    ' m, batas ' . $alamat->radius_jarak_absen . ' m.',
                'jarak_meter' => $jarakMeter,
            ], 422);
        }

        // Upload foto (opsional)
        $fotoPath = null;
        if ($request->hasFile('foto')) {
            $ext  = $request->file('foto')->getClientOriginalExtension();
            $nama = 'absen_siswa_' . Str::uuid() . '.' . $ext;
            $p    = $request->file('foto')->storeAs('public/foto_absen_siswa', $nama);
            $fotoPath = str_replace('public/', 'storage/', $p);
        }

        $now = Carbon::now('Asia/Jakarta');

        $absensi = AbsensiSiswa::create([
            'user_id'   => $user->id,
            'latitude'  => $validated['lat'],
            'longitude' => $validated['lon'],
            'jam_masuk' => $now,
            'status'    => $validated['status'] ?? 'hadir',
            'foto'      => $fotoPath,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Absensi siswa berhasil disimpan.',
            'data'    => [
                'id'         => $absensi->id,
                'user_id'    => $absensi->user_id,
                'jam_masuk'  => $absensi->jam_masuk->toIso8601String(),
                'status'     => $absensi->status,
                'foto'       => $absensi->foto,
                'jarak_meter'=> $jarakMeter,
            ],
        ], 201);
    }

    /**
     * Haversine distance (meters)
     */
    private function haversine($lat1, $lon1, $lat2, $lon2): float
    {
        $R = 6371000; // meters
        $φ1 = deg2rad($lat1);
        $φ2 = deg2rad($lat2);
        $Δφ = deg2rad($lat2 - $lat1);
        $Δλ = deg2rad($lon2 - $lon1);

        $a = sin($Δφ / 2) * sin($Δφ / 2) +
            cos($φ1) * cos($φ2) *
            sin($Δλ / 2) * sin($Δλ / 2);

        $c = 2 * atan2(sqrt($a), sqrt(1 - $a));
        return $R * $c;
    }
}
