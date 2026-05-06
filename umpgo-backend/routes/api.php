<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;  // ← add this

Route::post('/login', [AuthController::class, 'login']);