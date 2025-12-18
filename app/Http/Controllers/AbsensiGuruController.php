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
use Illuminate\Http\JsonResponse;


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

public function formData(Request $request): JsonResponse
{
    // FE WAJIB kirim guru_id (id users yang login di Flutter)
    $validated = $request->validate([
        'guru_id' => ['required', 'exists:users,id'],
    ]);

    $guru = User::findOrFail($validated['guru_id']);

    // Tentukan nama hari dalam bahasa Indonesia
    $today = Carbon::now('Asia/Jakarta');
    $mapHari = [
        'Monday'    => 'Senin',
        'Tuesday'   => 'Selasa',
        'Wednesday' => 'Rabu',
        'Thursday'  => 'Kamis',
        'Friday'    => 'Jumat',
        'Saturday'  => 'Sabtu',
        'Sunday'    => 'Minggu',
    ];
    $hariIndo = $mapHari[$today->format('l')] ?? $today->format('l');

    // Ambil mapel milik guru ini, yang hari-nya = hari ini
    $mapelList = Mapel::with('kelas:id,nama_kelas')
        ->select('id','nama_mapel','kelas_id','jam_mulai','jam_akhir','hari')
        ->where('guru_id', $guru->id)
        ->where('hari', $hariIndo)
        ->orderBy('jam_mulai')
        ->get()
        ->map(function (Mapel $m) {
            return [
                'id'         => $m->id,
                'nama_mapel' => $m->nama_mapel,
                'jam_mulai'  => $m->jam_mulai,
                'jam_akhir'  => $m->jam_akhir,
                'hari'       => $m->hari,
                'kelas'      => $m->kelas ? [
                    'id'         => $m->kelas->id,
                    'nama_kelas' => $m->kelas->nama_kelas,
                ] : null,
            ];
        });

    $alamat = AlamatSekolah::first();

    return response()->json([
        'success' => true,
        'data'    => [
            'user'   => [
                'id'   => $guru->id,
                'name' => $guru->name,
                'role' => $guru->role,
            ],
            'mapel_list' => $mapelList,
            'alamat'     => $alamat ? [
                'latitude'           => $alamat->latitude,
                'longitude'          => $alamat->longitude,
                'radius_jarak_absen' => $alamat->radius_jarak_absen,
            ] : null,
        ],
    ]);
}


public function storeApi(Request $request): JsonResponse
{
    $validated = $request->validate([
        'mapel_id'    => ['required','exists:mapel,id'],
        'lat'         => ['required','numeric','between:-90,90'],
        'lon'         => ['required','numeric','between:-180,180'],
        'foto'        => ['nullable','image','max:3072'],
        'file_materi' => ['nullable','mimes:pdf,doc,docx,ppt,pptx,zip,rar','max:10240'],
        // opsional kalau mau kirim dari FE:
        'guru_id'     => ['nullable','exists:users,id'],
    ]);

    // ⛔ TIDAK PAKAI LOGIN / ROLE LAGI
    // $guru = $request->user();
    // if (!$guru || $guru->role !== 'guru') { ... }

    // Tentukan guru_id tanpa auth:
    if (!empty($validated['guru_id'] ?? null)) {
        // kalau FE kirim guru_id, pakai itu
        $guruId = (int) $validated['guru_id'];
    } else {
        // kalau tidak, pakai guru pertama di DB
        $guru = User::where('role', 'guru')->orderBy('id')->first();

        if (!$guru) {
            return response()->json([
                'success' => false,
                'message' => 'Belum ada guru di database.',
            ], 500);
        }

        $guruId = $guru->id;
    }

    // Ambil alamat sekolah
    $alamat = AlamatSekolah::first();
    if (!$alamat) {
        return response()->json([
            'success' => false,
            'message' => 'Alamat sekolah belum diset. Hubungi admin.',
        ], 422);
    }

    // Validasi jarak (Haversine)
    $jarakMeter = $this->haversine(
        $validated['lat'], $validated['lon'],
        (float)$alamat->latitude, (float)$alamat->longitude
    );

    if ($jarakMeter > (int)$alamat->radius_jarak_absen) {
        return response()->json([
            'success' => false,
            'message' => 'Di luar radius absen.',
            'detail'  => "Jarak Anda ~".number_format($jarakMeter, 0)." m, batas ".$alamat->radius_jarak_absen." m.",
            'jarak_meter' => $jarakMeter,
        ], 422);
    }

    // Validasi jam berada di antara jam_mulai dan jam_akhir
    $mapel = Mapel::select('id','jam_mulai','jam_akhir')->find($validated['mapel_id']);
    if (!$mapel) {
        return response()->json([
            'success' => false,
            'message' => 'Mapel tidak ditemukan.',
        ], 422);
    }

    $tz  = 'Asia/Jakarta';
    $now = Carbon::now($tz);

    $mulai = Carbon::createFromFormat(
        'H:i:s',
        strlen($mapel->jam_mulai) === 5 ? $mapel->jam_mulai.':00' : $mapel->jam_mulai,
        $tz
    );
    $akhir = Carbon::createFromFormat(
        'H:i:s',
        strlen($mapel->jam_akhir) === 5 ? $mapel->jam_akhir.':00' : $mapel->jam_akhir,
        $tz
    );

    if ($akhir->lt($mulai)) {
        $akhir->addDay();
        if ($now->lt($mulai)) {
            $now->addDay();
        }
    }

    if (!($now->betweenIncluded($mulai, $akhir))) {
        return response()->json([
            'success' => false,
            'message' => 'Di luar jam pelajaran.',
            'detail'  => "Jam aktif: ".$mulai->format('H:i')."–".$akhir->format('H:i')." WIB.",
            'jam_mulai' => $mulai->format('H:i'),
            'jam_akhir' => $akhir->format('H:i'),
        ], 422);
    }

    // Upload file
    $fotoPath = null;
    if ($request->hasFile('foto')) {
        $ext  = $request->file('foto')->getClientOriginalExtension();
        $nama = 'absen_'.Str::uuid().'.'.$ext;
        $p    = $request->file('foto')->storeAs('public/foto_absen', $nama);
        $fotoPath = str_replace('public/', 'storage/', $p);
    }

    $materiPath = null;
    if ($request->hasFile('file_materi')) {
        $ext  = $request->file('file_materi')->getClientOriginalExtension();
        $nama = 'materi_'.Str::uuid().'.'.$ext;
        $p    = $request->file('file_materi')->storeAs('public/materi', $nama);
        $materiPath = str_replace('public/', 'storage/', $p);
    }

    $absensi = AbsensiGuru::create([
        'guru_id'     => $guruId,
        'mapel_id'    => $validated['mapel_id'],
        'foto'        => $fotoPath,
        'file_materi' => $materiPath,
    ]);

    return response()->json([
        'success' => true,
        'message' => 'Absensi berhasil.',
        'data'    => [
            'id'          => $absensi->id,
            'guru_id'     => $absensi->guru_id,
            'mapel_id'    => $absensi->mapel_id,
            'foto'        => $absensi->foto,
            'file_materi' => $absensi->file_materi,
            'jarak_meter' => $jarakMeter,
        ],
    ], 201);
}


}
