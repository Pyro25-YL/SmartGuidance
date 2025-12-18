<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class AbsensiSiswa extends Model
{
    use HasFactory;

    protected $table = 'absensi_siswa';

    protected $fillable = [
        'user_id',
        'latitude',
        'longitude',
        'jam_masuk',
        'status',
        'foto',
    ];

    protected $casts = [
        'jam_masuk' => 'datetime',
        'latitude'  => 'float',
        'longitude' => 'float',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
