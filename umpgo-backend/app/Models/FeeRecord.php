<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FeeRecord extends Model
{
    protected $table = 'feerecord';

    protected $primaryKey = 'feeID';

    protected $fillable = [
    'studentID',
    'treasuryID',
    'semester',
    'totalFee',
    'paidAmount',
    'dueDate',
    'feeStatus',
];

    // ONE fee record has MANY payments
    public function payments()
    {
        return $this->hasMany(Payment::class, 'feeID');
    }

    public function student()
{
    return $this->belongsTo(Student::class, 'studentID');
}
}