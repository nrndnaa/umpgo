<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\Student;
use App\Models\KoqModule;

class ModuleEnrollment extends Model
{
    protected $table = 'moduleenrollment'; 
    protected $primaryKey = 'modEnrollID';

    protected $fillable = [
        'moduleID',
        'studentID',
        'attendanceStatus',
        'totalMarks',
        'enrolled_At',
    ];

    public function module()
    {
        return $this->belongsTo(KoqModule::class, 'moduleID', 'moduleID');
    }

    public function student()
{
    return $this->belongsTo(\App\Models\Student::class, 'studentID', 'studentID');
}
}