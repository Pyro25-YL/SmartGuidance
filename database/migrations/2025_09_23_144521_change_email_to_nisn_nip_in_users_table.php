<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            // Hapus kolom email dulu
            $table->dropColumn('email');
        });

        Schema::table('users', function (Blueprint $table) {
            // Tambahkan kolom baru integer untuk nisn_nip
            $table->unsignedBigInteger('nisn_nip')->nullable()->after('name');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('nisn_nip');
        });

        Schema::table('users', function (Blueprint $table) {
            $table->string('email')->nullable()->after('name');
        });
    }
};
