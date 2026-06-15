<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PusatAdab extends Model
{
    protected $table = 'pusatadab';
    protected $primaryKey = 'adabID';

    protected $fillable = [
        'name',
        'email',
        'password',
        'staffID',
    ];

    protected $hidden = ['password'];

    public function modules()
    {
        return $this->hasMany(KoqModule::class, 'staffID', 'staffID');
    }
}
