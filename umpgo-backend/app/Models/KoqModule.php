<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class KoqModule extends Model
{
protected $table = 'koqmodule';
protected $primaryKey = 'moduleID';
public $incrementing = true;
protected $keyType = 'int';
    protected $fillable = [
        'adabID',
        'code',
        'name',
        'catsPoint',
        'maxSlots',
        'filledSlots',
        'startDate',
        'endDate',
        'startTime',
        'endTime',
        'campus',
        'venue',
        'groupLink',
    ];

    public function enrollments()
    {
        return $this->hasMany(ModuleEnrollment::class, 'moduleID');
    }
}