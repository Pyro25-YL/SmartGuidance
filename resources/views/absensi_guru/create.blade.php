<x-app-layout>
    <x-slot name="header">
        <div class="flex items-center justify-between">
            <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
                {{ __('Absensi Guru - Tambah') }}
            </h2>
            <a href="{{ url()->previous() }}"
               class="inline-flex items-center px-3 py-2 rounded-md text-sm bg-gray-200 hover:bg-gray-300 dark:bg-gray-700 dark:hover:bg-gray-600">
                ← Kembali
            </a>
        </div>
    </x-slot>

    <div class="py-12">
        <div class="max-w-3xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 text-gray-900 dark:text-gray-100">

                    @if (session('status'))
                        <div class="mb-4 p-3 rounded bg-green-100 text-green-800">
                            {{ session('status') }}
                        </div>
                    @endif

                    @if ($errors->any())
                        <div class="mb-4 p-3 rounded bg-red-100 text-red-800">
                            <ul class="list-disc list-inside">
                                @foreach ($errors->all() as $error)
                                    <li>{{ $error }}</li>
                                @endforeach
                            </ul>
                        </div>
                    @endif
{{-- ... header dan flash message tetap ... --}}

<form action="{{ route('absensi-guru.store') }}" method="POST" class="space-y-6" enctype="multipart/form-data">
    @csrf

<div>
    <label class="block text-sm font-medium mb-1">Guru</label>
    <p class="p-2 bg-gray-100 dark:bg-gray-700 rounded">
        {{ Auth::user()->name }}
    </p>
</div>


    <div>
        <label class="block text-sm font-medium mb-1">Mapel</label>
        <select id="mapel_id" name="mapel_id" class="w-full rounded-md border-gray-300 dark:bg-gray-900" required>
            <option value="">-- Pilih Mapel --</option>
            @foreach ($mapelList as $m)
                <option value="{{ $m->id }}"
                        data-jmulai="{{ \Illuminate\Support\Str::of($m->jam_mulai)->substr(0,5) }}"
                        data-jakhir="{{ \Illuminate\Support\Str::of($m->jam_akhir)->substr(0,5) }}"
                        {{ old('mapel_id')==$m->id ? 'selected' : '' }}>
                    {{ $m->nama_mapel }} @if($m->kelas) ({{ $m->kelas->nama_kelas }}) @endif
                </option>
            @endforeach
        </select>
        <p id="jamInfo" class="text-xs text-gray-500 mt-1"></p>
    </div>

    {{-- Lokasi / Radius --}}
    <div>
        <label class="block text-sm font-medium mb-1">Lokasi Absen</label>
        <div class="flex gap-2">
            <button type="button" id="btnGPS"
                    class="px-3 py-2 rounded-md bg-indigo-600 hover:bg-indigo-700 text-white text-sm">
                Pakai GPS Saya
            </button>
            @if($alamat)
                <span class="text-sm text-gray-600 dark:text-gray-400">
                    Radius: <b>{{ $alamat->radius_jarak_absen }}</b> m
                </span>
            @else
                <span class="text-sm text-red-600">Alamat sekolah belum diset</span>
            @endif
        </div>
        <input type="hidden" id="lat" name="lat" value="{{ old('lat') }}">
        <input type="hidden" id="lon" name="lon" value="{{ old('lon') }}">
        <p id="lokasiInfo" class="text-xs text-gray-500 mt-1">Belum ada koordinat.</p>
    </div>

    <div class="grid md:grid-cols-2 gap-4">
        <div>
            <label class="block text-sm font-medium mb-1">Foto (opsional)</label>
            <input type="file" name="foto" accept="image/*"
                   class="w-full rounded-md border-gray-300 dark:bg-gray-900">
            <p class="text-xs text-gray-500 mt-1">Maks 3MB.</p>
        </div>
        <div>
            <label class="block text-sm font-medium mb-1">File Materi (opsional)</label>
            <input type="file" name="file_materi"
                   accept=".pdf,.doc,.docx,.ppt,.pptx,.zip,.rar"
                   class="w-full rounded-md border-gray-300 dark:bg-gray-900">
            <p class="text-xs text-gray-500 mt-1">PDF/DOC/PPT/ZIP/RAR, maks 10MB.</p>
        </div>
    </div>

    <div class="pt-4">
        <button type="submit"
                class="px-5 py-2.5 rounded-md bg-blue-600 hover:bg-blue-700 text-white font-medium">
            Simpan
        </button>
    </div>
</form>

{{-- Preview kecil --}}
<div class="mt-6 text-sm text-gray-600 dark:text-gray-400">
    <div id="previewJarak"></div>
</div>

{{-- ==== JS ==== --}}
<script>
    const btnGPS = document.getElementById('btnGPS');
    const latEl  = document.getElementById('lat');
    const lonEl  = document.getElementById('lon');
    const lokasiInfo = document.getElementById('lokasiInfo');
    const previewJarak = document.getElementById('previewJarak');
    const mapelSel = document.getElementById('mapel_id');
    const jamInfo = document.getElementById('jamInfo');

    // Data alamat sekolah dari server (jika ada)
    const sekolah = {
        lat: {{ $alamat->latitude ?? 'null' }},
        lon: {{ $alamat->longitude ?? 'null' }},
        radius: {{ $alamat->radius_jarak_absen ?? 'null' }},
    };

    // Tampilkan jam aktif mapel dipilih
    function updateJamInfo() {
        const opt = mapelSel.options[mapelSel.selectedIndex];
        const jm = opt?.dataset?.jmulai || '';
        const ja = opt?.dataset?.jakhir || '';
        jamInfo.textContent = (jm && ja) ? `Jam aktif: ${jm}–${ja} WIB` : '';
    }
    mapelSel.addEventListener('change', updateJamInfo);
    updateJamInfo();

    // Haversine (meter)
    function haversine(lat1, lon1, lat2, lon2) {
        const R = 6371000;
        const toRad = d => d * Math.PI / 180;
        const dLat = toRad(lat2 - lat1);
        const dLon = toRad(lon2 - lon1);
        const a = Math.sin(dLat/2)**2 +
                  Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) *
                  Math.sin(dLon/2)**2;
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        return R * c;
    }

    btnGPS?.addEventListener('click', () => {
        if (!navigator.geolocation) {
            alert('Browser tidak mendukung Geolocation.');
            return;
        }
        btnGPS.disabled = true; btnGPS.textContent = 'Mengambil lokasi...';
        navigator.geolocation.getCurrentPosition((pos) => {
            const lat = +pos.coords.latitude.toFixed(7);
            const lon = +pos.coords.longitude.toFixed(7);
            latEl.value = lat; lonEl.value = lon;
            lokasiInfo.textContent = `Koordinat: ${lat}, ${lon}`;

            if (sekolah.lat != null && sekolah.lon != null && sekolah.radius != null) {
                const d = Math.round(haversine(lat, lon, sekolah.lat, sekolah.lon));
                const status = d <= sekolah.radius ? '✅ Dalam radius' : '❌ Di luar radius';
                previewJarak.textContent = `Jarak ke sekolah ~ ${d} m (${status}, batas ${sekolah.radius} m)`;
            } else {
                previewJarak.textContent = '';
            }

            btnGPS.disabled = false; btnGPS.textContent = 'Pakai GPS Saya';
        }, (err) => {
            alert('Gagal mengambil lokasi: ' + err.message);
            btnGPS.disabled = false; btnGPS.textContent = 'Pakai GPS Saya';
        }, { enableHighAccuracy: true, timeout: 10000, maximumAge: 0 });
    });
</script>

</x-app-layout>
