<?php

namespace App\Http\Controllers;

use App\Models\Mapel;
use App\Models\Kelas;
use App\Models\User;
use Illuminate\Http\Request;

class MapelController extends Controller
{
 public function create()
{
    $kelasList = Kelas::select('id','nama_kelas')->get();
    $guruList  = User::where('role', 'guru')->select('id','name')->get();

    return view('mapel.create', compact('kelasList','guruList'));
}

public function store(Request $request)
{
    $validated = $request->validate([
        'nama_mapel' => ['required','string','max:255'],
        'kelas_id'   => ['required','exists:kelas,id'],
        'guru_id'    => ['required','exists:users,id'],
        'jam_mulai'  => ['required','date_format:H:i'],
        'hari'       => ['required','string'],
        'jam_akhir'  => ['required','date_format:H:i','after:jam_mulai'],
    ]);

    // pastikan user memang role guru
    $guru = User::find($validated['guru_id']);
    if ($guru->role !== 'guru') {
        return back()->withErrors(['guru_id' => 'User yang dipilih bukan guru.'])->withInput();
    }

    Mapel::create($validated);

    return redirect()->route('mapel.create')->with('status', 'Mata pelajaran berhasil ditambahkan.');
}


    // (Opsional) daftar mapel per kelas
    public function index()
    {
        $mapel = Mapel::with('kelas')->orderBy('kelas_id')->orderBy('jam_mulai')->get();
        return view('mapel.index', compact('mapel'));
    }
}
