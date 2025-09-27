<?php

namespace App\Http\Controllers;

use App\Models\Kelas;
use App\Models\User;
use Illuminate\Http\Request;

class KelasController extends Controller
{
    public function create()
    {
        // Ambil hanya user dengan role guru untuk dropdown wali kelas
        $guruList = User::where('role', 'guru')->select('id','name')->orderBy('name')->get();

        return view('kelas.create', compact('guruList'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'nama_kelas'   => ['required','string','max:255'],
            'jumlah_siswa' => ['required','integer','min:0'],
            'walikelas_id' => ['required','exists:users,id'],
        ]);

        // Pastikan yang dipilih benar-benar guru
        $wali = User::find($validated['walikelas_id']);
        if (!$wali || $wali->role !== 'guru') {
            return back()
                ->withErrors(['walikelas_id' => 'Walikelas harus seorang guru.'])
                ->withInput();
        }

        Kelas::create($validated);

        return redirect()->route('kelas.create')->with('status', 'Kelas berhasil ditambahkan.');
    }
}
