<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\View\View;

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
public function store(LoginRequest $request): RedirectResponse
{
    $request->authenticate();

    $request->session()->regenerate();

    $user = Auth::user();

    // Redirect berdasarkan role
    switch ($user->role) {
        case 'admin':
            return redirect()->route('admin.dashboard');
        case 'guru_mapel':
            return redirect()->route('guru.dashboard');
        case 'wali_kelas':
            return redirect()->route('wali.dashboard');
        case 'murid':
            return redirect()->route('murid.dashboard');
        case 'wali_murid':
            return redirect()->route('walimurid.dashboard');
        default:
            // fallback kalau role gak dikenali
            return redirect()->route('dashboard');
    }
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
