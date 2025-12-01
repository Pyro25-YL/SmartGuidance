<?php

use App\Http\Controllers\AlamatSekolahController;
use App\Http\Controllers\AnggotaKelasController;
use App\Http\Controllers\Auth\AuthenticatedSessionController;
use App\Http\Controllers\UserController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::middleware('api')->group(function () {
Route::post('/login', [AuthenticatedSessionController::class, 'store']);
Route::get('/alamat-sekolah', [AlamatSekolahController::class, 'showCurrent']);
Route::post('/alamat-sekolah', [AlamatSekolahController::class, 'store']);
Route::put('/alamat-sekolah/{id}', [AlamatSekolahController::class, 'update']);
Route::delete('/alamat-sekolah/{id}', [AlamatSekolahController::class, 'destroy']);

Route::post('/users', [UserController::class, 'store']);
Route::get('/kelas', [AnggotaKelasController::class, 'index']);
});
