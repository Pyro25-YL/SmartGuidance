<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class AlamatSekolah extends Model
{
    use HasFactory;

    protected $table = 'alamat_sekolah';

    protected $fillable = [
        'latitude',
        'longitude',
        'radius_jarak_absen',
         'alamat', 
         'singleton',
    ];
}
