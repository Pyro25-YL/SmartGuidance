<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('absensi_guru', function (Blueprint $table) {
            $table->id();

            // FK ke users (guru)
            $table->unsignedBigInteger('guru_id');
            $table->foreign('guru_id')->references('id')->on('users')->onDelete('cascade');

            // FK ke mapel
            $table->unsignedBigInteger('mapel_id');
            $table->foreign('mapel_id')->references('id')->on('mapel')->onDelete('cascade');

            // File paths
            $table->string('foto')->nullable();         // contoh: storage/foto_absen/xxxx.jpg
            $table->string('file_materi')->nullable();  // contoh: storage/materi/xxxx.pdf

            $table->timestamps();

            $table->index(['guru_id', 'mapel_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('absensi_guru');
    }
};
