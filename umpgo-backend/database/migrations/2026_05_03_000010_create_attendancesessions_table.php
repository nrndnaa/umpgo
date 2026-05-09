<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('attendancesession', function (Blueprint $table) {
            $table->id('attSessionID');

            $table->unsignedBigInteger('lecturerID');
            $table->unsignedBigInteger('adabID');
            $table->unsignedBigInteger('sectionID')->nullable();
            $table->unsignedBigInteger('moduleID')->nullable();

            $table->string('sessionTitle');
            $table->string('code')->nullable();
            $table->integer('codeDuration')->nullable();
            $table->timestamp('codeExpiry')->nullable();
            $table->string('createdBy');
            $table->timestamp('started_At')->nullable();
            $table->timestamp('ended_At')->nullable();
            $table->boolean('isActive')->default(false);
            $table->timestamps();

            // Define foreign keys manually
            $table->foreign('lecturerID')->references('lecturerID')->on('lecturer')->cascadeOnDelete();
            $table->foreign('adabID')->references('adabID')->on('pusatadab')->cascadeOnDelete();
            $table->foreign('sectionID')->references('sectionID')->on('section')->nullOnDelete();
            $table->foreign('moduleID')->references('moduleID')->on('koqmodule')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('attendancesession');
    }
};
