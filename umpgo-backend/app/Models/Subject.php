<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;

class Subject extends Model
{
    protected $table = 'subject';
    protected $primaryKey = 'subjectID';

    public function sections()
    {
        return $this->hasMany(Section::class, 'subjectID', 'subjectID');
    }
}