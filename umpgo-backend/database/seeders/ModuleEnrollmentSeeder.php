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
                    'attendanceStatus' => 'PRESENT',
                    'totalMarks'      => '100%',
                    'enrolled_At'     => now(),
                ],
                [
                    'moduleID'        => $module->moduleID,
                    'studentID'       => $zhang->studentID,
                    'attendanceStatus' => 'PRESENT',
                    'totalMarks'      => '100%',
                    'enrolled_At'     => now(),
                ],
            ]);
        }
        $tian = DB::table('student')->where('matricID', 'CB23085')->first();
        $ainul = DB::table('student')->where('matricID', 'CB23086')->first();

        $modules = DB::table('koqmodule')->whereIn('code', ['UQU8081', 'UQU8084'])
            ->get();

        foreach ($modules as $module) {
            DB::table('moduleenrollment')->insert([
                [
                    'moduleID'         => $module->moduleID,
                    'studentID'        => $tian->studentID,
                    'attendanceStatus' => 'PRESENT',
                    'totalMarks'       => '85%',
                    'enrolled_At'      => '2025-09-01 08:00:00',
                ],
                [
                    'moduleID'         => $module->moduleID,
                    'studentID'        => $ainul->studentID,
                    'attendanceStatus' => 'PRESENT',
                    'totalMarks'       => '85%',
                    'enrolled_At'      => '2025-09-01 08:00:00',
                ],
            ]);
        }
    }
}
