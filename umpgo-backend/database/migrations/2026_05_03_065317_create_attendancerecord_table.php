<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('attendancerecord', function (Blueprint $table) {
            $table->id('recordID');
            $table->foreignId('attSessionID')->constrained('attendancesession', 'attSessionID')->cascadeOnDelete();
            $table->foreignId('studentID')->constrained('student', 'studentID')->cascadeOnDelete();
            $table->string('status')->default('Absent'); // Present / Absent / Late
            $table->boolean('gpsVerified')->default(false);
            $table->decimal('latitude', 10, 7)->nullable();
            $table->decimal('longitude', 10, 7)->nullable();
            $table->timestamp('checkedIn_At')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('attendancerecord');
    }
};
