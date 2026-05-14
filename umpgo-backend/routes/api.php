<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\OpenRegistrationController;
use App\Http\Controllers\KoqController;

// routes/api.php
Route::post('/login', [AuthController::class, 'login']);
Route::get('/registration-sessions', [OpenRegistrationController::class, 'getSessions']);
Route::post('/registration-sessions', [OpenRegistrationController::class, 'createSession']);
Route::get('/registration-sessions/check', [OpenRegistrationController::class, 'checkOpenRegistrationStatus']); // ← must be before {id}
Route::get('/subjects', [OpenRegistrationController::class, 'getAllSubjects']);
Route::get('/sections/{sectionID}/students', [OpenRegistrationController::class, 'getSectionStudents']);
Route::get('/student-registration-status', [OpenRegistrationController::class, 'getStudentRegistrationStatus']);
Route::get('/approve-enrollment', [OpenRegistrationController::class, 'getEnrolledStudents']);
Route::get('/approve-enrollment/{studentID}', [OpenRegistrationController::class, 'getStudentEnrollments']);
Route::post('/approve-enrollment/{enrollmentID}/update-status', [OpenRegistrationController::class, 'updateEnrollmentStatus']);
Route::post('/approve-enrollment/{studentID}/update-all', [OpenRegistrationController::class, 'updateAllEnrollmentStatus']);
Route::get('/subjects-with-sections', [OpenRegistrationController::class, 'getSubjectsWithSections']);
Route::get('/my-enrollments/{studentID}', [OpenRegistrationController::class, 'getMyEnrollments']);
Route::post('/enroll', [OpenRegistrationController::class, 'registerSubject']);
Route::delete('/enroll/{enrollmentID}', [OpenRegistrationController::class, 'dropSubject']);
Route::get('/my-enrollments/{studentID}', [OpenRegistrationController::class, 'getMyEnrollments']);



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
