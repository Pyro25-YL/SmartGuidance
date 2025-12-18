<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\NilaiUjian;
use App\Models\User;
use App\Models\Mapel;

class NilaiUjianController extends Controller
{
    // GET /api/nilai-ujian?murid_id=&mapel_id=&jenis_ujian=
    public function index(Request $request)
    {
        $q = NilaiUjian::query()
            ->with([
                'murid:id,name,nisn_nip,role',
                'mapel:id,nama_mapel'
            ])
            ->orderByDesc('id');

        if ($request->filled('murid_id')) $q->where('murid_id', $request->murid_id);
        if ($request->filled('mapel_id')) $q->where('mapel_id', $request->mapel_id);
        if ($request->filled('jenis_ujian')) $q->where('jenis_ujian', $request->jenis_ujian);

        return response()->json([
            'ok' => true,
            'data' => $q->get(),
        ]);
    }

    // GET /api/nilai-ujian/form
    public function form()
    {
        $mapel = Mapel::select('id', 'nama_mapel')->orderBy('nama_mapel')->get();
        $murid = User::select('id', 'name', 'nisn_nip', 'role')
            ->where('role', 'murid')
            ->orderBy('name')
            ->get();

        return response()->json([
            'ok' => true,
            'data' => [
                'mapel' => $mapel,
                'murid' => $murid,
                'jenis_ujian' => ['PTS', 'PAS'],
                'selected_mapel_id' => $mapel->first()->id ?? null,
                'selected_murid_id' => $murid->first()->id ?? null,
                'selected_jenis_ujian' => 'PTS',
            ],
        ]);
    }

    // POST /api/nilai-ujian
    public function store(Request $request)
    {
        $data = $request->validate([
            'murid_id' => 'required|exists:users,id',
            'mapel_id' => 'required|exists:mapel,id',
            'jenis_ujian' => 'required|in:PTS,PAS',
            'nilai' => 'required|integer|min:0|max:100',
        ]);

        // pastikan murid_id benar role murid
        $muridOk = User::where('id', $data['murid_id'])
            ->where('role', 'murid')
            ->exists();
        if (!$muridOk) {
            return response()->json([
                'ok' => false,
                'message' => 'murid_id bukan user dengan role murid',
            ], 422);
        }

        // upsert (kalau sudah ada, update nilainya)
        $row = NilaiUjian::updateOrCreate(
            [
                'murid_id' => $data['murid_id'],
                'mapel_id' => $data['mapel_id'],
                'jenis_ujian' => $data['jenis_ujian'],
            ],
            [
                'nilai' => $data['nilai'],
            ]
        );

        return response()->json([
            'ok' => true,
            'message' => 'Nilai ujian berhasil disimpan',
            'data' => $row->load(['murid', 'mapel']),
        ], 201);
    }
}
