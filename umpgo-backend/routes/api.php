<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\OpenRegistrationController;

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
