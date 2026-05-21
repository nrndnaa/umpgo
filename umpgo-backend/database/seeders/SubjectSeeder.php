<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class SubjectSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('subject')->insert([
            [
                'subjectCode'  => 'BCS2243',
                'subjectName'  => 'Mobile Application Development',
                'creditHours'  => 3,
                'created_at'   => now(),
                'updated_at'   => now(),
            ],
            [
                'subjectCode'  => 'BCS3123',
                'subjectName'  => 'Software Project Management',
                'creditHours'  => 3,
                'created_at'   => now(),
                'updated_at'   => now(),
            ],
            [
                'subjectCode'  => 'BCS1013',
                'subjectName'  => 'Programming Techniques',
                'creditHours'  => 3,
                'created_at'   => now(),
                'updated_at'   => now(),
            ],
            [
                'subjectCode'  => 'BCS2143',
                'subjectName'  => 'Object Oriented Programming',
                'creditHours'  => 3,
                'created_at'   => now(),
                'updated_at'   => now(),
            ],
            [
                'subjectCode'  => 'BCS2043',
                'subjectName'  => 'Operating Systems',
                'creditHours'  => 3,
                'created_at'   => now(),
                'updated_at'   => now(),
            ],
            [
                'subjectCode'  => 'BCS3233',
                'subjectName'  => 'Artificial Intelligence',
                'creditHours'  => 3,
                'created_at'   => now(),
                'updated_at'   => now(),
            ],
            [
                'subjectCode'  => 'BCS2213',
                'subjectName'  => 'Database Systems',
                'creditHours'  => 3,
                'created_at'   => now(),
                'updated_at'   => now(),
            ],
            [
                'subjectCode'  => 'BCS3013',
                'subjectName'  => 'Web Engineering',
                'creditHours'  => 3,
                'created_at'   => now(),
                'updated_at'   => now(),
            ],
            [
                'subjectCode'  => 'BCN2163',
                'subjectName'  => 'Network Management',
                'creditHours'  => 3,
                'created_at'   => now(),
                'updated_at'   => now(),
            ],
            [
                'subjectCode'  => 'BCI4113',
                'subjectName'  => 'Cloud Computing',
                'creditHours'  => 3,
                'created_at'   => now(),
                'updated_at'   => now(),
            ],
        ]);
    }
}
