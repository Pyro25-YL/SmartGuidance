<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
public function up(): void
{
    Schema::table('alamat_sekolah', function (Blueprint $table) {
        $table->tinyInteger('singleton')->default(1)->unique()->after('radius_jarak_absen');
    });
}

// rollback
public function down(): void
{
    Schema::table('alamat_sekolah', function (Blueprint $table) {
        $table->dropUnique(['singleton']);
        $table->dropColumn('singleton');
    });
}

};
