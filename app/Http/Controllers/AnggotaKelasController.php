<?php

namespace App\Http\Controllers;

use App\Models\AnggotaKelas;
use App\Models\Kelas;
use App\Models\User;
use Illuminate\Http\Request;

class AnggotaKelasController extends Controller
{
    public function create()
    {
        $kelasList = Kelas::select('id','nama_kelas')->orderBy('nama_kelas')->get();

        // dropdown berisi hanya siswa & wali_murid
        $siswaList = User::where('role', 'murid')
            ->select('id','name','nisn_nip')
            ->orderBy('name')
            ->get();

        $ortuList = User::where('role', 'wali_murid')
            ->select('id','name','nisn_nip')
            ->orderBy('name')
            ->get();

        return view('anggota_kelas.create', compact('kelasList','siswaList','ortuList'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'kelas_id' => ['required','exists:kelas,id'],
            'siswa_id' => ['required','exists:users,id'],
            'ortu_id'  => ['nullable','exists:users,id'],
        ]);

        // Validasi role siswa = murid
        $siswa = User::find($validated['siswa_id']);
        if (!$siswa || $siswa->role !== 'murid') {
            return back()
                ->withErrors(['siswa_id' => 'User yang dipilih untuk siswa harus berperan sebagai murid.'])
                ->withInput();
        }

        // Validasi role ortu = wali_murid (jika dipilih)
        if (!empty($validated['ortu_id'])) {
            $ortu = User::find($validated['ortu_id']);
            if (!$ortu || $ortu->role !== 'wali_murid') {
                return back()
                    ->withErrors(['ortu_id' => 'User yang dipilih untuk orang tua harus berperan sebagai wali murid.'])
                    ->withInput();
            }
        }

        // Cegah duplikasi siswa di kelas yang sama
        $exists = AnggotaKelas::where('kelas_id', $validated['kelas_id'])
            ->where('siswa_id', $validated['siswa_id'])
            ->exists();

        if ($exists) {
            return back()
                ->withErrors(['siswa_id' => 'Siswa ini sudah terdaftar pada kelas tersebut.'])
                ->withInput();
        }

        AnggotaKelas::create($validated);

        return redirect()
            ->route('anggota-kelas.create')
            ->with('status', 'Anggota kelas berhasil ditambahkan.');
    }
}
