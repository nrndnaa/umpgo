<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Student extends Model {
    protected $table = 'student';
    protected $primaryKey = 'studentID';
    protected $fillable = ['name','email','password','yearOfStudy','matricID','programme','status','outstandingBalance'];
}
