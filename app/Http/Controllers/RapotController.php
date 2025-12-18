<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Rapot;
use App\Models\User;
use App\Models\Mapel;
use App\Models\Kelas;
use App\Models\AnggotaKelas; // pastikan ada model ini
use Illuminate\Support\Facades\DB;

class RapotController extends Controller
{
    // GET /api/rapot?murid_id=&kelas_id=&mapel_id=&semester=
    public function index(Request $request)
    {
        $q = Rapot::query()
            ->with([
                'murid:id,name,nisn_nip,role',
                'kelas:id,nama_kelas',
                'mapel:id,nama_mapel',
            ])
            ->orderByDesc('id');

        if ($request->filled('murid_id')) $q->where('murid_id', $request->murid_id);
        if ($request->filled('kelas_id')) $q->where('kelas_id', $request->kelas_id);
        if ($request->filled('mapel_id')) $q->where('mapel_id', $request->mapel_id);
        if ($request->filled('semester')) $q->where('semester', $request->semester);

        return response()->json([
            'ok' => true,
            'data' => $q->get(),
        ]);
    }

    // GET /api/rapot/form
public function form()
{
    $murid = User::select('id','name','nisn_nip','role')
        ->where('role','murid')
        ->orderBy('name')
        ->get();

    $mapel = Mapel::select('id','nama_mapel')
        ->orderBy('nama_mapel')
        ->get();

    $kelas = Kelas::select('id','nama_kelas')
        ->orderBy('nama_kelas')
        ->get();

    $semester = ['Ganjil', 'Genap'];

    return response()->json([
        'ok' => true,
        'data' => [
            'murid' => $murid,
            'mapel' => $mapel,
            'kelas' => $kelas,
            'semester' => $semester,

            'selected_murid_id' => $murid->first()->id ?? null,
            'selected_mapel_id' => $mapel->first()->id ?? null,
            'selected_kelas_id' => $kelas->first()->id ?? null,
            'selected_semester' => 'Ganjil',
        ],
    ]);
}


    // POST /api/rapot
    // body: {murid_id, mapel_id, semester, nilai}
    // kelas_id otomatis dari anggota_kelas berdasarkan siswa_id = murid_id
    public function store(Request $request)
    {
        $data = $request->validate([
            'murid_id' => 'required|exists:users,id',
            'mapel_id' => 'required|exists:mapel,id',
            'semester' => 'required|string|max:30',
            'nilai'    => 'required|integer|min:0|max:100',
        ]);

        // pastikan murid role = murid
        $muridOk = User::where('id', $data['murid_id'])
            ->where('role', 'murid')
            ->exists();
        if (!$muridOk) {
            return response()->json(['ok'=>false,'message'=>'murid_id bukan role murid'], 422);
        }

        // ambil kelas_id dari anggota_kelas
        // asumsi tabel anggota_kelas: siswa_id, kelas_id
        $kelasId = AnggotaKelas::where('siswa_id', $data['murid_id'])->value('kelas_id');
        if (!$kelasId) {
            return response()->json(['ok'=>false,'message'=>'Murid belum terdaftar di kelas (anggota_kelas)'], 422);
        }

        // simpan/update (hindari duplikat)
        $row = Rapot::updateOrCreate(
            [
                'murid_id' => $data['murid_id'],
                'kelas_id' => $kelasId,
                'mapel_id' => $data['mapel_id'],
                'semester' => $data['semester'],
            ],
            [
                'nilai' => $data['nilai'],
            ]
        );

        return response()->json([
            'ok' => true,
            'message' => 'Rapot berhasil disimpan',
            'data' => $row->load(['murid','kelas','mapel']),
        ], 201);
    }
    public function avg(Request $request)
{
    $muridId = $request->query('murid_id');
    $mapelId = $request->query('mapel_id');

    if (!$muridId || !$mapelId) {
        return response()->json([
            'ok' => false,
            'message' => 'murid_id dan mapel_id wajib diisi'
        ], 422);
    }

    // tabel nilai
    $a = DB::table('nilai')
        ->where('murid_id', $muridId)
        ->where('mapel_id', $mapelId)
        ->selectRaw('COUNT(*) as cnt, COALESCE(SUM(nilai),0) as sum')
        ->first();

    // tabel nilai_ujian (PTS/PAS)
    $b = DB::table('nilai_ujian')
        ->where('murid_id', $muridId)
        ->where('mapel_id', $mapelId)
        ->selectRaw('COUNT(*) as cnt, COALESCE(SUM(nilai),0) as sum')
        ->first();

    $cnt = ((int)$a->cnt) + ((int)$b->cnt);
    $sum = ((int)$a->sum) + ((int)$b->sum);

    $avg = $cnt > 0 ? round($sum / $cnt, 2) : null;

    return response()->json([
        'ok' => true,
        'data' => [
            'murid_id' => (int)$muridId,
            'mapel_id' => (int)$mapelId,
            'count_total' => $cnt,
            'avg' => $avg,
        ],
    ]);
}

}
