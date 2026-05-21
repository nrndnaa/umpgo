<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;   // <--- Add this line
use Illuminate\Support\Facades\Hash;

class FacultyRegistrarSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    // database/seeders/FacultyRegistrarSeeder.php
    public function run(): void
    {
        DB::table('facultyregistrar')->insert([
            [
                'staffID' => 'REG001',
                'name' => 'En. Zulkifli',
                'email' => 'zul@ump.edu.my',
                'password' => Hash::make('registrar123'),
                'faculty' => 'FK',
            ],
            [
                'staffID' => 'REG002',
                'name' => 'Pn. Sarah Adlyn',
                'email' => 'sarahadlyn@ump.edu.my',
                'password' => Hash::make('pass123'),
                'faculty' => 'FK',
            ],

        ]);
    }
}
