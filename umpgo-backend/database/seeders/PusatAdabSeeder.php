<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class PusatAdabSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('pusatadab')->insert([
            [
                // ← remove adabID, let it auto-increment
                'staffID'  => 'ADAB001',
                'name'     => 'Ustaz Ahmad Fauzi',
                'email'    => 'fauzi@ump.edu.my',
                'password' => Hash::make('pass123'),
            ],
            [
                'staffID'  => 'ADAB002',
                'name'     => 'Siti Aminah',
                'email'    => 'aminah@ump.edu.my',
                'password' => Hash::make('pass123'),
            ],
        ]);
    }
}
