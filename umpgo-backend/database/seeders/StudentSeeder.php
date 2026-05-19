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
                'outstandingBalance' => 0.00,
            ],
            [
                'matricID'           => 'CB23083',
                'name'               => 'Anis Najla',
                'email'              => 'cb23083@student.ump.edu.my',
                'password'           => bcrypt('pass123'),
                'yearOfStudy'        => '3',
                'programme'          => 'Cybersecurity',
                'status'             => 'Active',
                'outstandingBalance' => 0.00,
            ],
            [
                'matricID'           => 'CB23084',
                'name'               => 'Zhang Linghe',
                'email'              => 'cb23084@student.ump.edu.my',
                'password'           => bcrypt('pass123'),
                'yearOfStudy'        => '2',
                'programme'          => 'Multimedia and Graphic',
                'status'             => 'Active',
                'outstandingBalance' => 0.00,
            ],
            [
                'matricID'           => 'CB23085',
                'name'               => 'Tian Xi Wei',
                'email'              => 'cb23085@student.ump.edu.my',
                'password'           => bcrypt('pass123'),
                'yearOfStudy'        => '1',
                'programme'          => 'Network',
                'status'             => 'Active',
                'outstandingBalance' => 0.00,
            ],
            [
                'matricID'           => 'CB23086',
                'name'               => 'Ainul Mardhiah',
                'email'              => 'cb23086@student.ump.edu.my',
                'password'           => bcrypt('pass123'),
                'yearOfStudy'        => '2',
                'programme'          => 'Cybersecurity',
                'status'             => 'Active',
                'outstandingBalance' => 0.00,
            ],
            [
                'matricID'           => 'CB23087',
                'name'               => 'Sharmila',
                'email'              => 'cb23087@student.ump.edu.my',
                'password'           => bcrypt('pass123'),
                'yearOfStudy'        => '1',
                'programme'          => 'Multimedia and Graphic',
                'status'             => 'Active',
                'outstandingBalance' => 0.00,
            ],
        ]);
    }
}
