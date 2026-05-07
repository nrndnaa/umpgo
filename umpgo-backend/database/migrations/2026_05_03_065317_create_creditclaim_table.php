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
        Schema::create('creditclaims', function (Blueprint $table) {
        $table->id('claimID');
        $table->unsignedBigInteger('studentID');
        $table->string('semester');
        $table->integer('totalCats')->default(0);
        $table->string('status')->default('Not Complete');
        $table->timestamps();

        $table->foreign('studentID')->references('studentID')->on('students');
    });
    }

        public function down(): void
    {
        Schema::dropIfExists('creditclaim');
    }
};
