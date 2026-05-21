<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('moduleenrollment', function (Blueprint $table) {

            $table->id('modEnrollID');
            $table->foreignId('moduleID')->constrained('koqmodule', 'moduleID')->cascadeOnDelete();
            $table->foreignId('studentID')->constrained('student', 'studentID')->cascadeOnDelete();
            $table->string('attendanceStatus')->default('Pending');
            $table->decimal('totalMarks', 5, 2)->default(0);
            $table->timestamp('enrolled_At')->useCurrent();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('moduleenrollment');
    }
};
