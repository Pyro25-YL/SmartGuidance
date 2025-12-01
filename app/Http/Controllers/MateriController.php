<?php

namespace App\Http\Controllers;

use App\Models\Materi;
use App\Models\Mapel;
use App\Models\AbsensiGuru;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;

class MateriController extends Controller
{
    public function create(Request $request)
    {
        $user = Auth::user();

        // Cek role dari kolom 'role' di tabel users
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

        $hariIni = $mapHari[Carbon::now()->dayOfWeek];

        // Ambil mapel dari tabel 'mapel'
        $mapelHariIni = Mapel::where('guru_id', $user->id)
            ->where('hari', $hariIni)
            ->orderBy('jam_mulai')
            ->get();

        $selectedMapel = null;

        if ($request->has('mapel_id') && $request->mapel_id) {
            $mapelId = $request->mapel_id;

            // Pastikan mapel ini milik guru login
            $mapel = Mapel::where('id', $mapelId)
                ->where('guru_id', $user->id)
                ->firstOrFail();

            $today = Carbon::today()->toDateString();

            // Cek absensi_guru hari ini
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
            'mapel_id' => 'required|exists:mapel,id', // pakai tabel 'mapel'
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
}
