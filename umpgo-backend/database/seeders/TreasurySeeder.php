<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;   // <--- Add this line
use Illuminate\Support\Facades\Hash;

class TreasurySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('treasury')->insert([
            [
                'staffID' => 'TRE001',
                'name' => 'Pn. Salma',
                'email' => 'salma@ump.edu.my',
                'password' => Hash::make('treasury123'),
            ],
        ]);
    }
}