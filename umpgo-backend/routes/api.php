<?php

use App\Http\Controllers\AuthController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\OpenRegistrationController;
use App\Http\Controllers\KoqController;
use App\Http\Controllers\AttendanceController;

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
Route::get('/modules/all', [KoqController::class, 'getAllModules']);
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


Route::post('/attendance/session', [AttendanceController::class, 'createSession']);
Route::post('/attendance/checkin', [AttendanceController::class, 'checkIn']);
<<<<<<< Updated upstream
=======
Route::get('/student/dashboard', [OpenRegistrationController::class, 'dashboard']);






// AUTH
Route::post('/login', [AuthController::class, 'login']);



// DUE DATE
Route::post('/set-due-date', [TuitionFeeController::class, 'setDueDate']);




// FEE RECORD
Route::post('/create-fee-record', [TuitionFeeController::class, 'createFeeRecord']);
Route::get('/fee-records', [TuitionFeeController::class, 'getFeeRecords']);



// PAYMENT
Route::post('/make-payment', [TuitionFeeController::class, 'makePayment']);
Route::get('/payments', [TuitionFeeController::class, 'getPayments']);

//TRY STUDENT_DETAIL
Route::get('/fee-record/{studentID}', [TuitionFeeController::class, 'getFeeRecord']);

Route::get(
    '/payment-history/{studentID}',
    [TuitionFeeController::class, 'getPaymentHistory']
);

Route::get(
    '/treasury/students',
    [TuitionFeeController::class, 'getStudentList']
);

// Attendance - Student
Route::post('/attendance/validate-code', [AttendanceController::class, 'validateCode']);
Route::post('/attendance/checkin', [AttendanceController::class, 'checkIn']);

// Attendance - Lecturer/Adab
Route::post('/attendance/session/create', [AttendanceController::class, 'createSession']);
Route::post('/attendance/session/end', [AttendanceController::class, 'endSession']);
Route::get('/attendance/session/active', [AttendanceController::class, 'getActiveSession']);
Route::get('/attendance/session/{sessionID}', [AttendanceController::class, 'getSessionDetail']);
Route::get('/attendance/sessions', [AttendanceController::class, 'getAllSessions']);
Route::post('/attendance/session/{sessionID}/edit', [AttendanceController::class, 'editAttendance']);

// Sections & Modules
Route::get('/lecturer/{lecturerID}/sections', [AttendanceController::class, 'getLecturerSections']);
Route::get('/student/{studentID}/sections', [AttendanceController::class, 'getStudentSections']);
Route::get('/adab/{adabID}/modules', [AttendanceController::class, 'getAdabModules']);
Route::get('/student/{studentID}/modules', [AttendanceController::class, 'getStudentModules']);

// Student enrollments (Nurin's)
Route::get('/students/{studentID}/enrollments', [OpenRegistrationController::class, 'getMyEnrollments']);
Route::get('/students/{studentID}/koq-bookings', [KoqController::class, 'getMyBookings']);
>>>>>>> Stashed changes
