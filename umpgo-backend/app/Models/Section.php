<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;

class Section extends Model
{
    protected $table = 'section';
    protected $primaryKey = 'sectionID';

    public function subject()
    {
        return $this->belongsTo(Subject::class, 'subjectID', 'subjectID');
    }

    public function enrollments()
    {
        return $this->hasMany(Enrollment::class, 'sectionID', 'sectionID');
    }

    public function lecturer()
    {
        return $this->belongsTo(Lecturer::class, 'lecturerID', 'lecturerID');
    }
}