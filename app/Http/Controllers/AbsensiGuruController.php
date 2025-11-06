<?php

namespace App\Http\Controllers;

use App\Models\AbsensiGuru;
use App\Models\Mapel;
use App\Models\User;
use App\Models\AlamatSekolah;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Carbon\Carbon;
use Illuminate\Support\Facades\Auth;

class AbsensiGuruController extends Controller
{
    public function create()
    {
        $guruList  = User::where('role', 'guru')->select('id','name')->orderBy('name')->get();
        $mapelList = Mapel::with('kelas:id,nama_kelas')->select('id','nama_mapel','kelas_id','jam_mulai','jam_akhir')->orderBy('nama_mapel')->get();

        $alamat = AlamatSekolah::first(); // kita pakai record singleton
        // Kalau belum ada alamat sekolah, sebaiknya admin isi dulu
        return view('absensi_guru.create', compact('guruList','mapelList','alamat'));
    }

    public function store(Request $request)
    {
    $validated = $request->validate([
        'mapel_id'    => ['required','exists:mapel,id'],
        'lat'         => ['required','numeric','between:-90,90'],
        'lon'         => ['required','numeric','between:-180,180'],
        'foto'        => ['nullable','image','max:3072'],
        'file_materi' => ['nullable','mimes:pdf,doc,docx,ppt,pptx,zip,rar','max:10240'],
    ]);

    $guru = Auth::user();

    if (!$guru || $guru->role !== 'guru') {
        return back()->withErrors(['guru_id' => 'Hanya guru yang dapat melakukan absen.']);
    }

        // Ambil alamat sekolah (harus ada)
        $alamat = AlamatSekolah::first();
        if (!$alamat) {
            return back()->withErrors(['lat' => 'Alamat sekolah belum diset. Hubungi admin.'])->withInput();
        }

        // Validasi jarak (Haversine) -> meter
        $jarakMeter = $this->haversine(
            $validated['lat'], $validated['lon'],
            (float)$alamat->latitude, (float)$alamat->longitude
        );

        if ($jarakMeter > (int)$alamat->radius_jarak_absen) {
            return back()->withErrors([
                'lat' => "Di luar radius absen. Jarak Anda ~".number_format($jarakMeter, 0)." m, batas ".$alamat->radius_jarak_absen." m."
            ])->withInput();
        }

        // Validasi jam berada di antara jam_mulai dan jam_akhir mapel (waktu server Asia/Jakarta)
        $mapel = Mapel::select('id','jam_mulai','jam_akhir')->find($validated['mapel_id']);
        if (!$mapel) {
            return back()->withErrors(['mapel_id' => 'Mapel tidak ditemukan.'])->withInput();
        }

        $tz  = 'Asia/Jakarta';
        $now = Carbon::now($tz);
        $mulai = Carbon::createFromFormat('H:i:s', strlen($mapel->jam_mulai) === 5 ? $mapel->jam_mulai.':00' : $mapel->jam_mulai, $tz);
        $akhir = Carbon::createFromFormat('H:i:s', strlen($mapel->jam_akhir) === 5 ? $mapel->jam_akhir.':00' : $mapel->jam_akhir, $tz);

        // Jika jam akhir < jam mulai (melewati tengah malam), geser jam_akhir +1 hari
        if ($akhir->lt($mulai)) {
            $akhir->addDay();
            if ($now->lt($mulai)) { // kalau sekarang sebelum mulai, asumsikan kita sudah melewati tengah malam
                $now->addDay();
            }
        }

        if (!($now->betweenIncluded($mulai, $akhir))) {
            return back()->withErrors([
                'mapel_id' => "Di luar jam pelajaran. Jam aktif: ".$mulai->format('H:i')."–".$akhir->format('H:i')." WIB."
            ])->withInput();
        }

        // Upload file
        $fotoPath = null;
        if ($request->hasFile('foto')) {
            $ext = $request->file('foto')->getClientOriginalExtension();
            $nama = 'absen_'.Str::uuid().'.'.$ext;
            $p = $request->file('foto')->storeAs('public/foto_absen', $nama);
            $fotoPath = str_replace('public/', 'storage/', $p);
        }

        $materiPath = null;
        if ($request->hasFile('file_materi')) {
            $ext = $request->file('file_materi')->getClientOriginalExtension();
            $nama = 'materi_'.Str::uuid().'.'.$ext;
            $p = $request->file('file_materi')->storeAs('public/materi', $nama);
            $materiPath = str_replace('public/', 'storage/', $p);
        }

        AbsensiGuru::create([
            'guru_id'     => $guru->id,
            'mapel_id'    => $validated['mapel_id'],
            'foto'        => $fotoPath,
            'file_materi' => $materiPath,
        ]);

        return redirect()->route('absensi-guru.create')->with('status', 'Absensi berhasil. Jarak ~'.number_format($jarakMeter,0).' m.');
    }

    /**
     * Haversine distance (meters)
     */
    private function haversine($lat1, $lon1, $lat2, $lon2): float
    {
        $R = 6371000; // meters
        $φ1 = deg2rad($lat1);
        $φ2 = deg2rad($lat2);
        $Δφ = deg2rad($lat2 - $lat1);
        $Δλ = deg2rad($lon2 - $lon1);

        $a = sin($Δφ/2) * sin($Δφ/2) +
             cos($φ1) * cos($φ2) *
             sin($Δλ/2) * sin($Δλ/2);

        $c = 2 * atan2(sqrt($a), sqrt(1-$a));
        return $R * $c;
    }
}
