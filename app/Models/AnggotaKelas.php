<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class AnggotaKelas extends Model
{
    use HasFactory;

    protected $table = 'anggota_kelas';

    protected $fillable = [
        'kelas_id',
        'siswa_id',
        'ortu_id',
    ];

    // Relasi ke kelas
    public function kelas()
    {
        return $this->belongsTo(Kelas::class, 'kelas_id');
    }

    // Relasi ke user sebagai siswa
    public function siswa()
    {
        return $this->belongsTo(User::class, 'siswa_id');
    }

    // Relasi ke user sebagai orang tua
    public function ortu()
    {
        return $this->belongsTo(User::class, 'ortu_id');
    }
}
