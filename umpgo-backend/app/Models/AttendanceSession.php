<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AttendanceSession extends Model {
    protected $table = 'attendance_session';
    protected $primaryKey = 'attSessionID';
    protected $fillable = ['lecturerID','adabID','sessionTitle','code','codeDuration','codeExpiry','startedAt','isActive'];
}
