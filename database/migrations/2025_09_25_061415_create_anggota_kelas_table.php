<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('anggota_kelas', function (Blueprint $table) {
            $table->id();

            // Relasi ke tabel kelas
            $table->unsignedBigInteger('kelas_id');
            $table->foreign('kelas_id')->references('id')->on('kelas')->onDelete('cascade');

            // Relasi ke users sebagai siswa
            $table->unsignedBigInteger('siswa_id');
            $table->foreign('siswa_id')->references('id')->on('users')->onDelete('cascade');

            // Relasi ke users sebagai wali murid
            $table->unsignedBigInteger('ortu_id')->nullable();
            $table->foreign('ortu_id')->references('id')->on('users')->onDelete('cascade');

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('anggota_kelas');
    }
};
