<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Student extends Model
{
    protected $table = 'student';
    protected $primaryKey = 'studentID';
    
    protected $fillable = [
        'name',
        'email',
        'password',
        'matricID',
        'programme',
        'yearOfStudy',
        'status',
    ];

    protected $hidden = ['password'];

    public function enrollments()
    {
        return $this->hasMany(ModuleEnrollment::class, 'studentID', 'studentID');
    }

    public function creditClaim()
    {
        return $this->hasOne(CreditClaim::class, 'studentID', 'studentID');
    }
}