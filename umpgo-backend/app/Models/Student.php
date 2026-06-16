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
        'yearOfStudy',
        'programme',
        'status',
        'outstandingBalance',
    ];

    public function feeRecords()
    {
        return $this->hasMany(FeeRecord::class, 'studentID');
    }
}
