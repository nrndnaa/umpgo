<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class KoqModuleSeeder extends Seeder
{
    public function run(): void
    {
        $adabId = DB::table('pusatadab')->first()->adabID;

        DB::table('koqmodule')->insert([
            // ── Current Semester: March 2026 – June 2026 ──────────────────

            [
                'adabID'      => $adabId,
                'code'        => 'UQU1012',
                'name'        => 'Sukan & Rekreasi',
                'campus'      => 'UMP Gambang',
                'catsPoint'   => 2,
                'maxSlots'    => 40,
                'filledSlots' => 12,
                'startDate'   => '2026-06-01',
                'endDate'     => '2026-06-01',
                'startTime'   => '08:00:00',
                'endTime'     => '10:00:00',
                'venue'       => 'Sports Complex UMP',
                'groupLink'   => 'https://chat.whatsapp.com/example1',
            ],
            [
                'adabID'      => $adabId,
                'code'        => 'UQU2022',
                'name'        => 'Pengurusan Organisasi',
                'campus'      => 'UMP Gambang',
                'catsPoint'   => 2,
                'maxSlots'    => 30,
                'filledSlots' => 5,
                'startDate'   => '2026-06-15',
                'endDate'     => '2026-06-15',
                'startTime'   => '09:00:00',
                'endTime'     => '11:00:00',
                'venue'       => 'Seminar Room 1',
                'groupLink'   => 'https://chat.whatsapp.com/example2',
            ],
            [
                'adabID'      => $adabId,
                'code'        => 'UQU3033',
                'name'        => 'Kepimpinan & Pembangunan Diri',
                'campus'      => 'UMP Gambang',
                'catsPoint'   => 2,
                'maxSlots'    => 25,
                'filledSlots' => 20,
                'startDate'   => '2026-06-10',
                'endDate'     => '2026-06-10',
                'startTime'   => '10:00:00',
                'endTime'     => '12:00:00',
                'venue'       => 'Seminar Room 2',
                'groupLink'   => 'https://chat.whatsapp.com/example3',
            ],
            [
                'adabID'      => $adabId,
                'code'        => 'UQU8083',
                'name'        => 'Adobe Photoshop',
                'campus'      => 'UMP Pekan',
                'catsPoint'   => 2,
                'maxSlots'    => 20,
                'filledSlots' => 8,
                'startDate'   => '2026-06-20',
                'endDate'     => '2026-06-20',
                'startTime'   => '09:00:00',
                'endTime'     => '11:00:00',
                'venue'       => 'Lab Komputer UMP',
                'groupLink'   => 'https://chat.whatsapp.com/photoshop',
            ],

            // ── Past Semester: October 2025 – January 2026 ────────────────

            [
                'adabID'      => $adabId,
                'code'        => 'UQU4044',
                'name'        => 'Khidmat Masyarakat',
                'campus'      => 'UMP Gambang',
                'catsPoint'   => 2,
                'maxSlots'    => 20,
                'filledSlots' => 4,
                'startDate'   => '2026-01-01',
                'endDate'     => '2026-01-01',
                'startTime'   => '11:00:00',
                'endTime'     => '13:00:00',
                'venue'       => 'Community Hall UMP',
                'groupLink'   => 'https://chat.whatsapp.com/example4',
            ],
            [
                'adabID'      => $adabId,
                'code'        => 'UQU8081',
                'name'        => 'Asas Catur',
                'campus'      => 'UMP Gambang',
                'catsPoint'   => 2,
                'maxSlots'    => 30,
                'filledSlots' => 4,
                'startDate'   => '2026-01-15',
                'endDate'     => '2026-01-15',
                'startTime'   => '14:00:00',
                'endTime'     => '16:00:00',
                'venue'       => 'Bilik Rekreasi UMP',
                'groupLink'   => 'https://chat.whatsapp.com/catur',
            ],
            [
    'adabID'      => $adabId,
    'code'        => 'UQU8082',
    'name'        => 'Fotografi Asas',
    'campus'      => 'UMP Gambang',
    'catsPoint'   => 2,
    'maxSlots'    => 25,
    'filledSlots' => 2,
    'startDate'   => '2025-11-10',
    'endDate'     => '2025-11-10',
    'startTime'   => '10:00:00',
    'endTime'     => '12:00:00',
    'venue'       => 'Studio Fotografi UMP',
    'groupLink'   => 'https://chat.whatsapp.com/fotografi',
],
        ]);
    }
}
