<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            // Ubah kolom jadi wajib (NOT NULL)
            $table->unsignedBigInteger('nisn_nip')->nullable(false)->change();
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            // Kembalikan jadi boleh null
            $table->unsignedBigInteger('nisn_nip')->nullable()->change();
        });
    }
};
