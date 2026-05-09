<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('feerecord', function (Blueprint $table) {
            $table->id('feeID');
            $table->foreignId('studentID')->constrained('student', 'studentID')->cascadeOnDelete();
            $table->foreignId('treasuryID')->constrained('treasury', 'treasuryID')->cascadeOnDelete();
            $table->string('semester');
            $table->decimal('totalFee', 10, 2);
            $table->decimal('paidAmount', 10, 2)->default(0);
            $table->string('feeStatus')->default('Restricted'); // Granted / Restricted
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('feerecord');
    }
};
