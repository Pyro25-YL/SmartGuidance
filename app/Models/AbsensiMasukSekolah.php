<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AbsensiMasukSekolah extends Model
{
    protected $table = 'absensi_masuk_sekolah';

    protected $fillable = [
        'user_id',
        'latitude',
        'longitude',
        'jam_masuk',
        'status',
        'foto',
        'tanggal',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
