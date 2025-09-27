<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Kelas extends Model
{
    use HasFactory;

    protected $fillable = [
        'nama_kelas',
        'jumlah_siswa',
        'walikelas_id',
    ];
    
    // Relasi: satu kelas punya satu wali kelas (user dengan role guru)
    public function waliKelas()
    {
        return $this->belongsTo(User::class, 'walikelas_id');
    }
    public function anggota()
{
    return $this->hasMany(AnggotaKelas::class, 'kelas_id');
}

}
