<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\AbsensiMasukSekolah;
use App\Models\AlamatSekolah;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Carbon\Carbon;

class AbsensiMasukSekolahController extends Controller
{
    public function index()
    {
        return view('absensi.masuk');
    }

public function store(Request $request)
{
    $request->validate([
        'latitude'  => 'required',
        'longitude' => 'required',
        'foto'      => 'required|image|max:2048',
    ]);

    $user = $request->user();

    $sekolah = AlamatSekolah::where('singleton', 1)->firstOrFail();

    $jarak = $this->hitungJarak(
        $request->latitude,
        $request->longitude,
        $sekolah->latitude,
        $sekolah->longitude
    );

    if ($jarak > $sekolah->radius_jarak_absen) {
        return response()->json([
            'success' => false,
            'message' => 'Di luar radius sekolah'
        ], 403);
    }

    $fotoPath = $request->file('foto')->store('absensi', 'public');

    $jamMasuk = now();
    $status = $jamMasuk->format('H:i:s') <= '07:00:00'
        ? 'masuk'
        : 'terlambat';

    AbsensiMasukSekolah::create([
        'user_id'   => $user->id,
        'latitude'  => $request->latitude,
        'longitude' => $request->longitude,
        'jam_masuk' => $jamMasuk,
        'status'    => $status,
        'foto'      => $fotoPath,
    ]);

    return response()->json([
        'success' => true,
        'message' => 'Absensi berhasil',
        'status'  => $status,
    ]);
}


    private function hitungJarak($lat1, $lon1, $lat2, $lon2)
    {
        $earthRadius = 6371000;

        $dLat = deg2rad($lat2 - $lat1);
        $dLon = deg2rad($lon2 - $lon1);

        $a = sin($dLat / 2) * sin($dLat / 2) +
             cos(deg2rad($lat1)) * cos(deg2rad($lat2)) *
             sin($dLon / 2) * sin($dLon / 2);

        $c = 2 * atan2(sqrt($a), sqrt(1 - $a));

        return $earthRadius * $c;
    }
}
