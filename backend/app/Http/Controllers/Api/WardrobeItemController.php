<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\WardrobeItem;
use App\Models\Outfit;
use Illuminate\Http\Request;

class WardrobeItemController extends Controller
{
    // Menampilkan semua item
    public function index(Request $request)
    {
        $items = WardrobeItem::where('user_id', $request->user()->id)
            ->with('outfit')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $items
        ]);
    }

    // Menambahkan item
    public function store(Request $request)
    {
        $validated = $request->validate([
            'outfit_id' => 'required|integer',
            'title' => 'required|string|max:255',
            'price' => 'nullable|numeric|min:0',
            'color' => 'nullable|string|max:100',
            'notes' => 'nullable|string',
            'image_url' => 'nullable|url|max:2048',
        ]);

        $outfit = Outfit::where('id', $validated['outfit_id'])
            ->where('user_id', $request->user()->id)
            ->firstOrFail();

        $item = WardrobeItem::create([
            ...$validated,
            'user_id' => $request->user()->id,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Item berhasil ditambahkan',
            'data' => $item
        ], 201);
    }

    // Menampilkan detail item
    public function show(Request $request, $id)
    {
        $item = WardrobeItem::where('user_id', $request->user()->id)
            ->with('outfit')
            ->findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $item
        ]);
    }

    // Mengedit item
    public function update(Request $request, $id)
    {
        $item = WardrobeItem::where('user_id', $request->user()->id)
            ->findOrFail($id);

        $validated = $request->validate([
            'outfit_id' => 'sometimes|required|integer',
            'title' => 'sometimes|required|string|max:255',
            'price' => 'nullable|numeric|min:0',
            'color' => 'nullable|string|max:100',
            'notes' => 'nullable|string',
            'image_url' => 'nullable|url|max:2048',
        ]);

        if (isset($validated['outfit_id'])) {
            Outfit::where('id', $validated['outfit_id'])
                ->where('user_id', $request->user()->id)
                ->firstOrFail();
        }

        $item->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Item berhasil diperbarui',
            'data' => $item
        ]);
    }

    // Menghapus item
    public function destroy(Request $request, $id)
    {
        $item = WardrobeItem::where('user_id', $request->user()->id)
            ->findOrFail($id);

        $item->delete();

        return response()->json([
            'success' => true,
            'message' => 'Item berhasil dihapus'
        ]);
    }
}