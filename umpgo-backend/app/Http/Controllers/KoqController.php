<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\KoqModule;
use App\Models\ModuleEnrollment;
use App\Models\CreditClaim;
use App\Models\Student;

class KoqController extends Controller
{
    // ─── STUDENT - MODULE BROWSING ──────────────────────────────

    public function getModules(Request $request)
    {
        $studentID = $request->query('studentID');

        $modules = KoqModule::withCount('enrollments as filledSlots')
            ->get()
            ->filter(function ($module) use ($studentID) {
                // Hide full modules
                if ($module->filledSlots >= $module->maxSlots) {
                    return false;
                }
                // Hide already registered modules
                if ($studentID) {
                    $alreadyRegistered = ModuleEnrollment::where('moduleID', $module->moduleID)
                        ->where('studentID', $studentID)
                        ->exists();
                    if ($alreadyRegistered) {
                        return false;
                    }
                }
                return true;
            })
            ->values();

        return response()->json($modules);
    }

    public function getStudentCats($studentID)
    {
        $totalCats = ModuleEnrollment::where('moduleenrollment.studentID', $studentID)
            ->where('moduleenrollment.attendanceStatus', 'PRESENT')
            ->join('koqmodule', 'moduleenrollment.moduleID', '=', 'koqmodule.moduleID')
            ->sum('koqmodule.catsPoint');

        return response()->json(['totalCats' => $totalCats]);
    }

    // ─── STUDENT - MODULE REGISTRATION ─────────────────────────

    public function registerModule(Request $request)
    {
        $request->validate([
            'moduleID'  => 'required',
            'studentID' => 'required',
        ]);

        // 1. Check already registered same module
        $existing = ModuleEnrollment::where('moduleID', $request->moduleID)
            ->where('studentID', $request->studentID)
            ->first();

        if ($existing) {
            return response()->json(['message' => 'Already registered!'], 400);
        }

        // 2. Check max 2 modules per semester
        $month = date('n');
        $year  = date('Y');

        if ($month >= 9) {
            // Sem 1: September - February next year
            $semStart = $year . '-09-01';
            $semEnd   = ($year + 1) . '-02-28';
        } else if ($month <= 2) {
            // Sem 1 continuing: January - February
            $semStart = ($year - 1) . '-09-01';
            $semEnd   = $year . '-02-28';
        } else {
            // Sem 2: March - August
            $semStart = $year . '-03-01';
            $semEnd   = $year . '-08-31';
        }

        $semesterCount = ModuleEnrollment::where('studentID', $request->studentID)
            ->whereBetween('enrolled_At', [$semStart, $semEnd])
            ->count();

        if ($semesterCount >= 2) {
            return response()->json([
                'message' => 'You can only register maximum 2 modules per semester!'
            ], 400);
        }

        // 3. Check module not full
        $module = KoqModule::find($request->moduleID);

if (!$module) {
    return response()->json([
        'message' => 'Module not found'
    ], 404);
}

$currentSlots = ModuleEnrollment::where('moduleID', $request->moduleID)->count();

if ($currentSlots >= $module->maxSlots) {
    return response()->json([
        'message' => 'Module is full!'
    ], 400);
}

        // 4. Register!
        $enrollment = ModuleEnrollment::create([
            'moduleID'         => $request->moduleID,
            'studentID'        => $request->studentID,
            'attendanceStatus' => 'Pending',
            'totalMarks'       => '0',
            'enrolled_At'      => now(),
        ]);

        // 5. Update filledSlots
        $module->increment('filledSlots');

        return response()->json(['message' => 'Successfully registered!', 'data' => $enrollment]);
    }

    // ─── STUDENT - MY BOOKINGS ──────────────────────────────────

    public function getMyBookings($studentID)
    {
        $bookings = ModuleEnrollment::with('module')
            ->where('studentID', $studentID)
            ->get();
        return response()->json($bookings);
    }

    // ─── STUDENT - CREDIT CLAIM ─────────────────────────────────

    public function submitCreditClaim(Request $request)
    {
        $request->validate([
            'studentID' => 'required',
        ]);

        // 1. Check already submitted
        $existing = CreditClaim::where('studentID', $request->studentID)->first();
        if ($existing) {
            return response()->json(['message' => 'Already submitted!'], 400);
        }

        // 2. Count CATS from PRESENT modules only
        $totalCats = ModuleEnrollment::where('moduleenrollment.studentID', $request->studentID)
            ->where('moduleenrollment.attendanceStatus', 'PRESENT')
            ->join('koqmodule', 'moduleenrollment.moduleID', '=', 'koqmodule.moduleID')
            ->sum('koqmodule.catsPoint');

        // 3. Minimum 8 CATS required
        if ($totalCats < 8) {
            return response()->json(['message' => 'Minimum 8 CATS required!'], 400);
        }

        // 4. Get current semester
        $month = date('n');
        $year  = date('Y');

        if ($month >= 9) {
            $semester = 'SEMESTER I ACADEMIC SESSION ' . $year . '/' . ($year + 1);
        } elseif ($month <= 2) {
            $semester = 'SEMESTER I ACADEMIC SESSION ' . ($year - 1) . '/' . $year;
        } else {
            $semester = 'SEMESTER II ACADEMIC SESSION ' . ($year - 1) . '/' . $year;
        }

        // 5. Submit!
        $claim = CreditClaim::create([
            'studentID'    => $request->studentID,
            'semester'     => $semester,
            'totalCats'    => $totalCats,
            'status'       => 'Completed',
            'submitted_At' => now(),
        ]);

        return response()->json(['message' => 'Credit claim submitted!', 'data' => $claim]);
    }

    public function getStudentClaim($studentID)
    {
        $claim = CreditClaim::where('studentID', $studentID)->first();

        if (!$claim) {
            return response()->json(null, 404);
        }

        return response()->json($claim);
    }

    // ─── PUSAT ADAB - DASHBOARD ─────────────────────────────────

    public function getDashboardStats()
    {
        $month = date('n');
        $year  = date('Y');

        if ($month >= 9) {
            $semester = 'SEMESTER I ACADEMIC SESSION ' . $year . '/' . ($year + 1);
        } elseif ($month <= 2) {
            $semester = 'SEMESTER I ACADEMIC SESSION ' . ($year - 1) . '/' . $year;
        } else {
            $semester = 'SEMESTER II ACADEMIC SESSION ' . ($year - 1) . '/' . $year;
        }

        $totalActivities      = KoqModule::count();
        $totalEnrollment      = ModuleEnrollment::count();
        $presentCount         = ModuleEnrollment::where('attendanceStatus', 'PRESENT')->count();
        $attendancePercentage = $totalEnrollment > 0
            ? round(($presentCount / $totalEnrollment) * 100) . '%'
            : '0%';

        $approvedClaims = CreditClaim::where('semester', $semester)
            ->where('status', 'Completed')
            ->count();

        return response()->json([
            'totalActivities'      => $totalActivities,
            'totalEnrollment'      => $totalEnrollment,
            'attendancePercentage' => $attendancePercentage,
            'approvedClaims'       => $approvedClaims,
        ]);
    }

    // ─── PUSAT ADAB - MODULE MANAGEMENT ─────────────────────────

    public function addModule(Request $request)
    {
        try {
            $request->validate([
                'adabID' => 'required',
                'code' => 'required',
                'name' => 'required',
                'catsPoint' => 'required',
                'maxSlots' => 'required',
            ]);

            $module = KoqModule::create([
                'adabID'      => $request->adabID,
                'code'        => $request->code,
                'name'        => $request->name,
                'catsPoint'   => $request->catsPoint,
                'maxSlots'    => $request->maxSlots,
                'filledSlots' => 0,
                'startDate'   => $request->startDate,
                'startTime'   => $request->startTime,
                'endDate'     => $request->endDate,
                'endTime'     => $request->endTime,
                'campus'      => $request->campus,
                'venue'       => $request->venue,
                'groupLink'   => $request->groupLink,
            ]);

            return response()->json([
                'message' => 'Module added!',
                'data' => $module
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'error' => $e->getMessage()
            ], 500);
        }
    }
    public function updateModule(Request $request, $id)
    {
        $module = KoqModule::find((int)$id);

        if (!$module) {
            return response()->json(['message' => 'Module not found! ID: ' . $id], 404);
        }

        $module->update([
            'name'      => $request->name,
            'code'      => $request->code,
            'startDate' => $request->startDate,
            'startTime' => $request->startTime,
            'endDate'   => $request->endDate,
            'endTime'   => $request->endTime,
            'campus'    => $request->campus,
            'venue'     => $request->venue,
            'catsPoint' => $request->catsPoint,
            'maxSlots'  => $request->maxSlots,
            'groupLink' => $request->groupLink,
        ]);

        return response()->json(['message' => 'Module updated!', 'data' => $module]);
    }

    public function deleteModule($id)
    {
        $module = KoqModule::find((int)$id);

        if (!$module) {
            return response()->json(['message' => 'Module not found!'], 404);
        }

        $module->delete();
        return response()->json(['message' => 'Module deleted!']);
    }

    // ─── PUSAT ADAB - ENROLLMENT MANAGEMENT ─────────────────────

    public function getAllModules()
    {
        $modules = KoqModule::withCount('enrollments as filledSlots')->get();
        return response()->json($modules);
    }

    public function getEnrollmentsByModule($moduleID)
    {
        $enrollments = ModuleEnrollment::with('student')
            ->where('moduleID', $moduleID)
            ->get()
            ->map(function ($enrollment) {
                return [
                    'matricID' => $enrollment->student->matricID,
                    'name'     => $enrollment->student->name,
                ];
            });

        return response()->json($enrollments);
    }

    public function updateEnrollment(Request $request, $modEnrollID)
    {
        $enrollment = ModuleEnrollment::findOrFail($modEnrollID);

        $attendanceStatus = $request->attendanceStatus ?? $enrollment->attendanceStatus;
        $totalMarks = $attendanceStatus === 'PRESENT' ? '100%' : ($request->totalMarks ?? $enrollment->totalMarks);

        $enrollment->update([
            'attendanceStatus' => $attendanceStatus,
            'totalMarks'       => $totalMarks,
        ]);

        return response()->json(['message' => 'Enrollment updated!', 'data' => $enrollment]);
    }

    // ─── PUSAT ADAB - CREDIT CLAIMS MANAGEMENT ──────────────────

    public function getCreditClaims(Request $request)
    {
        $query = CreditClaim::with('student');

        if ($request->has('semester')) {
            $query->where('semester', $request->semester);
        }

        return response()->json($query->get());
    }

    public function updateClaimStatus(Request $request, $claimID)
    {
        $request->validate([
            'status' => 'required|in:Pending,Completed,Rejected',
        ]);

        $claim = CreditClaim::findOrFail($claimID);
        $claim->update(['status' => $request->status]);

        return response()->json(['message' => 'Claim status updated!', 'data' => $claim]);
    }
}