<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Lecturer extends Model {
    protected $table = 'lecturer';
    protected $primaryKey = 'lecturerID';
    protected $fillable = ['staffID','name','email','password','faculty'];
}
