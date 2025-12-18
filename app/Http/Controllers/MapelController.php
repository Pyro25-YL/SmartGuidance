<?php

namespace App\Http\Controllers;

use App\Models\Mapel;
use App\Models\Kelas;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;

class MapelController extends Controller
{
    /**
     * GET /api/mapel
     * List semua mapel (untuk Flutter)
     */
    public function index(): JsonResponse
    {
        $mapel = Mapel::with(['kelas', 'guru'])
            ->orderBy('kelas_id')
            ->orderBy('jam_mulai')
            ->get();

        return response()->json([
            'success' => true,
            'data'    => $mapel->map(function (Mapel $m) {
                return [
                    'id'          => $m->id,
                    'nama_mapel'  => $m->nama_mapel,
                    'kelas_id'    => $m->kelas_id,
                    'kelas_nama'  => optional($m->kelas)->nama_kelas,
                    'hari'        => $m->hari,
                    'jam_mulai'   => $m->jam_mulai,
                    'jam_akhir'   => $m->jam_akhir,
                    'guru_id'     => $m->guru_id,
                    'guru_nama'   => optional($m->guru)->name,
                ];
            }),
        ]);
    }

    /**
     * POST /api/mapel
     * Simpan mapel baru (Flutter)
     */
    public function store(Request $request): JsonResponse
    {
        Log::info('MapelController@store - incoming request', [
            'payload' => $request->all(),
        ]);

        $validator = Validator::make($request->all(), [
            'nama_mapel' => ['required','string','max:255'],
            'kelas_id'   => ['required','exists:kelas,id'],
            'guru_id'    => ['required','exists:users,id'],
            'jam_mulai'  => ['required','date_format:H:i'],
            'hari'       => ['required','string'],
            'jam_akhir'  => ['required','date_format:H:i','after:jam_mulai'],
        ]);

        if ($validator->fails()) {
            Log::warning('MapelController@store - validation failed', [
                'errors'  => $validator->errors()->toArray(),
                'payload' => $request->all(),
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $validated = $validator->validated();

        // pastikan user memang role guru
        $guru = User::find($validated['guru_id']);
        if (! $guru || $guru->role !== 'guru') {
            Log::warning('MapelController@store - guru bukan role guru', [
                'guru_id'   => $validated['guru_id'],
                'guru_role' => $guru?->role,
            ]);

            return response()->json([
                'success' => false,
                'message' => 'User yang dipilih bukan guru.',
            ], 422);
        }

        $mapel = Mapel::create($validated);

        Log::info('MapelController@store - mapel created', [
            'mapel_id' => $mapel->id,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Mata pelajaran berhasil ditambahkan.',
            'data'    => [
                'id'          => $mapel->id,
                'nama_mapel'  => $mapel->nama_mapel,
                'kelas_id'    => $mapel->kelas_id,
                'hari'        => $mapel->hari,
                'jam_mulai'   => $mapel->jam_mulai,
                'jam_akhir'   => $mapel->jam_akhir,
                'guru_id'     => $mapel->guru_id,
            ],
        ], 201);
    }

    /**
     * GET /api/kelas-options
     * Dropdown kelas untuk form mapel
     */
    public function kelasOptions(): JsonResponse
    {
        $kelasList = Kelas::select('id','nama_kelas')
            ->orderBy('nama_kelas')
            ->get();

        return response()->json([
            'success' => true,
            'data'    => $kelasList,
        ]);
    }

    /**
     * GET /api/guru-options
     * Dropdown guru (role = guru) untuk form mapel
     */
    public function guruOptions(): JsonResponse
    {
        $guruList = User::where('role', 'guru')
            ->select('id','name')
            ->orderBy('name')
            ->get();

        return response()->json([
            'success' => true,
            'data'    => $guruList,
        ]);
    }
}
