<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;  // ← add this
use App\Http\Controllers\KoqController;


Route::post('/login', [AuthController::class, 'login']);

// Module Routes
Route::get('/modules', [KoqController::class, 'getModules']);
Route::post('/modules', [KoqController::class, 'addModule']);
Route::put('/modules/{id}', [KoqController::class, 'updateModule']);
Route::delete('/modules/{id}', [KoqController::class, 'deleteModule']);

// Student Routes
Route::post('/modules/register', [KoqController::class, 'registerModule']);
Route::get('/modules/mybookings/{studentID}', [KoqController::class, 'getMyBookings']);
Route::get('/modules/enrollments/{moduleID}', [KoqController::class, 'getEnrollmentsByModule']);


// Student Credit Claim
Route::get('/creditclaim/cats/{studentID}', [KoqController::class, 'getStudentCats']);
Route::post('/creditclaim/submit', [KoqController::class, 'submitCreditClaim']);
Route::get('/creditclaim/student/{studentID}', [KoqController::class, 'getStudentClaim']);

// Pusat ADAB Credit Claim
Route::get('/creditclaim/all', [KoqController::class, 'getCreditClaims']);
Route::put('/creditclaim/{claimID}', [KoqController::class, 'updateClaimStatus']);

// Enrollment
Route::put('/enrollments/{modEnrollID}', [KoqController::class, 'updateEnrollment']);

// Dashboard
Route::get('/dashboard/stats', [KoqController::class, 'getDashboardStats']);

