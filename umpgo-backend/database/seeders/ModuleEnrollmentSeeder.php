<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class ModuleEnrollmentSeeder extends Seeder
{
    public function run(): void
    {
        $anis = DB::table('student')->where('matricID', 'CB23083')->first();
        $zhang = DB::table('student')->where('matricID', 'CB23084')->first();

        $modules = DB::table('koqmodule')->limit(4)->get(); 
        // first 4 modules for both students

        foreach ($modules as $module) {

            DB::table('moduleenrollment')->insert([
                [
                    'moduleID'        => $module->moduleID,
                    'studentID'       => $anis->studentID,
                    'attendanceStatus'=> 'PRESENT',
                    'totalMarks'      => '100%',
                    'enrolled_At'     => now(),
                ],
                [
                    'moduleID'        => $module->moduleID,
                    'studentID'       => $zhang->studentID,
                    'attendanceStatus'=> 'PRESENT',
                    'totalMarks'      => '100%',
                    'enrolled_At'     => now(),
                ],
            ]);
        }
    }
}
