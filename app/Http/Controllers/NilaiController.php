<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Mapel;
use Illuminate\Http\Request;
use App\Models\Nilai;
use App\Models\User;

class NilaiController extends Controller
{
    public function index(Request $request)
    {
        $guruId = $request->query('guru_id');
        if (!$guruId) {
            return response()->json([
                'ok' => false,
                'message' => 'Parameter guru_id wajib diisi'
            ], 422);
        }

        $rows = Nilai::query()
            ->with([
                'mapel:id,nama_mapel',
                'murid:id,name,nisn_nip',
                'guru:id,name,nisn_nip',
            ])
            ->where('guru_id', $guruId)
            ->orderByDesc('id')
            ->get();

        return response()->json([
            'ok' => true,
            'data' => $rows,
        ]);
    }
    // GET /api/nilai/form?guru_id=1
    public function form(Request $request)
    {
        $guruId = $request->query('guru_id');
        if (!$guruId) {
            return response()->json(['ok'=>false,'message'=>'Parameter guru_id wajib diisi'], 422);
        }

        // Mapel (opsi sederhana: semua mapel)
        // Kalau kamu punya relasi mapel milik guru, filter di sini.
        $mapel = Mapel::query()
            ->select('id', 'nama_mapel')
            ->orderBy('nama_mapel')
            ->get();

        // Murid: users dengan role murid
        $murid = User::query()
            ->select('id', 'name', 'nisn_nip')
            ->where('role', 'murid')
            ->orderBy('name')
            ->get();

        return response()->json([
            'ok' => true,
            'data' => [
                'mapel' => $mapel,
                'murid' => $murid,
                'selected_mapel_id' => $mapel->first()->id ?? null,
                'selected_murid_id' => $murid->first()->id ?? null,
            ],
        ]);
    }

    // POST /api/nilai
    // body: {guru_id,mapel_id,murid_id,nilai}
    public function store(Request $request)
    {
        $data = $request->validate([
            'guru_id'  => 'required|exists:users,id',
            'mapel_id' => 'required|exists:mapel,id',
            'murid_id' => 'required|exists:users,id',
            'nilai'    => 'required|integer|min:0|max:100',
        ]);

        // cek role murid (biar aman)
        $muridOk = User::where('id', $data['murid_id'])->where('role','murid')->exists();
        if (!$muridOk) {
            return response()->json(['ok'=>false,'message'=>'User murid_id bukan role murid'], 422);
        }

        // (opsional) cek guru role
        $guruOk = User::where('id', $data['guru_id'])->where('role','guru')->exists();
        if (!$guruOk) {
            return response()->json(['ok'=>false,'message'=>'User guru_id bukan role guru'], 422);
        }

        $row = Nilai::create($data);

        return response()->json([
            'ok' => true,
            'message' => 'Nilai berhasil disimpan',
            'data' => $row->load(['mapel','murid','guru']),
        ], 201);
    }
}