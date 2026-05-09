<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\Subject;
use App\Models\Enrollment;
use App\Models\Section;

class OpenRegistrationController extends Controller
{
    // GET /api/registration-sessions
    public function getSessions()
    {
        $sessions = DB::table('registrationsession')->get();

        return response()->json([
            'success'  => true,
            'sessions' => $sessions,
        ]);
    }

    // POST /api/registration-sessions (RENAMED TO AVOID CONFLICT)
    public function createSession(Request $request)
    {
        $request->validate([
            'registrarID'  => 'required',
            'eligableYear' => 'required|string',
            'startDate'    => 'required|date',
            'endDate'      => 'required|date',
            'startTime'    => 'required',
            'endTime'      => 'required',
        ]);

        DB::table('registrationsession')->insert([
            'registrarID'  => $request->registrarID,
            'eligableYear' => $request->eligableYear,
            'startDate'    => $request->startDate,
            'endDate'      => $request->endDate,
            'startTime'    => $request->startTime,
            'endTime'      => $request->endTime,
            'created_at'   => now(),
            'updated_at'   => now(),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Registration session created successfully.',
        ]);
    }

    // GET /api/registration-sessions/check?year=Year+3
    public function checkOpenRegistrationStatus(Request $request)
    {
        $year = $request->query('year');
        $today = now()->toDateString();
        $currentTime = now()->toTimeString();

        $session = DB::table('registrationsession')
            ->where('eligableYear', $year)
            ->whereDate('startDate', '<=', $today)
            ->whereDate('endDate', '>=', $today)
            ->whereTime('startTime', '<=', $currentTime)
            ->whereTime('endTime', '>=', $currentTime)
            ->first();

        return response()->json([
            'success' => true,
            'active'  => $session !== null,
            'session' => $session,
        ]);
    }

<<<<<<< Updated upstream
    // GET /api/subjects
    public function igetAllSubjects()
    {
        $subjects = Subject::with(['sections' => function ($query) {
            $query->withCount('enrollments as enrolled');
        }])->get();

        $subjects->each(function ($subject) {
            $subject->sections->each(function ($section) {
                $section->enrolled = $section->enrollments_count ?? 0;
            });
        });

        return response()->json([
            'success'  => true,
            'subjects' => $subjects,
        ]);
    }

    // GET /api/sections/{sectionID}/students
    public function getSectionStudents($sectionID)
    {
        $students = DB::table('enrollment')
            ->join('student', 'enrollment.studentID', '=', 'student.studentID')
            ->where('enrollment.sectionID', $sectionID)
            ->select(
                'student.studentID',
                'student.name',
                'student.matricID',
                'enrollment.enrollmentID',
                'enrollment.created_at as enrolledAt'
            )
            ->get();

        return response()->json([
            'success'   => true,
            'sectionID' => $sectionID,
            'students'  => $students,
        ]);
    }

    // GET /api/student-registration-status
    public function getStudentRegistrationStatus()
    {
        $totalStudents = DB::table('student')->count();

        $registeredCount = DB::table('enrollment')
            ->distinct('studentID')
            ->count('studentID');

        $notRegistered = $totalStudents - $registeredCount;

        $students = DB::table('student')
            ->leftJoin('enrollment', 'student.studentID', '=', 'enrollment.studentID')
            ->select(
                'student.studentID',
                'student.name',
                'student.matricID',
                DB::raw('COUNT(enrollment.enrollmentID) as totalEnrollments')
            )
            ->groupBy('student.studentID', 'student.name', 'student.matricID')
            ->orderBy('student.matricID')
            ->get()
            ->map(function ($s) {
                $s->registered = $s->totalEnrollments > 0;
                return $s;
            });

        return response()->json([
            'success'          => true,
            'totalStudents'    => $registeredCount,
            'notRegistered'    => $notRegistered,
            'students'         => $students,
        ]);
    }

    // GET /api/approve-enrollment
    public function getEnrolledStudents()
    {
        $students = DB::table('student')
            ->whereIn('studentID', function ($query) {
                $query->select('studentID')->from('enrollment');
            })
            ->select('studentID', 'name', 'matricID', 'programme')
            ->orderBy('matricID')
            ->get();

        return response()->json([
            'success'  => true,
            'students' => $students,
        ]);
    }

    // GET /api/approve-enrollment/{studentID}
    public function getStudentEnrollments($studentID)
    {
        $student = DB::table('student')->where('studentID', $studentID)->first();

        $enrollments = DB::table('enrollment')
            ->join('section', 'enrollment.sectionID', '=', 'section.sectionID')
            ->join('subject', 'section.subjectID', '=', 'subject.subjectID')
            ->where('enrollment.studentID', $studentID)
            ->select(
                'enrollment.enrollmentID',
                'enrollment.status',
                'subject.subjectCode',
                'subject.subjectName'
            )
            ->get();

        return response()->json([
            'success'     => true,
            'student'     => $student,
            'enrollments' => $enrollments,
        ]);
    }

    // POST /api/approve-enrollment/{enrollmentID}/update-status
    public function updateEnrollmentStatus(Request $request, $enrollmentID)
    {
        $request->validate(['status' => 'required|in:Approved,Rejected,Pending']);

        DB::table('enrollment')->where('enrollmentID', $enrollmentID)->update([
            'status'     => $request->status,
            'updated_at' => now(),
        ]);

        return response()->json(['success' => true, 'message' => 'Status updated.']);
    }

    // POST /api/enroll
    // Replace the enroll() method in OpenRegistrationController.php with this:

    public function registerSubject(Request $request)
    {
        $request->validate([
            'studentID' => 'required',
            'sectionID' => 'required',
        ]);

        // 1. Fetch the section
        $section = Section::where('sectionID', $request->sectionID)->first();
        if (!$section) {
            return response()->json(['success' => false, 'error' => 'section_not_found', 'message' => 'Section not found.'], 404);
        }

        // 2. Fetch the student
        $student = DB::table('student')->where('studentID', $request->studentID)->first();
        if (!$student) {
            return response()->json(['success' => false, 'error' => 'student_not_found', 'message' => 'Student not found.'], 404);
        }

        // 3. Find active registration session
        $today = now()->toDateString();
        $currentTime = now()->toTimeString();

        $session = DB::table('registrationsession')
            ->whereIn('eligableYear', [$student->yearOfStudy, 'All Year'])
            ->whereDate('startDate', '<=', $today)
            ->whereDate('endDate', '>=', $today)
            ->whereTime('startTime', '<=', $currentTime)
            ->whereTime('endTime', '>=', $currentTime)
            ->first();

        if (!$session) {
            return response()->json(['success' => false, 'error' => 'no_session', 'message' => 'No active registration session found.'], 403);
        }

        // 4. Check for existing enrollment in this section
        $exists = DB::table('enrollment')
            ->where('studentID', $request->studentID)
            ->where('sectionID', $request->sectionID)
            ->exists();

        if ($exists) {
            return response()->json(['success' => false, 'error' => 'already_enrolled', 'message' => 'Already enrolled in this section.']);
        }

        // 5. Check for subject conflict (same subject, different section)
        $subjectConflict = DB::table('enrollment')
            ->join('section', 'enrollment.sectionID', '=', 'section.sectionID')
            ->where('enrollment.studentID', $request->studentID)
            ->where('section.subjectID', $section->subjectID)
            ->exists();

        if ($subjectConflict) {
            return response()->json(['success' => false, 'error' => 'subject_conflict', 'message' => 'Already enrolled in this subject.']);
        }

        // 6. Check section capacity
        $enrolled = DB::table('enrollment')->where('sectionID', $request->sectionID)->count();
        if ($section->capacity && $enrolled >= $section->capacity) {
            return response()->json(['success' => false, 'error' => 'section_full', 'message' => 'Section is Full']);
        }

        // 7. Check credit hour limit (max 20)
        $currentCredits = DB::table('enrollment')
            ->join('section', 'enrollment.sectionID', '=', 'section.sectionID')
            ->join('subject', 'section.subjectID', '=', 'subject.subjectID')
            ->where('enrollment.studentID', $request->studentID)
            ->sum('subject.creditHours');

        $newSubject = DB::table('subject')->where('subjectID', $section->subjectID)->first();
        $newCredits = $newSubject ? $newSubject->creditHours : 0;

        if (($currentCredits + $newCredits) > 20) {
            return response()->json([
                'success' => false,
                'error' => 'credit_exceeded',
                'message' => 'Credit hours exceeded',
                'current' => $currentCredits,
                'adding' => $newCredits,
                'max' => 20,
            ]);
        }

        // 8. Check time/day clash
        $clash = DB::table('enrollment')
            ->join('section', 'enrollment.sectionID', '=', 'section.sectionID')
            ->where('enrollment.studentID', $request->studentID)
            ->where('section.day', $section->day)
            ->where(function ($q) use ($section) {
                $q->where(function ($q2) use ($section) {
                    $q2->where('section.startTime', '<', $section->endTime)
                        ->where('section.endTime', '>', $section->startTime);
                });
            })
            ->select('section.day', 'section.startTime', 'section.endTime')
            ->first();

        if ($clash) {
            return response()->json([
                'success' => false,
                'error' => 'time_clash',
                'message' => 'Schedule Conflict',
                'clash_day' => $clash->day,
                'clash_start' => $clash->startTime,
                'clash_end' => $clash->endTime,
            ]);
        }

        // 9. Insert enrollment
        DB::table('enrollment')->insert([
            'studentID'     => $request->studentID,
            'sectionID'     => $request->sectionID,
            'sessionID'     => $session->sessionID,
            'status'        => 'Pending',
            'registered_At' => now(),
            'created_at'    => now(),
            'updated_at'    => now(),
        ]);

        return response()->json(['success' => true, 'message' => 'Enrolled successfully.']);
    }

    // Add this inside the OpenRegistrationController class
    public function getSubjectsWithSections()
    {
        // Fetch subjects with their sections and enrollment counts
        $subjects = Subject::with(['sections' => function ($query) {
            $query->withCount('enrollments as enrolled');
        }])->get();

        // Map the enrollments_count to 'enrolled' for the Flutter model
        $subjects->each(function ($subject) {
            $subject->sections->each(function ($section) {
                $section->enrolled = $section->enrollments_count ?? 0;
            });
        });

        return response()->json([
            'success'  => true,
            'subjects' => $subjects,
        ]);
    }

    // GET /api/my-enrollments/{studentID}
    public function getMyEnrollments($studentID)
    {
        $enrollments = DB::table('enrollment')
            ->join('section', 'enrollment.sectionID', '=', 'section.sectionID')
            ->join('subject', 'section.subjectID', '=', 'subject.subjectID')
            ->where('enrollment.studentID', $studentID)
            ->select(
                'enrollment.enrollmentID',
                'enrollment.sectionID',      // ← required for _isEnrolled in Flutter
                'enrollment.status',
                'subject.subjectCode',
                'subject.subjectName',
                'subject.creditHours',
                'section.sectionNo',
                'section.day',
                'section.startTime',
                'section.endTime',
                'section.venue',
            )
            ->get();

        return response()->json([
            'success'     => true,
            'enrollments' => $enrollments,
        ]);
    }

    // DELETE /api/enroll/{enrollmentID}
    public function dropSubject($enrollmentID)
    {
        DB::table('enrollment')->where('enrollmentID', $enrollmentID)->delete();

        return response()->json([
            'success' => true,
            'message' => 'Subject dropped successfully.',
        ]);
=======
    public function checkSession($yearOfStudy)
    {
        $now = now();
        $today = $now->toDateString();
        $time  = $now->toTimeString();

        $session = \App\Models\RegistrationSession::where('eligableYear', $yearOfStudy)
            ->where('startDate', '<=', $today)
            ->where('endDate',   '>=', $today)
            ->where('startTime', '<=', $time)
            ->where('endTime',   '>=', $time)
            ->first();

        if ($session) {
            return response()->json(['open' => true,  'session' => $session]);
        } else {
            return response()->json(['open' => false, 'session' => null]);
        }
>>>>>>> Stashed changes
    }
}
