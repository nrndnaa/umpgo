<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class RegistrationSession extends Model
{
    protected $table = 'registrationsession';

    protected $fillable = [
        'registrarID',
        'eligableYear',
        'startDate',
        'endDate',
        'startTime',
        'endTime',
    ];

    public function registrar()
    {
        return $this->belongsTo(FacultyRegistrar::class, 'registrarID', 'registrarID');
        //                                                 ↑ FK in this table  ↑ PK in facultyregistrar
    }
}
