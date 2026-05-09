<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;

class FacultyRegistrar extends Authenticatable
{
    protected $table = 'facultyregistrar';
    protected $primaryKey = 'registrarID';

    protected $fillable = [
        'staffID',
        'name',
        'email',
        'password',
        'faculty',
    ];

    protected $hidden = [
        'password',
    ];

    public function registrationSessions()
    {
        return $this->hasMany(RegistrationSession::class, 'registrarID', 'registrarID');
    }
}
