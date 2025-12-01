<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use App\Models\User;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\View\View;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Hash;

class AuthenticatedSessionController extends Controller
{
    /**
     * Display the login view.
     */
    public function create(): View
    {
        return view('auth.login');
    }

    /**
     * Handle an incoming authentication request.
     */
public function store(LoginRequest $request): JsonResponse
{
        // 1) Validasi input
        $validated = $request->validate([
            'name'      => ['required', 'string', 'max:255'],
            'nisn_nip'  => ['required', 'numeric'],
            'password'  => ['required', 'string'],
        ]);

        // 2) Cari user berdasarkan name + (nisn atau nip)
        $user = User::where('name', $validated['name'])
            ->where(function ($q) use ($validated) {
                $q->where('nisn_nip', $validated['nisn_nip']);
            })
            ->first();

        // 3) Jika user tidak ditemukan atau password salah
        if (! $user || ! Hash::check($validated['password'], $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Nama / NISN / NIP atau password salah.',
            ], 401);
        }

        // 4) Validasi role yang diizinkan
        $allowedRoles = ['admin', 'guru', 'murid', 'wali_murid'];

        if (! in_array($user->role, $allowedRoles, true)) {
            return response()->json([
                'success' => false,
                'message' => 'Role pengguna tidak valid.',
                'detail'  => 'Role ditemukan: '.$user->role,
            ], 403);
        }

        // (OPSIONAL) kalau mau pakai Sanctum token:
        // $token = $user->createToken('flutter')->plainTextToken;

        // 5) Return JSON untuk Flutter (TANPA session, TANPA CSRF)
        return response()->json([
            'success' => true,
            'message' => 'Login berhasil.',
            'role'    => $user->role,
            'user'    => [
                'id'    => $user->id,
                'name'  => $user->name,
                'nisn_nip' => $user->nisn_nip,  
                'role'  => $user->role,
            ],
            // 'token'  => $token ?? null, // kalau nanti pakai token
        ]);
    
}


    /**
     * Destroy an authenticated session.
     */
    public function destroy(Request $request): RedirectResponse
    {
        Auth::guard('web')->logout();

        $request->session()->invalidate();

        $request->session()->regenerateToken();

        return redirect('/');
    }
}
