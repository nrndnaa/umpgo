<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Student extends Model
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