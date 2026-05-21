<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class SectionSeeder extends Seeder
{
    public function run(): void
    {
        $subjects = DB::table('subject')->get();
        $lecturer = DB::table('lecturer')->first();
        $lecturerId = $lecturer ? $lecturer->lecturerID : null;

        // Possible start times (end time = start + 2 hours)
        $timeSlots = [
            ['start' => '08:00:00', 'end' => '10:00:00'],
            ['start' => '10:00:00', 'end' => '12:00:00'],
            ['start' => '14:00:00', 'end' => '16:00:00'],
            ['start' => '16:00:00', 'end' => '18:00:00'],
        ];

        foreach ($subjects as $subject) {
            $count = (rand(0, 1) == 1) ? 4 : 2;
            $allLabels = ['1A', '1B', '2A', '2B'];
            $labelsToUse = array_slice($allLabels, 0, $count);

            foreach ($labelsToUse as $index => $label) {
                $slot = $timeSlots[array_rand($timeSlots)];

                DB::table('section')->insert([
                    'subjectID'  => $subject->subjectID,
                    'lecturerID' => $lecturerId,
                    'sectionNo'  => $label,
                    'capacity'   => rand(20, 40),
                    'venue'      => 'Room ' . rand(100, 500),
                    'day'        => $this->getDay($index),
                    'startTime'  => $slot['start'],
                    'endTime'    => $slot['end'],
                ]);
            }
        }
    }

    private function getDay($index)
    {
        $days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday'];
        return $days[$index];
    }
}
