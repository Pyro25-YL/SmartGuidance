<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('mapel', function (Blueprint $table) {
            $table->id();
            $table->string('nama_mapel');
            $table->unsignedBigInteger('kelas_id');
            $table->time('jam_mulai'); // format H:i:s
            $table->time('jam_akhir'); // format H:i:s
            $table->timestamps();

            $table->foreign('kelas_id')
                  ->references('id')->on('kelas')
                  ->onDelete('cascade');

            $table->index(['kelas_id', 'jam_mulai']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('mapel');
    }
};
