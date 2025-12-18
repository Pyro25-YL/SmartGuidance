<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class NilaiUjian extends Model
{
    protected $table = 'nilai_ujian';

    protected $fillable = [
        'murid_id',
        'mapel_id',
        'jenis_ujian',
        'nilai',
    ];

    public function murid()
    {
        return $this->belongsTo(User::class, 'murid_id');
    }

    public function mapel()
    {
        return $this->belongsTo(Mapel::class, 'mapel_id');
    }
}
