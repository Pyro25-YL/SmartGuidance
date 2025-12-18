<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Nilai extends Model
{
    protected $table = 'nilai';

    protected $fillable = [
        'mapel_id','murid_id','guru_id','nilai'
    ];

    public function mapel()
    {
        return $this->belongsTo(Mapel::class);
    }

    public function murid()
    {
        return $this->belongsTo(User::class, 'murid_id');
    }

    public function guru()
    {
        return $this->belongsTo(User::class, 'guru_id');
    }
}
