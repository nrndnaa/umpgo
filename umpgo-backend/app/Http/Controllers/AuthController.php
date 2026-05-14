<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash; // 1. Added this import

class AuthController extends Controller
{
    private array $roleConfig = [
        'Student'           => ['table' => 'student',          'id' => 'studentID',   'user_col' => 'matricID'],
        'Lecturer'          => ['table' => 'lecturer',         'id' => 'lecturerID',  'user_col' => 'staffID'],
        'Faculty Registrar' => ['table' => 'facultyregistrar', 'id' => 'registrarID', 'user_col' => 'staffID'],
        'Treasury'          => ['table' => 'treasury',         'id' => 'treasuryID',  'user_col' => 'staffID'],
        'Pusat Adab'        => ['table' => 'pusatadab',        'id' => 'adabID',      'user_col' => 'staffID'],
    ];

    public function login(Request $request)
    {
        
        $request->validate([
            'username' => 'required|string',
            'password' => 'required|string',
            'role'     => 'required|string',
        ]);

        $role = $request->role;

        if (!isset($this->roleConfig[$role])) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid role.'
            ], 422);
        }

        $cfg     = $this->roleConfig[$role];
        $table   = $cfg['table'];
        $userCol = $cfg['user_col'];

        $user = DB::table($table)
            ->where($userCol, $request->username)
            ->first();

        // 2. Updated logic to use Hash::check
        // This compares the plain text input with the Bcrypt hash in the DB
        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Incorrect username or password.'
            ], 401);
        }

        // 3. Optional Security: Remove the password hash before sending user data to Flutter
        unset($user->password);

        return response()->json([
            'success' => true,
            'role'    => $role,
            'user'    => $user,
        ]);
    }
}
