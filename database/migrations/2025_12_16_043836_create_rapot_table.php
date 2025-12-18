<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('rapot', function (Blueprint $table) {
            $table->id();

            // murid (users)
            $table->foreignId('murid_id')
                ->constrained('users')
                ->cascadeOnDelete();

            // kelas (hasil lookup dari anggota_kelas sesuai murid_id)
            $table->foreignId('kelas_id')
                ->constrained('kelas')
                ->cascadeOnDelete();

            // mapel
            $table->foreignId('mapel_id')
                ->constrained('mapel')
                ->cascadeOnDelete();

            // semester (fleksibel: "Ganjil", "Genap", "1", "2", "2025/2026 Ganjil", dll)
            $table->string('semester', 30);

            // nilai rapot
            $table->unsignedInteger('nilai'); // misal 0-100

            $table->timestamps();

            // cegah duplikasi rapot untuk murid + kelas + mapel + semester yang sama
            $table->unique(
                ['murid_id', 'kelas_id', 'mapel_id', 'semester'],
                'rapot_unique'
            );
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('rapot');
    }
};
