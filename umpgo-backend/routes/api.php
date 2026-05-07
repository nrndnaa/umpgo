<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;  //Login Controller
use App\Http\Controllers\OpenRegistrationController;

Route::post('/login', [AuthController::class, 'login']);
Route::get('/registration-sessions', [OpenRegistrationController::class, 'index']);
Route::post('/registration-sessions', [OpenRegistrationController::class, 'store']);
Route::get('/registration-sessions/check', [OpenRegistrationController::class, 'check']);
