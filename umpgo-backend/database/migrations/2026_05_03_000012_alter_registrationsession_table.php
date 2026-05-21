<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (!Schema::hasTable('registrationsession')) {
            Schema::create('registrationsession', function (Blueprint $table) {
                $table->id('sessionID');
                $table->string('registrarID');
                $table->string('eligableYear');
                $table->date('startDate');
                $table->date('endDate');
                $table->time('startTime');
                $table->time('endTime');
                $table->timestamps();

                $table->foreign('registrarID')
                    ->references('registrarID')
                    ->on('facultyregistrar')
                    ->onDelete('cascade');
            });
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('registrationsession');
    }
};
