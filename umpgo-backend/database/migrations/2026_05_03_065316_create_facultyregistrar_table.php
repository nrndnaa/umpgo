<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('facultyregistrar', function (Blueprint $table) {
            $table->id('registrarID');
            $table->string('name');
            $table->string('email')->unique();
            $table->string('password');
            $table->string('staffID')->unique();
            $table->string('faculty');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('facultyregistrar');
    }
};
