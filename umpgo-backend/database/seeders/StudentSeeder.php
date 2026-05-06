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
        DB::table('student')->insert([
            [
                'matricID' => 'CB23090',
                'name' => 'Nurin Irdina',
                'email' => 'nurin@student.ump.edu.my',
                'password' => Hash::make('pass123'),
                'yearOfStudy' => 'Year 3',
                'programme' => 'Software Engineering',
                'status' => 'Active',
                'outstandingBalance' => 0,
            ],
        ]);
    }
}
