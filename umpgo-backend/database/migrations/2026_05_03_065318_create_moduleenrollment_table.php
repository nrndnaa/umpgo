<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('moduleenrollments', function (Blueprint $table) {
        $table->id('modEnrollID');
        $table->unsignedBigInteger('moduleID');
        $table->unsignedBigInteger('studentID');
        $table->string('attendanceStatus')->default('Pending');
        $table->string('totalMarks')->default('0%');
        $table->timestamps();

        $table->foreign('moduleID')->references('moduleID')->on('koqmodules');
        $table->foreign('studentID')->references('studentID')->on('students');
    });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('moduleenrollment');
    }
};
