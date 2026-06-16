<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\AttendanceSession;
use App\Models\AttendanceRecord;
use App\Models\Enrollment;
use App\Models\ModuleEnrollment;
use App\Models\Section;
use App\Models\KoqModule;
use Carbon\Carbon;

class AttendanceController extends Controller
{
    // POST /attendance/session/create
    public function createSession(Request $request)
    {
        $code = strval(rand(100000, 999999));
        $duration = $request->codeDuration ?? 15;

        $session = AttendanceSession::create([
            'lecturerID'   => $request->lecturerID,
            'adabID'       => $request->adabID,
            'sectionID'    => $request->sectionID,
            'moduleID'     => $request->moduleID,
            'sessionTitle' => $request->sessionTitle,
            'code'         => $code,
            'codeDuration' => $duration,
            'codeExpiry'   => Carbon::now()->addMinutes($duration),
            'createdBy'    => $request->createdBy ?? 'Lecturer',
            'started_At'   => Carbon::now(),
            'isActive'     => true,
        ]);

        return response()->json([
            'success' => true,
            'code'    => $code,
            'session' => $session,
        ]);
    }

    // POST /attendance/validate-code
    public function validateCode(Request $request)
    {
        $session = AttendanceSession::where('code', $request->code)
            ->where('isActive', true)
            ->first();

        if (!$session) {
            return response()->json(['success' => false, 'message' => 'Invalid or expired code']);
        }

        if (Carbon::now()->greaterThan($session->codeExpiry)) {
            return response()->json(['success' => false, 'message' => 'Code has expired']);
        }

        // Get venue coordinates
        $venueLat = 3.5480;
        $venueLng = 103.4241;

        if ($session->sectionID) {
            $section = Section::find($session->sectionID);
            // default UMPSA coords
        }

        return response()->json([
            'success' => true,
            'session' => [
                'attSessionID' => $session->attSessionID,
                'sessionTitle' => $session->sessionTitle,
                'code'         => $session->code,
                'codeExpiry'   => $session->codeExpiry,
                'venueLat'     => $venueLat,
                'venueLng'     => $venueLng,
            ],
        ]);
    }

    // POST /attendance/checkin
    public function checkIn(Request $request)
    {
        $session = AttendanceSession::where('code', $request->code)
            ->where('isActive', true)
            ->first();

        if (!$session) {
            return response()->json(['success' => false, 'message' => 'Invalid or expired code']);
        }

        if (Carbon::now()->greaterThan($session->codeExpiry)) {
            return response()->json(['success' => false, 'message' => 'Code has expired']);
        }

        // Check already checked in
        $existing = AttendanceRecord::where('attSessionID', $session->attSessionID)
            ->where('studentID', $request->studentID)
            ->first();

        if ($existing) {
            return response()->json(['success' => false, 'message' => 'Already checked in']);
        }

        $record = AttendanceRecord::create([
            'attSessionID' => $session->attSessionID,
            'studentID'    => $request->studentID,
            'status'       => 'Present',
            'gpsVerified'  => true,
            'latitude'     => $request->latitude,
            'longitude'    => $request->longitude,
            'checkedIn_At' => Carbon::now(),
        ]);

        return response()->json(['success' => true, 'record' => $record]);
    }

    // POST /attendance/session/end
    public function endSession(Request $request)
    {
        $session = AttendanceSession::find($request->attSessionID);
        if (!$session) {
            return response()->json(['success' => false, 'message' => 'Session not found']);
        }
        $session->isActive = false;
        $session->ended_At = Carbon::now();
        $session->save();

        return response()->json(['success' => true]);
    }

    // GET /attendance/session/{sessionID}
    public function getSessionDetail($sessionID)
    {
        $session = AttendanceSession::with(['records.student'])->find($sessionID);
        if (!$session) {
            return response()->json(['success' => false, 'message' => 'Session not found']);
        }

        $students = $session->records->map(function ($record) {
            return [
                'studentID' => $record->studentID,
                'name'      => $record->student->name ?? '',
                'matricID'  => $record->student->matricID ?? '',
                'status'    => $record->status,
            ];
        });

        $present = $session->records->where('status', 'Present')->count();
        $absent  = $session->records->where('status', 'Absent')->count();
        $late    = $session->records->where('status', 'Late')->count();

        return response()->json([
            'success' => true,
            'session' => [
                'attSessionID' => $session->attSessionID,
                'sessionTitle' => $session->sessionTitle,
                'code'         => $session->code,
                'codeExpiry'   => $session->codeExpiry,
                'isActive'     => $session->isActive,
                'started_At'   => $session->started_At,
                'ended_At'     => $session->ended_At,
                'present'      => $present,
                'absent'       => $absent,
                'late'         => $late,
                'total'        => $students->count(),
                'students'     => $students,
            ],
        ]);
    }

    // GET /attendance/sessions?lecturerID=x
    public function getAllSessions(Request $request)
    {
        if ($request->adabID) {
            $sessions = AttendanceSession::where('adabID', $request->adabID)
                ->with('records')
                ->orderBy('started_At', 'desc')
                ->get();
        } else {
            $sessions = AttendanceSession::where('lecturerID', $request->lecturerID)
                ->with('records')
                ->orderBy('started_At', 'desc')
                ->get();
        }

        return response()->json(['success' => true, 'sessions' => $sessions]);
    }

    // GET /attendance/session/active?lecturerID=x
    public function getActiveSession(Request $request)
    {
        if ($request->adabID) {
            $session = AttendanceSession::where('adabID', $request->adabID)
                ->where('isActive', true)
                ->with('records.student')
                ->first();
        } else {
            $session = AttendanceSession::where('lecturerID', $request->lecturerID)
                ->where('isActive', true)
                ->with('records.student')
                ->first();
        }

        if (!$session) {
            return response()->json(['success' => false, 'message' => 'No active session']);
        }

        return response()->json(['success' => true, 'session' => $session]);
    }

    // POST /attendance/session/{sessionID}/edit
    public function editAttendance(Request $request, $sessionID)
    {
        foreach ($request->records as $record) {
            AttendanceRecord::where('attSessionID', $sessionID)
                ->where('studentID', $record['studentID'])
                ->update(['status' => $record['status']]);
        }

        return response()->json(['success' => true]);
    }

    // GET /lecturer/{lecturerID}/sections
    public function getLecturerSections($lecturerID)
    {
        $sections = Section::with('subject')
            ->where('lecturerID', $lecturerID)
            ->get()
            ->map(function ($s) {
                return [
                    'sectionID'   => $s->sectionID,
                    'sectionNo'   => $s->sectionNo,
                    'subjectName' => $s->subject->subjectName ?? '',
                    'subjectCode' => $s->subject->subjectCode ?? '',
                    'day'         => $s->day,
                    'startTime'   => $s->startTime,
                    'endTime'     => $s->endTime,
                    'venue'       => $s->venue,
                ];
            });

        return response()->json(['success' => true, 'sections' => $sections]);
    }

    // GET /student/{studentID}/sections
    public function getStudentSections($studentID)
    {
        $enrollments = Enrollment::with(['section.subject'])
            ->where('studentID', $studentID)
            ->get();

        $sections = $enrollments->map(function ($e) {
            $section = $e->section;
            $subject = $section->subject ?? null;
            return [
                'sectionID'   => $section->sectionID,
                'sectionNo'   => $section->sectionNo,
                'subjectName' => $subject->subjectName ?? '',
                'subjectCode' => $subject->subjectCode ?? '',
                'creditHours' => $subject->creditHours ?? 0,
                'day'         => $section->day,
                'startTime'   => $section->startTime,
                'endTime'     => $section->endTime,
                'venue'       => $section->venue,
            ];
        });

        return response()->json(['success' => true, 'sections' => $sections]);
    }

    // GET /adab/{adabID}/modules
    public function getAdabModules($adabID)
    {
        $modules = KoqModule::where('adabID', $adabID)->get();
        return response()->json(['success' => true, 'modules' => $modules]);
    }

    // GET /student/{studentID}/modules
    public function getStudentModules($studentID)
    {
        $enrollments = ModuleEnrollment::with('module')
            ->where('studentID', $studentID)
            ->get();

        $modules = $enrollments->map(function ($e) {
            return [
                'moduleID'   => $e->module->moduleID ?? null,
                'code'       => $e->module->code ?? '',
                'name'       => $e->module->name ?? '',
                'campus'     => $e->module->campus ?? '',
                'catsPoint'  => $e->module->catsPoint ?? 0,
                'venue'      => $e->module->venue ?? '',
                'startTime'  => $e->module->startTime ?? '',
                'endTime'    => $e->module->endTime ?? '',
            ];
        });

        return response()->json(['success' => true, 'modules' => $modules]);
    }
}