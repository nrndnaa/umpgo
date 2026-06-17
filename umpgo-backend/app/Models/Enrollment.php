<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;

class Enrollment extends Model
{
    protected $table = 'enrollment';
    protected $primaryKey = 'enrollmentID';

    public function section()
    {
        return $this->belongsTo(Section::class, 'sectionID', 'sectionID');
    }

    public function student()
    {
        return $this->belongsTo(Student::class, 'studentID', 'studentID');
    }
}