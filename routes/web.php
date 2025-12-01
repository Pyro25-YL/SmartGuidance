<?php

use App\Http\Controllers\AbsensiGuruController;
use App\Http\Controllers\AlamatSekolahController;
use App\Http\Controllers\AnggotaKelasController;
use App\Http\Controllers\KelasController;
use App\Http\Controllers\MapelController;
use App\Http\Controllers\MateriController;
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

Route::get('/murid/dashboard', fn () => view('mobile_app.dashboard_mobile'))
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
    Route::get('/alamat-sekolah/{id}/edit', [AlamatSekolahController::class, 'edit'])->name('alamat-sekolah.edit');
    Route::put('/alamat-sekolah/{id}', [AlamatSekolahController::class, 'update'])->name('alamat-sekolah.update');
    Route::delete('/alamat-sekolah/{id}', [AlamatSekolahController::class, 'destroy'])->name('alamat-sekolah.destroy');
});


Route::middleware(['auth'])->group(function () {
    Route::get('/mapel/create', [MapelController::class, 'create'])->name('mapel.create');
    Route::post('/mapel',        [MapelController::class, 'store'])->name('mapel.store');

    // (Opsional) halaman list mapel
    // Route::get('/mapel', [MapelController::class, 'index'])->name('mapel.index');
});


Route::middleware(['auth'])->group(function () {
    Route::get('/absensi-guru/create', [AbsensiGuruController::class, 'create'])->name('absensi-guru.create');
    Route::post('/absensi-guru',        [AbsensiGuruController::class, 'store'])->name('absensi-guru.store');
});


Route::middleware(['auth'])->group(function () {
    Route::get('/materi', [MateriController::class, 'create'])->name('materi.create');
    Route::post('/materi', [MateriController::class, 'store'])->name('materi.store');
});
    
require __DIR__.'/auth.php';
