<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;   // <--- Add this line
use Illuminate\Support\Facades\Hash;

class StudentSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
{
    $studentID = DB::table('student')->insertGetId([
        'matricID' => 'CB23106',
        'name' => 'umi',
        'email' => 'umi@student.ump.edu.my',
        'password' => Hash::make('pass123'),
        'yearOfStudy' => 'Year 1',
        'programme' => 'Software Engineering',
        'status' => 'Active',
        'outstandingBalance' => 1500.00,
    ]);

    DB::table('feerecord')->insert([
        'studentID' => $studentID,
        'treasuryID' => 1,
        'semester' => 'Semester 2 (2025/2026)',
        'totalFee' => 1500.00,
        'paidAmount' => 0.00,
        
        'feeStatus' => 'Active',
    ]);
}
}
