<?php

namespace App\Http\Controllers;

use App\Models\Materi;
use App\Models\Mapel;
use App\Models\AbsensiGuru;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Str;

class MateriController extends Controller
{
    public function create(Request $request)
    {
        $user = Auth::user();

        if ($user->role !== 'guru') {
            abort(403, 'Hanya guru yang dapat mengakses halaman ini');
        }

        $mapHari = [
            0 => 'Minggu',
            1 => 'Senin',
            2 => 'Selasa',
            3 => 'Rabu',
            4 => 'Kamis',
            5 => 'Jumat',
            6 => 'Sabtu',
        ];

        // Pakai timezone Asia/Jakarta
        $now = Carbon::now('Asia/Jakarta');
        $hariIni = $mapHari[$now->dayOfWeek];

        $mapelHariIni = Mapel::where('guru_id', $user->id)
            ->whereRaw('LOWER(hari) = ?', [mb_strtolower($hariIni)])
            ->orderBy('jam_mulai')
            ->get();

        $selectedMapel = null;

        if ($request->has('mapel_id') && $request->mapel_id) {
            $mapelId = $request->mapel_id;

            $mapel = Mapel::where('id', $mapelId)
                ->where('guru_id', $user->id)
                ->firstOrFail();

            $today = Carbon::now('Asia/Jakarta')->toDateString();

            $sudahAbsen = AbsensiGuru::where('mapel_id', $mapelId)
                ->where('guru_id', $user->id)
                ->whereDate('created_at', $today)
                ->exists();

            if (! $sudahAbsen) {
                return redirect()
                    ->route('absensi-guru.create', ['mapel_id' => $mapelId])
                    ->with('status', 'Silakan isi absensi guru terlebih dahulu.');
            }

            $selectedMapel = $mapel;
        }

        return view('materi.create', [
            'mapelHariIni'  => $mapelHariIni,
            'selectedMapel' => $selectedMapel,
        ]);
    }

    public function store(Request $request)
    {
        $user = Auth::user();

        if ($user->role !== 'guru') {
            abort(403, 'Hanya guru yang dapat mengakses halaman ini');
        }

        $request->validate([
            'mapel_id' => 'required|exists:mapel,id',
            'materi'   => 'required|string',
        ]);

        $mapel = Mapel::where('id', $request->mapel_id)
            ->where('guru_id', $user->id)
            ->firstOrFail();

        Materi::create([
            'mapel_id' => $mapel->id,
            'materi'   => $request->materi,
        ]);

        return redirect()
            ->route('materi.create')
            ->with('status', 'Materi berhasil disimpan.');
    }

    /**
     * API: form data input materi (mapel hari ini + optional selected mapel)
     * GET /api/materi/form?guru_id=...&mapel_id=...
     */
    public function createApi(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'guru_id'  => ['required', 'exists:users,id'],
            'mapel_id' => ['nullable', 'exists:mapel,id'],
        ]);

        $guruId = (int) $validated['guru_id'];

        $mapHari = [
            0 => 'Minggu',
            1 => 'Senin',
            2 => 'Selasa',
            3 => 'Rabu',
            4 => 'Kamis',
            5 => 'Jumat',
            6 => 'Sabtu',
        ];

        $nowJakarta = Carbon::now('Asia/Jakarta');
        $hariIni    = $mapHari[$nowJakarta->dayOfWeek];
        $hariIniLower = mb_strtolower($hariIni);

        // === DEBUG LOG UTAMA ===
        Log::info('=== DEBUG MATERI FORM API ===', [
            'request_guru_id'       => $request->guru_id,
            'validated_guru_id'     => $guruId,
            'server_timezone'       => config('app.timezone'),
            'carbon_now_default'    => Carbon::now()->toDateTimeString(),
            'carbon_now_jakarta'    => $nowJakarta->toDateTimeString(),
            'day_of_week_default'   => Carbon::now()->dayOfWeek,
            'day_of_week_jakarta'   => $nowJakarta->dayOfWeek,
            'hariIni_dari_map'      => $hariIni,
            'hariIni_lower'         => $hariIniLower,
            'semua_mapel_hari_guru_ini' => Mapel::where('guru_id', $guruId)->pluck('hari'),
        ]);

        $mapelHariIni = Mapel::with('kelas:id,nama_kelas')
            ->where('guru_id', $guruId)
            ->whereRaw('LOWER(hari) = ?', [$hariIniLower])
            ->orderBy('jam_mulai')
            ->get();

        Log::info('=== DEBUG HASIL FILTER MAPEL HARI INI ===', [
            'filtered_count' => $mapelHariIni->count(),
            'filtered_items' => $mapelHariIni->map(function (Mapel $m) {
                return [
                    'id'         => $m->id,
                    'nama_mapel' => $m->nama_mapel,
                    'hari'       => $m->hari,
                    'jam_mulai'  => $m->jam_mulai,
                    'jam_akhir'  => $m->jam_akhir,
                    'kelas'      => optional($m->kelas)->nama_kelas,
                ];
            }),
        ]);

        $selectedMapel = null;
        $needAbsensi   = false;
        $absensiMsg    = null;

        if (!empty($validated['mapel_id'])) {
            $mapelId = (int) $validated['mapel_id'];

            $mapel = Mapel::with('kelas:id,nama_kelas')
                ->where('id', $mapelId)
                ->where('guru_id', $guruId)
                ->first();

            if ($mapel) {
                $today = Carbon::now('Asia/Jakarta')->toDateString();

                $sudahAbsen = AbsensiGuru::where('mapel_id', $mapelId)
                    ->where('guru_id', $guruId)
                    ->whereDate('created_at', $today)
                    ->exists();

                if (!$sudahAbsen) {
                    $needAbsensi = true;
                    $absensiMsg  = 'Silakan isi absensi guru terlebih dahulu.';
                } else {
                    $selectedMapel = $mapel;
                }
            }

            Log::info('=== DEBUG CHECK SELECTED MAPEL ===', [
                'input_mapel_id'        => $mapelId,
                'selected_mapel_exists' => (bool)$selectedMapel,
                'need_absensi'          => $needAbsensi,
                'absensi_message'       => $absensiMsg,
            ]);
        }

        return response()->json([
            'success'        => true,
            'need_absensi'   => $needAbsensi,
            'absensi_message'=> $absensiMsg,
            'data'           => [
                'mapel_hari_ini' => $mapelHariIni->map(function (Mapel $m) {
                    return [
                        'id'         => $m->id,
                        'nama_mapel' => $m->nama_mapel,
                        'nama_kelas' => $m->kelas->nama_kelas ?? null,
                        'jam_mulai'  => substr($m->jam_mulai, 0, 5),
                        'jam_akhir'  => substr($m->jam_akhir, 0, 5),
                    ];
                }),
                'selected_mapel' => $selectedMapel ? [
                    'id'         => $selectedMapel->id,
                    'nama_mapel' => $selectedMapel->nama_mapel,
                    'nama_kelas' => optional($selectedMapel->kelas)->nama_kelas,
                    'jam_mulai'  => substr($selectedMapel->jam_mulai, 0, 5),
                    'jam_akhir'  => substr($selectedMapel->jam_akhir, 0, 5),
                ] : null,
            ],
        ]);
    }

    /**
     * API: simpan materi
     * POST /api/materi
     */
public function storeApi(Request $request): JsonResponse
{
    $validated = $request->validate([
        'guru_id'     => ['required', 'exists:users,id'],
        'mapel_id'    => ['required', 'exists:mapel,id'],
        'file_materi' => ['required','mimes:pdf,doc,docx,ppt,pptx,zip,rar','max:10240'],
    ]);

    $guruId  = (int) $validated['guru_id'];
    $mapelId = (int) $validated['mapel_id'];

    $mapel = Mapel::where('id', $mapelId)
        ->where('guru_id', $guruId)
        ->firstOrFail();

    $filePath = null;
    if ($request->hasFile('file_materi')) {
        $ext  = $request->file('file_materi')->getClientOriginalExtension();
        $nama = 'materi_'.Str::uuid().'.'.$ext;
        $p    = $request->file('file_materi')->storeAs('public/materi', $nama);
        $filePath = str_replace('public/', 'storage/', $p);
    }

    $materi = Materi::create([
        'mapel_id'  => $mapel->id,
        'file_path' => $filePath,   // pastikan kolom ini ada di tabel materi
    ]);

    return response()->json([
        'success' => true,
        'message' => 'Materi berhasil disimpan.',
        'data'    => [
            'id'        => $materi->id,
            'mapel_id'  => $materi->mapel_id,
            'file_path' => $materi->file_path,
        ],
    ], 201);
}


    /**
     * API: ambil materi (misal terakhir) untuk 1 mapel
     * GET /api/materi/by-mapel?guru_id=...&mapel_id=...
     */
    public function showForMapelApi(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'guru_id'  => ['required', 'exists:users,id'],
            'mapel_id' => ['required', 'exists:mapel,id'],
        ]);

        $guruId  = (int) $validated['guru_id'];
        $mapelId = (int) $validated['mapel_id'];

        $mapel = Mapel::where('id', $mapelId)
            ->where('guru_id', $guruId)
            ->firstOrFail();

        $materi = Materi::where('mapel_id', $mapel->id)
            ->orderByDesc('id')
            ->first();

        return response()->json([
            'success' => true,
            'data'    => [
                'mapel_id' => $mapel->id,
                'materi'   => $materi?->materi,
            ],
        ]);
    }
}
