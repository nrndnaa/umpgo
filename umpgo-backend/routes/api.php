<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\OpenRegistrationController;

Route::get('/student/dashboard', [OpenRegistrationController::class, 'dashboard']);

use App\Http\Controllers\AuthController;
use App\Http\Controllers\AttendanceController;

Route::post('/login', [AuthController::class, 'login']);
Route::post('/attendance/session', [AttendanceController::class, 'createSession']);
Route::post('/attendance/checkin', [AttendanceController::class, 'checkIn']);

