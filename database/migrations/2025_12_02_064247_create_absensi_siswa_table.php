<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('absensi_siswa', function (Blueprint $table) {
            $table->id();

            // siswa yang absen (relasi ke tabel users)
            $table->foreignId('user_id')
                  ->constrained('users')
                  ->onDelete('cascade');

            // lokasi
            $table->decimal('latitude', 10, 7)->nullable();
            $table->decimal('longitude', 10, 7)->nullable();

            // jam masuk (pakai timestamp biar ada tanggal + jam)
            $table->timestamp('jam_masuk')->nullable();

            // status kehadiran: hadir / terlambat / izin / sakit / alpha
            $table->string('status', 20)->default('hadir');

            // nama file / path foto bukti
            $table->string('foto')->nullable();

            $table->timestamps();

            // index tambahan jika perlu
            $table->index(['user_id', 'jam_masuk']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('absensi_siswa');
    }
};
