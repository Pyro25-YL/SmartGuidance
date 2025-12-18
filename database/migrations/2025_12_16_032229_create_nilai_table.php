<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('nilai', function (Blueprint $table) {
            $table->id();

            // Relasi ke tabel mapel
            $table->foreignId('mapel_id')
                  ->constrained('mapel')
                  ->cascadeOnDelete();

            // Relasi ke users (murid)
            $table->foreignId('murid_id')
                  ->constrained('users')
                  ->cascadeOnDelete();

            // Relasi ke users (guru)
            $table->foreignId('guru_id')
                  ->constrained('users')
                  ->cascadeOnDelete();

            // Nilai
            $table->unsignedInteger('nilai');

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('nilai');
    }
};
