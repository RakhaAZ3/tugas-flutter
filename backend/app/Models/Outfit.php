<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Outfit extends Model
{
    protected $fillable = [
        'user_id',
        'name',
    ];

    // Outfit dimiliki oleh satu user
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    // Satu outfit memiliki banyak item
    public function wardrobeItems(): HasMany
    {
        return $this->hasMany(WardrobeItem::class);
    }
}