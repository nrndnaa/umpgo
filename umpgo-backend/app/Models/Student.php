<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;

class Student extends Authenticatable
{
    protected $table = 'student';
    protected $primaryKey = 'studentID';

    protected $fillable = [
        'matricID',
        'name',
        'email',
        'password',
        'programme',
        'faculty',
        'yearOfStudy',
        'status',
    ];

    protected $hidden = [
        'password',
    ];

    public function enrollments()
    {
        return $this->hasMany(Enrollment::class, 'studentID', 'studentID');
    }

    public function creditClaim()
    {
        return $this->hasOne(CreditClaim::class, 'studentID', 'studentID');
    }
}
