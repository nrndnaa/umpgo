<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DueDateSetting extends Model
{
    protected $table = 'due_date_settings';

    protected $primaryKey = 'dueDateID';

    public $timestamps = false;

    protected $fillable = [
        'semester',
        'dueDate',
        'blockType',
        'created_by',
    ];
}