<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
    protected $table = 'payment';

    protected $primaryKey = 'paymentID';

    protected $fillable = [
        'feeID',
        'amount',
        'paymentMethod',
        'paymentStatus',
        'paid_at',
    ];

    public function feeRecord()
    {
        return $this->belongsTo(FeeRecord::class, 'feeID');
    }
}