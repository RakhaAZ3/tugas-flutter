<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class OutfitController extends Controller
{
    public function index(Request $request)
    {
        return response()->json(
            $request->user()->outfits()->withCount('wardrobeItems')->get()
        );
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => [
                'required',
                'string',
                'max:255',
                Rule::in(['Casual', 'Formal', 'Aksesoris']),
            ],
        ]);

        $outfit = $request->user()->outfits()->create($validated);

        return response()->json([
            'message' => 'Kategori berhasil dibuat',
            'data' => $outfit,
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $outfit = $request->user()->outfits()->findOrFail($id);

        $validated = $request->validate([
            'name' => [
                'required',
                'string',
                'max:255',
                Rule::in(['Casual', 'Formal', 'Aksesoris']),
            ],
        ]);

        $outfit->update($validated);

        return response()->json([
            'message' => 'Kategori berhasil diperbarui',
            'data' => $outfit,
        ]);
    }

    public function destroy(Request $request, $id)
    {
        $outfit = $request->user()->outfits()->findOrFail($id);

        $outfit->delete();

        return response()->json([
            'message' => 'Kategori berhasil dihapus',
        ]);
    }
}
