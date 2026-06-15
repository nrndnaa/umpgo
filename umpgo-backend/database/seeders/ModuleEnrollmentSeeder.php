<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class ModuleEnrollmentSeeder extends Seeder
{
    public function run(): void
    {
        $anis  = DB::table('student')->where('matricID', 'CB23083')->first();
        $zhang = DB::table('student')->where('matricID', 'CB23084')->first();
        $tian  = DB::table('student')->where('matricID', 'CB23085')->first();
        $ainul = DB::table('student')->where('matricID', 'CB23086')->first();

        // ── CB23084 & CB23085: UQU8082 Fotografi Asas — ABSENT ──
        $fotografiModule = DB::table('koqmodule')
            ->where('code', 'UQU8082')
            ->first();

        DB::table('moduleenrollment')->insert([
            [
                'moduleID'         => $fotografiModule->moduleID,
                'studentID'        => $zhang->studentID,
                'attendanceStatus' => 'ABSENT',
                'totalMarks'       => 0,
                'enrolled_At'      => '2025-10-10 08:00:00',
            ],
            [
                'moduleID'         => $fotografiModule->moduleID,
                'studentID'        => $tian->studentID,
                'attendanceStatus' => 'ABSENT',
                'totalMarks'       => 0,
                'enrolled_At'      => '2025-10-10 08:00:00',
            ],
        ]);

        // ── CB23083, CB23084, CB23085, CB23086: 2 past semester modules ──
        $pastModules = DB::table('koqmodule')
            ->whereIn('code', ['UQU4044', 'UQU8081'])
            ->get();

        foreach ($pastModules as $module) {
            DB::table('moduleenrollment')->insert([
                [
                    'moduleID'         => $module->moduleID,
                    'studentID'        => $anis->studentID,
                    'attendanceStatus' => 'PRESENT',
                    'totalMarks'       => 92,
                    'enrolled_At'      => '2025-10-01 08:00:00',
                ],
                [
                    'moduleID'         => $module->moduleID,
                    'studentID'        => $zhang->studentID,
                    'attendanceStatus' => 'PRESENT',
                    'totalMarks'       => 88,
                    'enrolled_At'      => '2025-10-01 08:00:00',
                ],
                [
                    'moduleID'         => $module->moduleID,
                    'studentID'        => $tian->studentID,
                    'attendanceStatus' => 'PRESENT',
                    'totalMarks'       => 85,
                    'enrolled_At'      => '2025-10-01 08:00:00',
                ],
                [
                    'moduleID'         => $module->moduleID,
                    'studentID'        => $ainul->studentID,
                    'attendanceStatus' => 'PRESENT',
                    'totalMarks'       => 85,
                    'enrolled_At'      => '2025-10-01 08:00:00',
                ],
            ]);
        }

        // ── CB23083 & CB23084 only: 2 current semester modules ──
        $currentModules = DB::table('koqmodule')
            ->whereIn('code', ['UQU1012', 'UQU2022'])
            ->get();

        foreach ($currentModules as $module) {
            DB::table('moduleenrollment')->insert([
                [
                    'moduleID'         => $module->moduleID,
                    'studentID'        => $anis->studentID,
                    'attendanceStatus' => 'PRESENT',
                    'totalMarks'       => 100,
                    'enrolled_At'      => '2026-03-01 08:00:00',
                ],
                [
                    'moduleID'         => $module->moduleID,
                    'studentID'        => $zhang->studentID,
                    'attendanceStatus' => 'PRESENT',
                    'totalMarks'       => 100,
                    'enrolled_At'      => '2026-03-01 08:00:00',
                ],
            ]);
        }
    }
}
