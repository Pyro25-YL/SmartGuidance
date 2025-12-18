<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Rapot extends Model
{
    protected $table = 'rapot';

    protected $fillable = [
        'murid_id',
        'kelas_id',
        'mapel_id',
        'semester',
        'nilai',
    ];

    public function murid()
    {
        return $this->belongsTo(User::class, 'murid_id');
    }

    public function kelas()
    {
        return $this->belongsTo(Kelas::class, 'kelas_id');
    }

    public function mapel()
    {
        return $this->belongsTo(Mapel::class, 'mapel_id');
    }
}
