<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('koqmodule', function (Blueprint $table) {
            $table->id('moduleID');
            $table->foreignId('adabID')->constrained('pusatadab', 'adabID')->cascadeOnDelete(); // ← adabID not staffID
            $table->string('code')->unique();
            $table->string('name');
            $table->string('campus');
            $table->integer('catsPoint')->default(2);
            $table->integer('maxSlots');
            $table->integer('filledSlots')->default(0);
            $table->date('startDate');
            $table->date('endDate');
            $table->string('startTime');
            $table->string('endTime');
            $table->string('venue');
            $table->string('groupLink')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('koqmodule');
    }
};
