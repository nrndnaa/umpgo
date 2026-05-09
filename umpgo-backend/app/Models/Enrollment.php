<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Enrollment extends Model
{
    protected $table = 'enrollment';
    protected $primaryKey = 'enrollmentID';

    // Add this block:
    protected $fillable = [
        'studentID',
        'sectionID',
        'sessionID', // This is the one causing the error
        'status',
        'registered_At'
    ];

    public function section()
    {
        return $this->belongsTo(Section::class, 'sectionID', 'sectionID');
    }

    public function student()
    {
        return $this->belongsTo(Student::class, 'studentID', 'studentID');
    }
}
