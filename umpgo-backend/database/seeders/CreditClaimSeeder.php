<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class CreditClaimSeeder extends Seeder
{
    public function run(): void
    {
        $anis = DB::table('student')->where('matricID', 'CB23083')->first();

        DB::table('creditclaim')->insert([
            [
                'studentID' => $anis->studentID,
                'semester'  => 'SEMESTER II ACADEMIC SESSION 2025/2026',
                'totalCats' => 8,
                'status'    => 'Completed',
            ],
        ]);
    }
}