<?php

use App\Http\Controllers\ProfileController;
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
    
require __DIR__.'/auth.php';
