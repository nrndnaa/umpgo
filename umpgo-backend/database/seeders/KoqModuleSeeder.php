<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class KoqModuleSeeder extends Seeder
{
    public function run(): void
    {
        $adabId = DB::table('pusatadab')->first()->adabID;

        // 2. Insert dummy modules
        DB::table('koqmodule')->insert([
            [
                'adabID'      => $adabId,
                'code'        => 'UQU1012',
                'name'        => 'Sukan & Rekreasi',
                'campus'      => 'UMP Gambang',
                'catsPoint'   => 2,
                'maxSlots'    => 40,
                'filledSlots' => 0,
                'startDate'   => '2026-06-01',
                'endDate'     => '2026-09-01',
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
                'endDate'     => '2026-09-15',
                'startTime'   => '09:00:00',
                'endTime'     => '11:00:00',
                'venue'       => 'Seminar Room 1',
                'groupLink'   => 'https://chat.whatsapp.com/example2',
            ],
        ]);
    }
}
