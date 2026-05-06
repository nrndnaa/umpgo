<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\KoqModule;
use App\Models\ModuleEnrollment;
use App\Models\CreditClaim;
use App\Models\Student;

class KoqController extends Controller
{
    public function getModules()
{
    $modules = KoqModule::withCount('enrollments as filledSlots')->get();
    return response()->json($modules);
}

    public function registerModule(Request $request)
    {
        $request->validate([
            'moduleID' => 'required',
            'studentID' => 'required',
        ]);

        $existing = ModuleEnrollment::where('moduleID', $request->moduleID)
            ->where('studentID', $request->studentID)
            ->first();

        if ($existing) {
            return response()->json(['message' => 'Already registered!'], 400);
        }

        $module = KoqModule::find($request->moduleID);
        if ($module->filledSlots >= $module->maxSlots) {
            return response()->json(['message' => 'Module is full!'], 400);
        }

        $enrollment = ModuleEnrollment::create([
            'moduleID' => $request->moduleID,
            'studentID' => $request->studentID,
            'attendanceStatus' => 'Pending',
            'totalMarks' => '0%',
            'enrolled_At' => now(),
        ]);

        return response()->json(['message' => 'Successfully registered!', 'data' => $enrollment]);
    }

    public function getMyBookings($studentID)
    {
        $bookings = ModuleEnrollment::with('module')
            ->where('studentID', $studentID)
            ->get();
        return response()->json($bookings);
    }

    public function submitCreditClaim(Request $request)
    {
        $request->validate([
            'studentID' => 'required',
        ]);

        $existing = CreditClaim::where('studentID', $request->studentID)->first();
        if ($existing) {
            return response()->json(['message' => 'Already submitted!'], 400);
        }

        $totalCats = ModuleEnrollment::where('studentID', $request->studentID)->count() * 2;

        if ($totalCats < 8) {
            return response()->json(['message' => 'Minimum 8 CATS required!'], 400);
        }

        $month = date('n');
        $year = date('Y');

        if ($month >= 7) {
    $semester = 'SEMESTER I ACADEMIC SESSION '.$year.'/'.($year+1);
} else {
    $semester = 'SEMESTER II ACADEMIC SESSION '.($year-1).'/'.$year;
}

        $claim = CreditClaim::create([
            'studentID' => $request->studentID,
            'semester' => $semester,
            'totalCats' => $totalCats,
            'status' => 'Completed',
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

// ─── PUSAT ADAB - MODULE MANAGEMENT ────────────────────

public function getDashboardStats()
{
    $month = date('n');
    $year = date('Y');
    if ($month >= 7 && $month <= 12) {
        $semester = 'SEMESTER I ACADEMIC SESSION '.$year.'/'.($year+1);
    } else {
        $semester = 'SEMESTER II ACADEMIC SESSION '.($year-1).'/'.$year;
    }
    
    $totalActivities = KoqModule::count();

    $totalEnrollment = ModuleEnrollment::count();

    $presentCount = ModuleEnrollment::where('attendanceStatus', 'PRESENT')->count();
    $attendancePercentage = $totalEnrollment > 0
        ? round(($presentCount / $totalEnrollment) * 100) . '%'
        : '0%';

$approvedClaims = CreditClaim::where('semester', $semester)
    ->where('status', 'Completed')
    ->count();

    return response()->json([
        'totalActivities' => $totalActivities,
        'totalEnrollment' => $totalEnrollment,
        'attendancePercentage' => $attendancePercentage,
        'approvedClaims' => $approvedClaims,
    ]);
}

public function addModule(Request $request)
{
    $module = KoqModule::create([
        'staffID' => $request->staffID,
        'code' => $request->code,
        'name' => $request->name,
        'catsPoint' => $request->catsPoint,
        'maxSlots' => $request->maxSlots,
        'filledSlots' => 0,
        'startDate' => $request->startDate,
        'startTime' => $request->startTime,
        'endDate' => $request->endDate,
        'endTime' => $request->endTime,
        'campus' => $request->campus,
        'venue' => $request->venue,
        'groupLink' => $request->groupLink,
    ]);
    return response()->json([
        'message' => 'Module added!',
        'data' => $module
    ], 201);
}
public function updateModule(Request $request, $id)
{
    // Force integer
    $module = KoqModule::find((int)$id);
    
    if (!$module) {
        return response()->json(['message' => 'Module not found! ID: '.$id], 404);
    }

    $module->update([
        'name' => $request->name,
        'code' => $request->code,
        'startDate' => $request->startDate,
        'startTime' => $request->startTime,
        'endDate' => $request->endDate,
        'endTime' => $request->endTime,
        'campus' => $request->campus,
        'venue' => $request->venue,
        'catsPoint' => $request->catsPoint,
        'maxSlots' => $request->maxSlots,
        'groupLink' => $request->groupLink,
    ]);

    return response()->json([
        'message' => 'Module updated!',
        'data' => $module
    ]);
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

// ─── PUSAT ADAB - ENROLLMENT MANAGEMENT ────────────────

public function getEnrollmentsByModule($moduleID)
{
    $enrollments = ModuleEnrollment::with('student')
        ->where('moduleID', $moduleID)
        ->get()
        ->map(function($enrollment) {
            return [
                'matricID' => $enrollment->student->matricID,
                'name' => $enrollment->student->name,
            ];
        });
    return response()->json($enrollments);
}
public function updateEnrollment(Request $request, $modEnrollID)
{
    $enrollment = ModuleEnrollment::findOrFail($modEnrollID);
    $enrollment->update([
        'attendanceStatus' => $request->attendanceStatus ?? $enrollment->attendanceStatus,
        'totalMarks'       => $request->totalMarks ?? $enrollment->totalMarks,
    ]);
    return response()->json(['message' => 'Enrollment updated!', 'data' => $enrollment]);
}

// ─── PUSAT ADAB - CREDIT CLAIMS MANAGEMENT ─────────────

public function getCreditClaims(Request $request)
{
    $query = CreditClaim::with('student');
    
    if ($request->has('semester')) {
        $query->where('semester', $request->semester);
    }
    
    $claims = $query->get();
    return response()->json($claims);
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