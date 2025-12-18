<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\AnggotaKelas;
use App\Models\Kelas;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class AnggotaKelasController extends Controller
{
    /**
     * GET /api/kelas-options
     * Dipakai untuk dropdown kelas di Flutter
     */
    public function kelasOptions()
    {
        $kelasList = Kelas::select('id', 'nama_kelas')
            ->orderBy('nama_kelas')
            ->get();

        return response()->json([
            'success' => true,
            'data'    => $kelasList,
        ]);
    }

    /**
     * GET /api/siswa-options
     * Hanya user dengan role = murid
     */
    public function siswaOptions()
    {
        $siswaList = User::where('role', 'murid')
            ->select('id', 'name', 'nisn_nip')
            ->orderBy('name')
            ->get();

        return response()->json([
            'success' => true,
            'data'    => $siswaList,
        ]);
    }

    /**
     * GET /api/ortu-options
     * Hanya user dengan role = wali_murid
     */
    public function ortuOptions()
    {
        $ortuList = User::where('role', 'wali_murid')
            ->select('id', 'name', 'nisn_nip')
            ->orderBy('name')
            ->get();

        return response()->json([
            'success' => true,
            'data'    => $ortuList,
        ]);
    }

    /**
     * POST /api/anggota-kelas
     * Simpan anggota kelas baru
     */
    public function store(Request $request)
    {
        Log::info('AnggotaKelasApiController@store - incoming', [
            'payload' => $request->all(),
        ]);

        $validated = $request->validate([
            'kelas_id' => ['required', 'exists:kelas,id'],
            'siswa_id' => ['required', 'exists:users,id'],
            'ortu_id'  => ['nullable', 'exists:users,id'],
        ]);

        // Validasi role siswa = murid
        $siswa = User::find($validated['siswa_id']);
        if (! $siswa || $siswa->role !== 'murid') {
            return response()->json([
                'success' => false,
                'message' => 'User yang dipilih untuk siswa harus berperan sebagai murid.',
            ], 422);
        }

        // Validasi role ortu = wali_murid (jika dipilih)
        if (! empty($validated['ortu_id'])) {
            $ortu = User::find($validated['ortu_id']);
            if (! $ortu || $ortu->role !== 'wali_murid') {
                return response()->json([
                    'success' => false,
                    'message' => 'User yang dipilih untuk orang tua harus berperan sebagai wali murid.',
                ], 422);
            }
        }

        // Cegah duplikasi siswa di kelas yang sama
        $exists = AnggotaKelas::where('kelas_id', $validated['kelas_id'])
            ->where('siswa_id', $validated['siswa_id'])
            ->exists();

        if ($exists) {
            return response()->json([
                'success' => false,
                'message' => 'Siswa ini sudah terdaftar pada kelas tersebut.',
            ], 422);
        }

        $anggota = AnggotaKelas::create($validated);

        return response()->json([
            'success' => true,
            'message' => 'Anggota kelas berhasil ditambahkan.',
            'data'    => $anggota,
        ]);
    }
}
