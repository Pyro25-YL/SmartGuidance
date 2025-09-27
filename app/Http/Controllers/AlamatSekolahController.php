<?php

namespace App\Http\Controllers;

use App\Models\AlamatSekolah;
use Illuminate\Http\Request;

class AlamatSekolahController extends Controller
{
    public function create()
    {
        $alamat = AlamatSekolah::first();
        if ($alamat) {
            return redirect()->route('alamat-sekolah.edit', $alamat->id);
        }
        return view('alamat_sekolah.create', ['alamat' => null]);
    }

    public function store(Request $request)
    {
        // Jika sudah ada record, alihkan ke edit
        if (AlamatSekolah::exists()) {
            $alamat = AlamatSekolah::first();
            return redirect()->route('alamat-sekolah.edit', $alamat->id)
                ->with('status', 'Alamat sudah ada. Silakan edit.');
        }

        $validated = $request->validate([
            'latitude'           => ['required','numeric','between:-90,90'],
            'longitude'          => ['required','numeric','between:-180,180'],
            'radius_jarak_absen' => ['required','integer','min:1','max:100000'],
            'alamat'          => ['nullable','string','max:255'], 
        ]);

        // set singleton = 1 agar unik
        $validated['singleton'] = 1;

        $alamat = AlamatSekolah::create($validated);

        return redirect()->route('alamat-sekolah.edit', $alamat->id)
            ->with('status', 'Alamat sekolah berhasil dibuat.');
    }

    public function edit($id)
    {
        $alamat = AlamatSekolah::findOrFail($id);
        return view('alamat_sekolah.create', compact('alamat'));
    }

    public function update(Request $request, $id)
    {
        $alamat = AlamatSekolah::findOrFail($id);

        $validated = $request->validate([
            'latitude'           => ['required','numeric','between:-90,90'],
            'longitude'          => ['required','numeric','between:-180,180'],
            'radius_jarak_absen' => ['required','integer','min:1','max:100000'],
        ]);

        $alamat->update($validated);

        return back()->with('status', 'Alamat sekolah berhasil diperbarui.');
    }

    public function destroy($id)
    {
        $alamat = AlamatSekolah::findOrFail($id);
        $alamat->delete();

        return redirect()->route('alamat-sekolah.create')
            ->with('status', 'Alamat sekolah dihapus. Silakan tambahkan yang baru.');
    }
}
