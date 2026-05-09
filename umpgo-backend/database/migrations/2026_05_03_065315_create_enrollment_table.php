<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('enrollment', function (Blueprint $table) {
            $table->id('enrollmentID');
            $table->foreignId('studentID')->constrained('student', 'studentID')->cascadeOnDelete();
            $table->foreignId('sectionID')->constrained('section', 'sectionID')->cascadeOnDelete();
            $table->foreignId('sessionID')->constrained('registrationsession', 'sessionID')->cascadeOnDelete();
            $table->string('status')->default('Registered');
            $table->timestamp('registered_At')->useCurrent();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('enrollment');
    }
};
