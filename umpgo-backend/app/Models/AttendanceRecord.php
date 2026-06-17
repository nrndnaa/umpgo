<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;

class AttendanceRecord extends Model {
    protected $table = 'attendancerecord';
    protected $primaryKey = 'recordID';
    protected $fillable = [
        'attSessionID','studentID','status','gpsVerified','latitude','longitude','checkedIn_At'
    ];

    public function student()
    {
        return $this->belongsTo(Student::class, 'studentID','studentID');
    }

    public function session()
    {
        return $this->belongsTo(AttendanceSession::class, 'attSessionID','attSessionID');
    }
}
