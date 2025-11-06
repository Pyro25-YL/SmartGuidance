<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Mapel extends Model
{
    use HasFactory;

    protected $table = 'mapel';

    protected $fillable = [
        'nama_mapel',
        'kelas_id',
        'jam_mulai',
        'guru_id',
        'jam_akhir',
    ];

    public function kelas()
    {
        return $this->belongsTo(\App\Models\Kelas::class, 'kelas_id');
    }
        public function guru()
    {
        return $this->belongsTo(\App\Models\User::class, 'guru_id');
    }
}
