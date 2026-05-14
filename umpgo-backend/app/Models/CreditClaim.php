<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CreditClaim extends Model
{
    protected $table = 'creditclaim';
    protected $primaryKey = 'claimID';

    protected $fillable = [
        'studentID',
        'semester',
        'totalCats',
        'status',
    ];

    public function student()
    {
        return $this->belongsTo(Student::class, 'studentID');
    }
}