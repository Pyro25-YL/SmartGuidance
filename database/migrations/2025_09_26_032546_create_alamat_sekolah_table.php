<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('alamat_sekolah', function (Blueprint $table) {
            $table->id();

            // Koordinat GPS
            $table->decimal('latitude', 10, 7);   // -90 s.d. 90
            $table->decimal('longitude', 10, 7);  // -180 s.d. 180

            // Radius absensi dalam meter
            $table->unsignedInteger('radius_jarak_absen'); // contoh: 150 (meter)

            $table->timestamps();

            // Index untuk pencarian lokasi lebih cepat (opsional)
            $table->index(['latitude', 'longitude']);
        });

        // (Opsional) CHECK constraint untuk validasi rentang koordinat (MySQL 8+)
        DB::statement('ALTER TABLE alamat_sekolah 
            ADD CONSTRAINT chk_latitude CHECK (latitude BETWEEN -90 AND 90),
            ADD CONSTRAINT chk_longitude CHECK (longitude BETWEEN -180 AND 180),
            ADD CONSTRAINT chk_radius CHECK (radius_jarak_absen > 0)');
    }

    public function down(): void
    {
        // Hapus constraint (abaikan error jika DB tidak mendukung)
        try {
            DB::statement('ALTER TABLE alamat_sekolah 
                DROP CONSTRAINT chk_latitude,
                DROP CONSTRAINT chk_longitude,
                DROP CONSTRAINT chk_radius');
        } catch (\Throwable $e) {}

        Schema::dropIfExists('alamat_sekolah');
    }
};
