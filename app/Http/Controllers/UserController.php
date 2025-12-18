<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\Storage; 

class UserController extends Controller
{

        public function index(): JsonResponse
    {
        $users = User::orderBy('name')->get();

        return response()->json([
            'success' => true,
            'data'    => $users->map(function (User $user) {
                return [
                    'id'           => $user->id,
                    'name'         => $user->name,
                    'nisn_nip'     => $user->nisn_nip,
                    'role'         => $user->role,
                    'jenis_kelamin'=> $user->jenis_kelamin,
                    'foto'         => $user->foto,
                    'foto_url'     => $user->foto
                        ? asset('storage/foto/'.$user->foto)
                        : null,
                ];
            }),
        ]);
    }
    
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
    $extension = $request->file('foto')->getClientOriginalExtension();
    $filename = Str::uuid()->toString() . '.' . $extension;

    // ✅ Simpan di disk "public", folder "foto"
    $request->file('foto')->storeAs(
        'foto',          // folder di dalam storage/app/public
        $filename,
        'public'         // nama disk (lihat config/filesystems.php)
    );
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
                
            ],
        ], 201);
    }
    public function update(Request $request, User $user): JsonResponse
{
    $roles = ['admin', 'guru', 'murid', 'wali_murid'];

    // (OPSIONAL) mapping dari teks ke kode, kalau FE kirim "Laki-laki"/"Perempuan"
    if ($request->filled('jenis_kelamin')) {
        $jk = $request->input('jenis_kelamin');
        if ($jk === 'Laki-laki') {
            $request->merge(['jenis_kelamin' => 'L']);
        } elseif ($jk === 'Perempuan') {
            $request->merge(['jenis_kelamin' => 'P']);
        }
    }

    $validated = $request->validate([
        'name'          => ['sometimes','required','string','max:255'],
        'nisn_nip'      => [
            'sometimes',
            'required',
            'numeric',
            Rule::unique('users', 'nisn_nip')->ignore($user->id),
        ],
        'password'      => ['sometimes','nullable','string','min:6'],
        'role'          => ['sometimes','required', Rule::in($roles)],
        'jenis_kelamin' => ['nullable', Rule::in(['L','P'])],
        'foto'          => ['nullable','image','max:102400'],
    ]);

    // Update field dasar (kalau ada di request)
    if (array_key_exists('name', $validated)) {
        $user->name = $validated['name'];
    }
    if (array_key_exists('nisn_nip', $validated)) {
        $user->nisn_nip = $validated['nisn_nip'];
    }
    if (array_key_exists('role', $validated)) {
        $user->role = $validated['role'];
    }
    if (array_key_exists('jenis_kelamin', $validated)) {
        $user->jenis_kelamin = $validated['jenis_kelamin'];
    }

    // Password opsional
    if (!empty($validated['password'] ?? null)) {
        $user->password = Hash::make($validated['password']);
    }

    // Handle upload foto (opsional)
    if ($request->hasFile('foto')) {
        // Hapus foto lama kalau ada
        if ($user->foto) {
            Storage::disk('public')->delete('foto/'.$user->foto);
        }

        $extension = $request->file('foto')->getClientOriginalExtension();
        $filename = Str::uuid()->toString().'.'.$extension;

        $request->file('foto')->storeAs(
            'foto',
            $filename,
            'public'
        );

        $user->foto = $filename;
    }

    $user->save();

    $fotoUrl = $user->foto
        ? asset('storage/foto/'.$user->foto)
        : null;

    return response()->json([
        'success' => true,
        'message' => 'User berhasil diperbarui.',
        'data'    => [
            'id'            => $user->id,
            'name'          => $user->name,
            'nisn_nip'      => $user->nisn_nip,
            'role'          => $user->role,
            'jenis_kelamin' => $user->jenis_kelamin,
            'foto'          => $user->foto,
            'foto_url'      => $fotoUrl,
        ],
    ]);
}

}
