<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

class UserController extends Controller
{
    public function store(Request $request): JsonResponse
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
            $filename = Str::uuid()->toString().'.'.$request->file('foto')->getClientOriginalExtension();
            $request->file('foto')->storeAs('public/foto', $filename);
        }

        $user = User::create([
            'name'          => $validated['name'],
            'nisn_nip'      => $validated['nisn_nip'],
            'password'      => Hash::make($validated['password']),
            'role'          => $validated['role'],
            'jenis_kelamin' => $validated['jenis_kelamin'] ?? null,
            'foto'          => $filename,
        ]);

        // Opsional: bikin URL foto publik kalau sudah php artisan storage:link
        $fotoUrl = $filename
            ? asset('storage/foto/'.$filename)
            : null;

        return response()->json([
            'success' => true,
            'message' => 'User berhasil dibuat.',
            'data'    => [
                'id'            => $user->id,
                'name'          => $user->name,
                'nisn_nip'      => $user->nisn_nip,
                'role'          => $user->role,
                'jenis_kelamin' => $user->jenis_kelamin,
                'foto'          => $filename,
                'foto_url'      => $fotoUrl,
            ],
        ], 201);
    }
}
