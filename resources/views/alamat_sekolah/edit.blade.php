{{-- resources/views/alamat_sekolah/edit.blade.php --}}
<x-app-layout>
    <x-slot name="header">
        <div class="flex items-center justify-between">
            <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
                {{ __('Edit Alamat Sekolah') }}
            </h2>

            <form action="{{ route('alamat-sekolah.destroy', $alamat->id) }}" method="POST"
                  onsubmit="return confirm('Hapus alamat sekolah?');">
                @csrf
                @method('DELETE')
                <button type="submit"
                        class="px-3 py-2 rounded-md bg-red-600 hover:bg-red-700 text-white text-sm">
                    Hapus
                </button>
            </form>
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

                    <form action="{{ route('alamat-sekolah.update', $alamat->id) }}"
                          method="POST" class="space-y-6">
                        @csrf
                        @method('PUT')

                        {{-- Autocomplete Nominatim + GPS --}}
                        <div>
                            <label class="block text-sm font-medium mb-1">Cari Alamat (Nominatim OSM)</label>
                            <div class="flex gap-2">
                                <input id="searchBox" type="text"
                                       placeholder="Ketik nama sekolah / alamat..."
                                       class="w-full rounded-md border-gray-300 dark:bg-gray-900"
                                       value=""
                                       autocomplete="off">
                                <button type="button" id="btnUseGPS"
                                        class="px-3 py-2 rounded-md bg-indigo-600 hover:bg-indigo-700 text-white text-sm">
                                    Pakai GPS Saya
                                </button>
                            </div>
                            <div id="suggestions"
                                 class="mt-2 border rounded-md max-h-56 overflow-auto hidden bg-white dark:bg-gray-900 border-gray-300 dark:border-gray-700"></div>
                            <p class="text-xs text-gray-500 mt-1">
                                Pilih salah satu saran untuk mengisi koordinat otomatis.
                            </p>
                        </div>

                        <div class="grid md:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium mb-1">Latitude</label>
                                <input id="latitude" name="latitude" type="number" step="0.0000001"
                                       class="w-full rounded-md border-gray-300 dark:bg-gray-900"
                                       value="{{ old('latitude', $alamat->latitude) }}" required>
                            </div>
                            <div>
                                <label class="block text-sm font-medium mb-1">Longitude</label>
                                <input id="longitude" name="longitude" type="number" step="0.0000001"
                                       class="w-full rounded-md border-gray-300 dark:bg-gray-900"
                                       value="{{ old('longitude', $alamat->longitude) }}" required>
                            </div>
                        </div>

                        <div>
                            <label class="block text-sm font-medium mb-1">Radius Jarak Absen (meter)</label>
                            <input id="radius" name="radius_jarak_absen" type="number" min="1" max="100000"
                                   class="w-full rounded-md border-gray-300 dark:bg-gray-900"
                                   value="{{ old('radius_jarak_absen', $alamat->radius_jarak_absen) }}" required>
                        </div>

                        <div class="pt-4 flex gap-2">
                            <a href="{{ route('alamat-sekolah.create') }}"
                               class="px-4 py-2 rounded-md bg-gray-200 hover:bg-gray-300 dark:bg-gray-700 dark:hover:bg-gray-600 text-sm">
                                ← Kembali
                            </a>
                            <button type="submit"
                                    class="px-5 py-2.5 rounded-md bg-blue-600 hover:bg-blue-700 text-white font-medium">
                                Simpan Perubahan
                            </button>
                        </div>
                    </form>

                    <div class="mt-8 text-sm text-gray-600 dark:text-gray-400" id="preview">
                        <span class="font-medium">Preview:</span>
                        <span id="previewText">
                            Lat: {{ $alamat->latitude }}, Lon: {{ $alamat->longitude }}
                        </span>
                    </div>

                </div>
            </div>
        </div>
    </div>

    {{-- JS: Autocomplete Nominatim + GPS --}}
    <script>
        const searchBox = document.getElementById('searchBox');
        const suggestions = document.getElementById('suggestions');
        const latInput = document.getElementById('latitude');
        const lonInput = document.getElementById('longitude');
        const previewText = document.getElementById('previewText');
        const btnUseGPS = document.getElementById('btnUseGPS');

        function debounce(fn, delay=400) {
            let t; return (...args) => { clearTimeout(t); t = setTimeout(() => fn(...args), delay); };
        }

        function renderSuggestions(items) {
            suggestions.innerHTML = '';
            if (!items || !items.length) { suggestions.classList.add('hidden'); return; }
            items.forEach(item => {
                const el = document.createElement('button');
                el.type = 'button';
                el.className = 'block w-full text-left px-3 py-2 hover:bg-gray-100 dark:hover:bg-gray-800';
                el.textContent = item.display_name;
                el.addEventListener('click', () => {
                    latInput.value = item.lat;
                    lonInput.value = item.lon;
                    previewText.textContent = `Lat: ${item.lat}, Lon: ${item.lon}`;
                    searchBox.value = item.display_name;
                    suggestions.classList.add('hidden');
                });
                suggestions.appendChild(el);
            });
            suggestions.classList.remove('hidden');
        }

        const doSearch = debounce(async (q) => {
            if (!q || q.trim().length < 3) { suggestions.classList.add('hidden'); return; }
            try {
                const url = new URL('https://nominatim.openstreetmap.org/search');
                url.searchParams.set('format', 'jsonv2');
                url.searchParams.set('q', q);
                url.searchParams.set('addressdetails', '1');
                url.searchParams.set('limit', '8');
                url.searchParams.set('countrycodes', 'id');
                const res = await fetch(url.toString(), { headers: { 'Accept-Language': 'id,en;q=0.8' } });
                renderSuggestions(await res.json());
            } catch { suggestions.classList.add('hidden'); }
        });

        searchBox?.addEventListener('input', (e) => doSearch(e.target.value));
        document.addEventListener('click', (e) => {
            if (!suggestions.contains(e.target) && e.target !== searchBox) suggestions.classList.add('hidden');
        });

        btnUseGPS?.addEventListener('click', async () => {
            if (!navigator.geolocation) return alert('Browser tidak mendukung Geolocation.');
            btnUseGPS.disabled = true; btnUseGPS.textContent = 'Mengambil lokasi...';
            navigator.geolocation.getCurrentPosition(async (pos) => {
                const { latitude, longitude } = pos.coords;
                latInput.value = latitude.toFixed(7);
                lonInput.value = longitude.toFixed(7);
                previewText.textContent = `Lat: ${latInput.value}, Lon: ${lonInput.value}`;

                try {
                    const url = new URL('https://nominatim.openstreetmap.org/reverse');
                    url.searchParams.set('format', 'jsonv2');
                    url.searchParams.set('lat', latitude);
                    url.searchParams.set('lon', longitude);
                    url.searchParams.set('zoom', '18');
                    url.searchParams.set('addressdetails', '1');
                    const res = await fetch(url.toString(), { headers: { 'Accept-Language': 'id,en;q=0.8' } });
                    const data = await res.json();
                    if (data?.display_name) searchBox.value = data.display_name;
                } catch {}
                btnUseGPS.disabled = false; btnUseGPS.textContent = 'Pakai GPS Saya';
            }, (err) => {
                alert('Gagal mengambil lokasi: ' + err.message);
                btnUseGPS.disabled = false; btnUseGPS.textContent = 'Pakai GPS Saya';
            }, { enableHighAccuracy: true, timeout: 10000, maximumAge: 0 });
        });
    </script>
</x-app-layout>
