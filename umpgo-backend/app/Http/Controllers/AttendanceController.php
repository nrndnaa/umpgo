<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\AttendanceSession;
use App\Models\AttendanceRecord;

class AttendanceController extends Controller
{
    // Lecturer/Adab creates a session
    public function createSession(Request $request) {
        $code = rand(100000, 999999);
        $session = AttendanceSession::create([
            'lecturerID'   => $request->lecturerID,
            'adabID'       => $request->adabID,
            'sessionTitle' => $request->sessionTitle,
            'code'         => $code,
            'codeDuration' => $request->codeDuration,
            'codeExpiry'   => now()->addMinutes($request->codeDuration),
            'startedAt'    => now(),
            'isActive'     => true,
        ]);
        return response()->json(['success' => true, 'code' => $code, 'session' => $session]);
    }

    // Student checks in
    public function checkIn(Request $request) {
        $session = AttendanceSession::where('code', $request->code)->first();
        if (!$session || now()->greaterThan($session->codeExpiry)) {
            return response()->json(['success' => false, 'message' => 'Invalid or expired code']);
        }

        $record = AttendanceRecord::create([
            'attSessionID' => $session->attSessionID,
            'studentID'    => $request->studentID,
            'gpsVerified'  => $request->gpsVerified,
            'latitude'     => $request->latitude,
            'longitude'    => $request->longitude,
            'checkedIn_At' => now(),
            'status'       => 'Present',
        ]);

        return response()->json(['success' => true, 'record' => $record]);
    }
}
