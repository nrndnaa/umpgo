<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class FeeRecordSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('feerecord')->insert([
            [
                'studentID' => 1,
                'treasuryID' => 1,
                'semester' => 'Semester 1 2026/2027',
                'totalFee' => 3500.00,
                'paidAmount' => 1500.00,
                'feeStatus' => 'Restricted',
                'created_at' => now(),
                'updated_at' => now(),
            ],

            [
                'studentID' => 1,
                'treasuryID' => 1,
                'semester' => 'Semester 2 2026/2027',
                'totalFee' => 3500.00,
                'paidAmount' => 3500.00,
                'feeStatus' => 'Granted',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}