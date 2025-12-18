<?php

use App\Http\Controllers\AbsensiGuruController;
use App\Http\Controllers\AbsensiMasukSekolahController;
use App\Http\Controllers\AbsensiSiswaController;
use App\Http\Controllers\AlamatSekolahController;
use App\Http\Controllers\AnggotaKelasController;
use App\Http\Controllers\Auth\AuthenticatedSessionController;
use App\Http\Controllers\KelasController;
use App\Http\Controllers\MapelController;
use App\Http\Controllers\MateriController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\NilaiController;
use App\Http\Controllers\NilaiUjianController;
use App\Http\Controllers\RapotController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::middleware('api')->group(function () {
Route::post('/login', [AuthenticatedSessionController::class, 'store']);
Route::get('/alamat-sekolah', [AlamatSekolahController::class, 'showCurrent']);
Route::post('/alamat-sekolah', [AlamatSekolahController::class, 'store']);
Route::put('/alamat-sekolah/{id}', [AlamatSekolahController::class, 'update']);
Route::delete('/alamat-sekolah/{id}', [AlamatSekolahController::class, 'destroy']);

Route::post('/users', [UserController::class, 'store']);
Route::get('/users', [UserController::class, 'index']);
Route::get('/kelas', [KelasController::class, 'index']);
Route::post('/kelas', [KelasController::class, 'apiStore']);
Route::get('/guru', [KelasController::class, 'apiGuruList']);
Route::get('/mapel', [MapelController::class, 'index']);
Route::post('/mapel', [MapelController::class, 'store']);
Route::get('/guru-options', [MapelController::class, 'guruOptions']);
Route::get('/kelas-options', [MapelController::class, 'kelasOptions']);
// === Anggota Kelas API ===
Route::get('/kelas-options', [AnggotaKelasController::class, 'kelasOptions']);
Route::get('/siswa-options', [AnggotaKelasController::class, 'siswaOptions']);
Route::get('/ortu-options',  [AnggotaKelasController::class, 'ortuOptions']);
Route::post('/anggota-kelas', [AnggotaKelasController::class, 'store']);
Route::get('/foto-user/{filename}', function ($filename) {
    $path = public_path('storage/foto/' . $filename);

    if (! file_exists($path)) {
        abort(404);
    }

    $mime = mime_content_type($path) ?: 'image/png';

    return response()->file($path, [
        'Content-Type' => $mime,
    ]);
});
Route::put('/users/{user}', [UserController::class, 'update']);
Route::patch('/users/{user}', [UserController::class, 'update']);
Route::get('/absensi-guru/form-data', [AbsensiGuruController::class, 'formData']);
Route::post('/absensi-guru', [AbsensiGuruController::class, 'storeApi']);


Route::get('/materi/form', [MateriController::class, 'createApi']);
Route::get('/materi/by-mapel', [MateriController::class, 'showForMapelApi']);
Route::post('/materi', [MateriController::class, 'storeApi']);


Route::get('/absensi-siswa/form', [AbsensiSiswaController::class, 'formApi']);
Route::post('/absensi-siswa', [AbsensiSiswaController::class, 'storeApi']);
});


Route::get('/nilai', [NilaiController::class, 'index']);
Route::get('/nilai/form', [NilaiController::class, 'form']);      // ambil dropdown mapel & murid
Route::post('/nilai', [NilaiController::class, 'store']);         // simpan nilai

Route::get('/nilai-ujian', [NilaiUjianController::class, 'index']);
Route::get('/nilai-ujian/form', [NilaiUjianController::class, 'form']);
Route::post('/nilai-ujian', [NilaiUjianController::class, 'store']);

Route::get('/rapot', [RapotController::class, 'index']);
Route::get('/rapot/form', [RapotController::class, 'form']);
Route::post('/rapot', [RapotController::class, 'store']);
Route::get('/rapot/avg', [RapotController::class, 'avg']);   // 👈 baru
Route::middleware(['auth'])->group(function () {
    Route::get('/absensi/masuk', [AbsensiMasukSekolahController::class, 'index']);
    Route::post('/absensi/masuk', [AbsensiMasukSekolahController::class, 'store']);
});
Route::get('/alamat-sekolah', function () {
    return \App\Models\AlamatSekolah::first();
});

