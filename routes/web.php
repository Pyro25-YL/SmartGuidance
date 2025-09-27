<?php

use App\Http\Controllers\AlamatSekolahController;
use App\Http\Controllers\AnggotaKelasController;
use App\Http\Controllers\KelasController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\UserController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/dashboard', function () {
    return view('dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

Route::get('/admin/dashboard', fn () => view('dashboard.admin'))
    ->name('admin.dashboard');

Route::get('/guru/dashboard', fn () => view('dashboard.guru'))
    ->name('guru.dashboard');

Route::get('/wali/dashboard', fn () => view('dashboard.wali'))
    ->name('wali.dashboard');

Route::get('/murid/dashboard', fn () => view('dashboard.murid'))
    ->name('murid.dashboard');

Route::get('/walimurid/dashboard', fn () => view('dashboard.walimurid'))
    ->name('walimurid.dashboard');

    Route::middleware(['auth'])->group(function () {
    Route::get('/users/create', [UserController::class, 'create'])->name('users.create');
    Route::post('/users', [UserController::class, 'store'])->name('users.store');
});

Route::middleware(['auth'])->group(function () {
    Route::get('/kelas/create', [KelasController::class, 'create'])->name('kelas.create');
    Route::post('/kelas', [KelasController::class, 'store'])->name('kelas.store');
});

Route::middleware(['auth'])->group(function () {
    Route::get('/anggota-kelas/create', [AnggotaKelasController::class, 'create'])->name('anggota-kelas.create');
    Route::post('/anggota-kelas', [AnggotaKelasController::class, 'store'])->name('anggota-kelas.store');
});


Route::middleware(['auth'])->group(function () {
    Route::get('/alamat-sekolah/create', [AlamatSekolahController::class, 'create'])->name('alamat-sekolah.create');
    Route::post('/alamat-sekolah', [AlamatSekolahController::class, 'store'])->name('alamat-sekolah.store');
});
    
require __DIR__.'/auth.php';
