<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class AbsensiGuru extends Model
{
    use HasFactory;

    protected $table = 'absensi_guru';

    protected $fillable = [
        'guru_id',
        'mapel_id',
        'foto',
        'file_materi',
    ];

    public function guru()
    {
        return $this->belongsTo(\App\Models\User::class, 'guru_id');
    }

    public function mapel()
    {
        return $this->belongsTo(\App\Models\Mapel::class, 'mapel_id');
    }
}
