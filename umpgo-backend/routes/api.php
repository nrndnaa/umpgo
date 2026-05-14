<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\TuitionFeeController;
use App\Http\Controllers\OpenRegistrationController;

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
