<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\OutfitController;
use App\Http\Controllers\Api\WardrobeItemController;

// Authentication
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {

    // User
    Route::get('/user', [AuthController::class, 'user']);
    Route::post('/logout', [AuthController::class, 'logout']);

    // CRUD Outfit
    Route::apiResource('outfits', OutfitController::class)
    ->except(['show']);

    Route::apiResource('wardrobe-items', WardrobeItemController::class)
    ->except(['show']);
});