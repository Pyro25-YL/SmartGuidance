<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\AlamatSekolah;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class AlamatSekolahController extends Controller
{
    public function showCurrent(): JsonResponse
    {
        $alamat = AlamatSekolah::first();

        Log::info('API GET /alamat-sekolah => data:', [
            'data' => $alamat
        ]);

        return response()->json([
            'success' => true,
            'data'    => $alamat,
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        Log::info('API POST /alamat-sekolah => incoming data:', [
            'payload' => $request->all()
        ]);

        if (AlamatSekolah::exists()) {
            $alamat = AlamatSekolah::first();

            Log::warning('Alamat sudah ada, store diblokir.', [
                'existing' => $alamat
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Alamat sudah ada. Silakan gunakan endpoint update.',
                'data'    => $alamat,
            ], 409);
        }

        try {
            $validated = $request->validate([
                'latitude'           => ['required','numeric','between:-90,90'],
                'longitude'          => ['required','numeric','between:-180,180'],
                'radius_jarak_absen' => ['required','integer','min:1','max:100000'],
                'alamat'             => ['nullable','string','max:255'],
            ]);

            Log::info('Validasi berhasil:', $validated);

            $validated['singleton'] = 1;

            $alamat = AlamatSekolah::create($validated);

            Log::info('Alamat berhasil disimpan ke database:', [
                'saved' => $alamat
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Alamat sekolah berhasil dibuat.',
                'data'    => $alamat,
            ], 201);
        } catch (\Exception $e) {
            Log::error('Gagal menyimpan alamat sekolah:', [
                'error' => $e->getMessage()
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan saat menyimpan data.',
            ], 500);
        }
    }

    public function update(Request $request, int $id): JsonResponse
    {
        Log::info("API PUT /alamat-sekolah/$id => incoming data:", [
            'payload' => $request->all()
        ]);

        $alamat = AlamatSekolah::findOrFail($id);

        try {
            $validated = $request->validate([
                'latitude'           => ['required','numeric','between:-90,90'],
                'longitude'          => ['required','numeric','between:-180,180'],
                'radius_jarak_absen' => ['required','integer','min:1','max:100000'],
                'alamat'             => ['nullable','string','max:255'],
            ]);

            Log::info('Validasi update berhasil:', $validated);

            $alamat->update($validated);

            Log::info("Alamat ID $id berhasil diperbarui:", [
                'updated' => $alamat
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Alamat sekolah berhasil diperbarui.',
                'data'    => $alamat,
            ]);
        } catch (\Exception $e) {
            Log::error("Gagal update alamat sekolah ID $id:", [
                'error' => $e->getMessage(),
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Gagal memperbarui alamat sekolah.',
            ], 500);
        }
    }

    public function destroy(int $id): JsonResponse
    {
        Log::warning("API DELETE /alamat-sekolah/$id => request delete");

        $alamat = AlamatSekolah::findOrFail($id);
        $alamat->delete();

        Log::warning("Alamat sekolah ID $id berhasil dihapus");

        return response()->json([
            'success' => true,
            'message' => 'Alamat sekolah dihapus.',
        ]);
    }
}
