<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class OpenRegistrationController extends Controller
{
    // GET /api/registration-sessions
    public function index()
    {
        $sessions = DB::table('registrationsession')->get();

        return response()->json([
            'success'  => true,
            'sessions' => $sessions,
        ]);
    }

    // POST /api/registration-sessions
    public function store(Request $request)
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
    public function check(Request $request)
    {
        $year = $request->query('year');
        $now  = now();

        $session = DB::table('registrationsession')
            ->where('eligableYear', $year)
            ->whereDate('startDate', '<=', $now->toDateString())
            ->whereDate('endDate', '>=', $now->toDateString())
            ->whereTime('startTime', '<=', $now->toTimeString())
            ->whereTime('endTime', '>=', $now->toTimeString())
            ->first();

        return response()->json([
            'success' => true,
            'active'  => $session !== null,
            'session' => $session,
        ]);
    }
}
