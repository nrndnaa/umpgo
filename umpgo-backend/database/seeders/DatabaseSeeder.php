<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $this->call([
            StudentSeeder::class,
            LecturerSeeder::class,
            TreasurySeeder::class,
            FacultyRegistrarSeeder::class,
            PusatAdabSeeder::class,
            KoqModuleSeeder::class, // Now this will work[cite: 1]
            SubjectSeeder::class,  // Needed for Section
            SectionSeeder::class,  // Depends on the two above
        ]);
    }
}
