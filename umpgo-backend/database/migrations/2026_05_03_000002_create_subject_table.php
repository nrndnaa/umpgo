<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('subject', function (Blueprint $table) {
            $table->id('subjectID'); // Parent ID
            $table->string('subjectName');
            $table->string('subjectCode')->unique();
            $table->integer('creditHours');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('subject');
    }
};
