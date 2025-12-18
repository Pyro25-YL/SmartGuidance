<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'nisn_nip',
        'password',
        'foto',
        'role',
        'jenis_kelamin',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    protected $appends = ['foto_url'];

    public function getFotoUrlAttribute()
    {
        if (!$this->foto) {
            return null;
        }

        // custom route
        return url('/foto-user/'.$this->foto);
    }

    public function kelasWali()
{
    return $this->hasMany(\App\Models\Kelas::class, 'walikelas_id');
}

public function kelasSebagaiSiswa()
{
    return $this->hasMany(AnggotaKelas::class, 'siswa_id');
}

public function kelasSebagaiOrtu()
{
    return $this->hasMany(AnggotaKelas::class, 'ortu_id');
}


}
