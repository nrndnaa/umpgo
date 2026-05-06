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
                'faculty'  => 'FKAM',
            ],
        ]);
    }
}
