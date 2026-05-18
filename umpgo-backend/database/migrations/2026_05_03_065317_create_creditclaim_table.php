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
            $table->unsignedBigInteger('studentID');
            $table->string('semester');
            $table->decimal('totalCats', 5, 2)->default(0);
            $table->string('status')->default('Pending'); // Pending / Approved / Rejected
            $table->timestamp('submitted_at')->useCurrent();
            $table->timestamps();

            $table->foreign('studentID')
                ->references('studentID')
                ->on('student')
                ->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('creditclaim');
    }
};
