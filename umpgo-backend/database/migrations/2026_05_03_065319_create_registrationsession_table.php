<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::table('registrationsession', function (Blueprint $table) {
            $table->string('registrarID');
            $table->string('eligableYear');
            $table->date('startDate');
            $table->date('endDate');
            $table->time('startTime');
            $table->time('endTime');
        });
    }

    public function down()
    {
        Schema::table('registrationsession', function (Blueprint $table) {
            $table->dropColumn(['registrarID', 'eligableYear', 'startDate', 'endDate', 'startTime', 'endTime']);
        });
    }
};
