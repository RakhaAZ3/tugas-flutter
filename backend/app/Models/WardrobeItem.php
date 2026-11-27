<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class WardrobeItem extends Model
{
    protected $fillable = [
        'user_id',
        'outfit_id',
        'title',
        'price',
        'color',
        'notes',
        'image_url',
    ];

    // Item dimiliki oleh satu user
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    // Item masuk ke satu kategori outfit
    public function outfit(): BelongsTo
    {
        return $this->belongsTo(Outfit::class);
    }
}