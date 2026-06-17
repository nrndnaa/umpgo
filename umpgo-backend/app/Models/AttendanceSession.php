<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;

class AttendanceSession extends Model {
    protected $table = 'attendancesession';
    protected $primaryKey = 'attSessionID';
    protected $fillable = [
        'lecturerID','adabID','sectionID','moduleID','sessionTitle','code','codeDuration','codeExpiry','createdBy','started_At','ended_At','isActive'
    ];

    public function records()
    {
        return $this->hasMany(AttendanceRecord::class, 'attSessionID','attSessionID');
    }

    public function section()
    {
        return $this->belongsTo(Section::class, 'sectionID','sectionID');
    }
}
