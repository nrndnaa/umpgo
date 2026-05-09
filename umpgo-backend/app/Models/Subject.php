<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Subject extends Model
{
    protected $table = 'subject';        // ← add this
    protected $primaryKey = 'subjectID'; // ← add this

    public function sections()
    {
        return $this->hasMany(Section::class, 'subjectID', 'subjectID');
    }
}
