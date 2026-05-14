<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('creditclaim', function (Blueprint $table) {

            $table->id('claimID');
            $table->foreignId('studentID')->constrained('student', 'studentID')->cascadeOnDelete();
            $table->string('semester');
            $table->decimal('totalCats', 5, 2)->default(0);
            $table->string('status')->default('Pending'); // Pending / Approved / Rejected
            $table->timestamp('submitted_At')->useCurrent();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        $table->id('claimID');
        $table->unsignedBigInteger('studentID');
        $table->string('semester');
        $table->integer('totalCats')->default(0);
        $table->string('status')->default('Not Complete');
        $table->timestamps();

        $table->foreign('studentID')->references('studentID')->on('student');
    }
}
