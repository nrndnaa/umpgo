<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class StudentSeeder extends Seeder
{
    public function run(): void
    {

        $students = [
            ['matricID' => 'CB23001', 'name' => 'Ahmad Faris',        'email' => 'faris@student.ump.edu.my',      'yearOfStudy' => 'Year 1', 'programme' => 'Software Engineering'],
            ['matricID' => 'CB23002', 'name' => 'Nurin Irdina',       'email' => 'nurin@student.ump.edu.my',      'yearOfStudy' => 'Year 3', 'programme' => 'Software Engineering'],
            ['matricID' => 'CB23003', 'name' => 'Muhammad Haziq',     'email' => 'haziq@student.ump.edu.my',      'yearOfStudy' => 'Year 2', 'programme' => 'Computer System & Networking'],
            ['matricID' => 'CB23004', 'name' => 'Siti Aisyah',        'email' => 'aisyah@student.ump.edu.my',     'yearOfStudy' => 'Year 1', 'programme' => 'Cyber Security'],
            ['matricID' => 'CB23005', 'name' => 'Amirul Hakim',       'email' => 'hakim@student.ump.edu.my',      'yearOfStudy' => 'Year 3', 'programme' => 'Computer System & Networking'],
            ['matricID' => 'CB23006', 'name' => 'Nur Fatin',          'email' => 'fatin@student.ump.edu.my',      'yearOfStudy' => 'Year 2', 'programme' => 'Software Engineering'],
            ['matricID' => 'CB23007', 'name' => 'Danial Irfan',       'email' => 'danial@student.ump.edu.my',     'yearOfStudy' => 'Year 1', 'programme' => 'Multimedia Software'],
            ['matricID' => 'CB23008', 'name' => 'Liyana Husna',       'email' => 'liyana@student.ump.edu.my',     'yearOfStudy' => 'Year 3', 'programme' => 'Software Engineering'],
            ['matricID' => 'CB23009', 'name' => 'Zulaikha Nadia',     'email' => 'zulaikha@student.ump.edu.my',   'yearOfStudy' => 'Year 2', 'programme' => 'Cyber Security'],
            ['matricID' => 'CB23010', 'name' => 'Hafizuddin',         'email' => 'hafiz@student.ump.edu.my',      'yearOfStudy' => 'Year 1', 'programme' => 'Computer System & Networking'],
            ['matricID' => 'CB23011', 'name' => 'Aina Syuhada',       'email' => 'aina@student.ump.edu.my',       'yearOfStudy' => 'Year 3', 'programme' => 'Software Engineering'],
            ['matricID' => 'CB23012', 'name' => 'Rizwan Ariff',       'email' => 'rizwan@student.ump.edu.my',     'yearOfStudy' => 'Year 2', 'programme' => 'Computer System & Networking'],
            ['matricID' => 'CB23013', 'name' => 'Hana Maisarah',      'email' => 'hana@student.ump.edu.my',       'yearOfStudy' => 'Year 1', 'programme' => 'Network Engineering'],
            ['matricID' => 'CB23014', 'name' => 'Syafiq Azlan',       'email' => 'syafiq@student.ump.edu.my',     'yearOfStudy' => 'Year 3', 'programme' => 'Software Engineering'],
            ['matricID' => 'CB23015', 'name' => 'Nabilah Izzati',     'email' => 'nabilah@student.ump.edu.my',    'yearOfStudy' => 'Year 2', 'programme' => 'Multimedia Software'],
            ['matricID' => 'CB23016', 'name' => 'Farhan Nizam',       'email' => 'farhan@student.ump.edu.my',     'yearOfStudy' => 'Year 1', 'programme' => 'Software Engineering'],
            ['matricID' => 'CB23017', 'name' => 'Insyirah Zahra',     'email' => 'insyirah@student.ump.edu.my',   'yearOfStudy' => 'Year 3', 'programme' => 'Computer System & Networking'],
            ['matricID' => 'CB23018', 'name' => 'Izzatul Husna',      'email' => 'izzatul@student.ump.edu.my',    'yearOfStudy' => 'Year 2', 'programme' => 'Multimedia Software'],
            ['matricID' => 'CB23019', 'name' => 'Adam Luqman',        'email' => 'adam@student.ump.edu.my',       'yearOfStudy' => 'Year 1', 'programme' => 'Software Engineering'],
            ['matricID' => 'CB23020', 'name' => 'Sofea Najwa',        'email' => 'sofea@student.ump.edu.my',      'yearOfStudy' => 'Year 3', 'programme' => 'Cyber Security'],
            ['matricID' => 'CB23021', 'name' => 'Harith Aiman',       'email' => 'harith@student.ump.edu.my',     'yearOfStudy' => 'Year 2', 'programme' => 'Network Engineering'],
            ['matricID' => 'CB23022', 'name' => 'Qistina Balqis',     'email' => 'qistina@student.ump.edu.my',    'yearOfStudy' => 'Year 1', 'programme' => 'Software Engineering'],
            ['matricID' => 'CB23023', 'name' => 'Suffian Hakimi',     'email' => 'suffian@student.ump.edu.my',    'yearOfStudy' => 'Year 3', 'programme' => 'Cyber Security'],
            ['matricID' => 'CB23024', 'name' => 'Maisarah Ilyana',    'email' => 'maisarah@student.ump.edu.my',   'yearOfStudy' => 'Year 2', 'programme' => 'Software Engineering'],
            ['matricID' => 'CB23025', 'name' => 'Aqil Danish',        'email' => 'aqil@student.ump.edu.my',       'yearOfStudy' => 'Year 1', 'programme' => 'Computer System & Networking'],
            ['matricID' => 'CB23026', 'name' => 'Darwisyah Amira',    'email' => 'darwisyah@student.ump.edu.my',  'yearOfStudy' => 'Year 3', 'programme' => 'Multimedia Software'],
            ['matricID' => 'CB23027', 'name' => 'Fitri Hakimuddin',   'email' => 'fitri@student.ump.edu.my',      'yearOfStudy' => 'Year 2', 'programme' => 'Multimedia Software'],
            ['matricID' => 'CB23028', 'name' => 'Nurul Syazwani',     'email' => 'syazwani@student.ump.edu.my',   'yearOfStudy' => 'Year 1', 'programme' => 'Multimedia Software'],
            ['matricID' => 'CB23029', 'name' => 'Irfan Zikri',        'email' => 'irfan@student.ump.edu.my',      'yearOfStudy' => 'Year 3', 'programme' => 'Computer System & Networking'],
            ['matricID' => 'CB23030', 'name' => 'Ameera Husna',       'email' => 'ameera@student.ump.edu.my',     'yearOfStudy' => 'Year 2', 'programme' => 'Software Engineering'],
        ];

        foreach ($students as $student) {
            DB::table('student')->insert([
                'matricID'           => $student['matricID'],
                'name'               => $student['name'],
                'email'              => $student['email'],
                'password'           => Hash::make('pass123'),
                'yearOfStudy'        => $student['yearOfStudy'],
                'programme'          => $student['programme'],
                'status'             => 'Active',
                'outstandingBalance' => 0,
            ]);
        }

        DB::table('student')->insert([
           
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
