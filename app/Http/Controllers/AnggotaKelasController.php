<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Kelas;
use Illuminate\Http\JsonResponse;

class AnggotaKelasController extends Controller
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
}
