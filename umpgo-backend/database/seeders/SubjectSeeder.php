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
            ],
            [
                'subjectCode'  => 'BCS3123',
                'subjectName'  => 'Software Project Management',
                'creditHours'  => 3,
            ],
        ]);
    }
}
