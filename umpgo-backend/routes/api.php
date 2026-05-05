<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\OpenRegistrationController;

Route::get('/student/dashboard', [OpenRegistrationController::class, 'dashboard']);
