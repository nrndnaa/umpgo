<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('registrationsession', function (Blueprint $table) {
            $table->id('sessionID');
            $table->unsignedBigInteger('registrarID');
            $table->foreign('registrarID')
                ->references('registrarID')  // ← match exact PK name in facultyregistrar table
                ->on('facultyregistrar')
                ->onDelete('cascade');
            $table->string('eligableYear');
            $table->date('startDate');
            $table->date('endDate');
            $table->time('startTime');
            $table->time('endTime');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('registrationsession');
    }
};
