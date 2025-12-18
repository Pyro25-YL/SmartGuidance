<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Kelas;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class KelasController extends Controller
{
    public function index(): JsonResponse
    {
        // Ambil semua kelas + wali kelas + jumlah siswa
        $kelas = Kelas::with([
                'waliKelas' => function ($q) {
                    $q->select('id','name','nisn_nip','role');
                }
            ])
            ->withCount(['anggota as jumlah_siswa'])
            ->orderBy('nama_kelas')
            ->get();

        // Format response
        $data = $kelas->map(function ($k) {
            return [
                'id'            => $k->id,
                'nama_kelas'    => $k->nama_kelas,
                'jumlah_siswa'  => $k->jumlah_siswa ?? 0,
                'wali_kelas'    => $k->waliKelas ? [
                    'id'       => $k->waliKelas->id,
                    'name'     => $k->waliKelas->name,
                    'nisn_nip' => $k->waliKelas->nisn_nip,
                    'role'     => $k->waliKelas->role,
                ] : null,
            ];
        });

        return response()->json([
            'success' => true,
            'data'    => $data,
        ]);
    }

    public function apiStore(Request $request)
{
    $validated = $request->validate([
        'nama_kelas'   => ['required','string','max:255'],
        'jumlah_siswa' => ['required','integer','min:0'],
        'walikelas_id' => ['required','exists:users,id'],
    ]);

    // Validasi role guru
    $wali = User::find($validated['walikelas_id']);
    if (!$wali || $wali->role !== 'guru') {
        return response()->json([
            'success' => false,
            'message' => 'Walikelas harus seorang guru.',
        ], 422);
    }

    $kelas = Kelas::create($validated);

    return response()->json([
        'success' => true,
        'message' => 'Kelas berhasil ditambahkan.',
        'data' => [
            'id' => $kelas->id,
            'nama_kelas' => $kelas->nama_kelas,
            'jumlah_siswa' => $kelas->jumlah_siswa,
        ],
    ], 201);
}

public function apiGuruList()
{
    $guru = User::where('role', 'guru')
        ->select('id', 'name', 'nisn_nip') // pastikan kolom ini ada
        ->orderBy('name')
        ->get();

    return response()->json([
        'success' => true,
        'message' => 'Daftar guru berhasil diambil.',
        'data' => $guru,
    ]);
}

}
