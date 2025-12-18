<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('nilai_ujian', function (Blueprint $table) {
            $table->id();

            // murid (users)
            $table->foreignId('murid_id')
                ->constrained('users')
                ->cascadeOnDelete();

            // mapel
            $table->foreignId('mapel_id')
                ->constrained('mapel')
                ->cascadeOnDelete();

            // jenis ujian: PTS / PAS
            $table->enum('jenis_ujian', ['PTS', 'PAS']);

            // nilai
            $table->unsignedInteger('nilai'); // biasanya 0-100

            $table->timestamps();

            // (opsional) cegah dobel input untuk murid-mapel-jenis ujian yang sama
            $table->unique(['murid_id', 'mapel_id', 'jenis_ujian'], 'nilai_ujian_unique');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('nilai_ujian');
    }
};
