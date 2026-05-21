<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('section', function (Blueprint $table) {
            $table->id('sectionID');

            // Link to the parent (Subject)
            $table->foreignId('subjectID')->constrained('subject', 'subjectID')->cascadeOnDelete();

            // Link to the parent (Lecturer)
            $table->foreignId('lecturerID')->constrained('lecturer', 'lecturerID')->cascadeOnDelete();

            $table->string('sectionNo');
            $table->integer('capacity');
            $table->string('day');
            $table->time('startTime');
            $table->time('endTime');
            $table->string('venue');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('section');
    }
};
