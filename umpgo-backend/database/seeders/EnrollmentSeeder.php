<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class EnrollmentSeeder extends Seeder
{
    public function run(): void
    {
        // Get all students, sections, and the first registration session
        $students = DB::table('student')->get();
        $sections = DB::table('section')->get();
        $session  = DB::table('registrationsession')->first();

        if (!$session) {
            $this->command->warn('No registration session found. Please seed registrationsession first.');
            return;
        }

        if ($students->isEmpty()) {
            $this->command->warn('No students found. Please seed student first.');
            return;
        }

        if ($sections->isEmpty()) {
            $this->command->warn('No sections found. Please seed section first.');
            return;
        }

        foreach ($sections as $section) {
            // Randomly enroll between 5 and capacity students per section
            $enrollCount = rand(5, $section->capacity);

            // Shuffle students and pick $enrollCount of them
            $shuffled = $students->shuffle()->take($enrollCount);

            foreach ($shuffled as $student) {
                // Avoid duplicate enrollment (same student in same section)
                $exists = DB::table('enrollment')
                    ->where('studentID', $student->studentID)
                    ->where('sectionID', $section->sectionID)
                    ->exists();

                if (!$exists) {
                    DB::table('enrollment')->insert([
                        'studentID'     => $student->studentID,
                        'sectionID'     => $section->sectionID,
                        'sessionID'     => $session->sessionID,
                        'status'        => 'Registered',
                        'registered_At' => now(),
                        'created_at'    => now(),
                        'updated_at'    => now(),
                    ]);
                }
            }
        }

        $this->command->info('Enrollment seeded successfully.');
    }
}
