<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class UserController extends Controller
{
    public function create()
    {
        return view('users.create');
    }

    public function store(Request $request)
    {
        $roles = ['admin', 'guru', 'murid', 'wali_murid'];

        $validated = $request->validate([
            'name'           => ['required','string','max:255'],
            'nisn_nip'       => ['required','numeric','unique:users,nisn_nip'],
            'password'       => ['required','string','min:6'],
            'role'           => ['required', Rule::in($roles)],
            'jenis_kelamin'  => ['nullable', Rule::in(['L','P'])],
            'foto'           => ['nullable','image','max:102400'], // 100MB
        ]);

        // Handle upload foto (opsional)
        $filename = null;
        if ($request->hasFile('foto')) {
            // Simpan ke storage/app/public/foto
            $filename = Str::uuid()->toString().'.'.$request->file('foto')->getClientOriginalExtension();
            $request->file('foto')->storeAs('public/foto', $filename);
        }

        User::create([
            'name'          => $validated['name'],
            'nisn_nip'         => $validated['nisn_nip'],
            'password'      => Hash::make($validated['password']),
            'role'          => $validated['role'],
            'jenis_kelamin' => $validated['jenis_kelamin'] ?? null,
            'foto'          => $filename,
        ]);

        return redirect()->route('users.create')->with('status', 'User berhasil dibuat.');
    }
}
