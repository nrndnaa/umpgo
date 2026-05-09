<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('payment', function (Blueprint $table) {
            $table->id('paymentID');
            $table->foreignId('feeID')->constrained('feerecord', 'feeID')->cascadeOnDelete();
            $table->decimal('amount', 10, 2);
            $table->string('paymentMethod'); // e.g. Online / Counter / Bank Transfer
            $table->string('paymentStatus')->default('Pending'); // Success / Failed / Pending
            $table->timestamp('paid_at')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('payment');
    }
};
