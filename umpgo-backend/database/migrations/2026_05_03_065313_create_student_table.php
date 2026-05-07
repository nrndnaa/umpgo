<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('student', function (Blueprint $table) {
            $table->id('studentID');
            $table->string('name');
            $table->string('email')->unique();  // ← add this line
            $table->string('password');
            $table->string('yearOfStudy');
            $table->string('matricID')->unique();
            $table->string('programme');
            $table->string('status')->default('Active');
            $table->decimal('outstandingBalance', 10, 2)->default(0);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('student');
    }
};
