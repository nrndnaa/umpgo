<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class LecturerSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('lecturer')->insert([
            [
                'staffID'  => 'LEC001',
                'name'     => 'Dr. Aris',
                'email'    => 'aris@ump.edu.my',
                'password' => Hash::make('lecturer123'),
                'faculty'  => 'FK',
            ],
            [
                'staffID'  => 'LEC002',
                'name'     => 'Dr. Nurul Salwani',
                'email'    => 'nurulsalwani@ump.edu.my',
                'password' => Hash::make('pass123123'),
                'faculty'  => 'FK',
            ],
            [
                'staffID'  => 'LEC003',
                'name'     => 'Dr. Abdullah',
                'email'    => 'abdullah@ump.edu.my',
                'password' => Hash::make('lecturer123'),
                'faculty'  => 'FK',
            ],
            [
                'staffID'  => 'LEC004',
                'name'     => 'Dr. Maizatul',
                'email'    => 'maizatul@ump.edu.my',
                'password' => Hash::make('lecturer123'),
                'faculty'  => 'FK',
            ],
        ]);
    }
}
