<x-app-layout>
    <x-slot name="header">
        <div class="flex items-center justify-between">
            <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
                {{ __('Tambah Alamat Sekolah') }}
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

                    <form action="{{ route('alamat-sekolah.store') }}" method="POST" class="space-y-6">
                        @csrf

                        {{-- Pencarian alamat (autocomplete dari Nominatim) --}}
                        <div>
                            <label class="block text-sm font-medium mb-1">Cari Alamat (Nominatim OSM)</label>
                            <div class="flex gap-2">
                                <input id="searchBox" type="text" placeholder="Ketik nama sekolah / alamat..."
                                       class="w-full rounded-md border-gray-300 dark:bg-gray-900"
                                       autocomplete="off">
                                <button type="button" id="btnUseGPS"
                                        class="px-3 py-2 rounded-md bg-indigo-600 hover:bg-indigo-700 text-white text-sm">
                                    Pakai GPS Saya
                                </button>
                            </div>
                            <div id="suggestions"
                                 class="mt-2 border rounded-md max-h-56 overflow-auto hidden bg-white dark:bg-gray-900 border-gray-300 dark:border-gray-700">
                                <!-- item suggestion akan diisi via JS -->
                            </div>
                            <p class="text-xs text-gray-500 mt-1">
                                Sumber: OpenStreetMap Nominatim (gratis). Pilih salah satu saran untuk mengisi koordinat otomatis.
                            </p>
                        </div>

                            
                        <div>
                            <label class="block text-sm font-medium mb-1">Alamat (opsional)</label>
                            <input id="alamat" name="alamat" type="text"
                                   class="w-full rounded-md border-gray-300 dark:bg-gray-900"
                                   value="{{ old('alamat') }}">
                        </div> 

                        <div class="grid md:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium mb-1">Latitude</label>
                                <input id="latitude" name="latitude" type="number" step="0.0000001"
                                       class="w-full rounded-md border-gray-300 dark:bg-gray-900"
                                       value="{{ old('latitude') }}" required>
                            </div>
                            <div>
                                <label class="block text-sm font-medium mb-1">Longitude</label>
                                <input id="longitude" name="longitude" type="number" step="0.0000001"
                                       class="w-full rounded-md border-gray-300 dark:bg-gray-900"
                                       value="{{ old('longitude') }}" required>
                            </div>
                        </div>

                        <div>
                            <label class="block text-sm font-medium mb-1">Radius Jarak Absen (meter)</label>
                            <input id="radius" name="radius_jarak_absen" type="number" min="1" max="100000"
                                   class="w-full rounded-md border-gray-300 dark:bg-gray-900"
                                   value="{{ old('radius_jarak_absen', 150) }}" required>
                        </div>

                        <div class="pt-4">
                            <button type="submit"
                                    class="px-5 py-2.5 rounded-md bg-blue-600 hover:bg-blue-700 text-white font-medium">
                                Simpan
                            </button>
                        </div>
                    </form>

                    {{-- Preview kecil koordinat (opsional, tanpa peta) --}}
                    <div class="mt-8 text-sm text-gray-600 dark:text-gray-400" id="preview">
                        <span class="font-medium">Preview:</span>
                        <span id="previewText">Belum ada koordinat.</span>
                    </div>

                </div>
            </div>
        </div>
    </div>

    {{-- JS: Autocomplete Nominatim & GPS --}}
    <script>
        const searchBox = document.getElementById('searchBox');
        const suggestions = document.getElementById('suggestions');
        const latInput = document.getElementById('latitude');
        const lonInput = document.getElementById('longitude');
        const addrInput = document.getElementById('alamat'); // mungkin undefined jika field di-comment
        const previewText = document.getElementById('previewText');
        const btnUseGPS = document.getElementById('btnUseGPS');

        // Debounce helper
        function debounce(fn, delay=400) {
            let t; return (...args) => { clearTimeout(t); t = setTimeout(() => fn(...args), delay); };
        }

        // Render suggestion list
        function renderSuggestions(items) {
            suggestions.innerHTML = '';
            if (!items || !items.length) {
                suggestions.classList.add('hidden');
                return;
            }
            items.forEach(item => {
                const el = document.createElement('button');
                el.type = 'button';
                el.className = 'block w-full text-left px-3 py-2 hover:bg-gray-100 dark:hover:bg-gray-800';
                el.textContent = item.display_name;
                el.addEventListener('click', () => {
                    // isi input
                    latInput.value = item.lat;
                    lonInput.value = item.lon;
                    if (addrInput) addrInput.value = item.display_name;
                    searchBox.value = item.display_name;
                    previewText.textContent = `Lat: ${item.lat}, Lon: ${item.lon}`;
                    suggestions.classList.add('hidden');
                });
                suggestions.appendChild(el);
            });
            suggestions.classList.remove('hidden');
        }

        // Autocomplete via Nominatim
        const doSearch = debounce(async (q) => {
            if (!q || q.trim().length < 3) {
                suggestions.classList.add('hidden');
                return;
            }
            try {
                const url = new URL('https://nominatim.openstreetmap.org/search');
                url.searchParams.set('format', 'jsonv2');
                url.searchParams.set('q', q);
                url.searchParams.set('addressdetails', '1');
                url.searchParams.set('limit', '8');
                // Rec: tambahkan countrycodes biar lebih relevan (ID = Indonesia)
                url.searchParams.set('countrycodes', 'id');

                const res = await fetch(url.toString(), {
                    headers: {
                        // Browser tidak mengizinkan set User-Agent; referer halamanmu akan ikut otomatis.
                        'Accept-Language': 'id,en;q=0.8'
                    }
                });
                const data = await res.json();
                renderSuggestions(data);
            } catch (e) {
                console.error(e);
                suggestions.classList.add('hidden');
            }
        });

        searchBox.addEventListener('input', (e) => doSearch(e.target.value));
        document.addEventListener('click', (e) => {
            if (!suggestions.contains(e.target) && e.target !== searchBox) {
                suggestions.classList.add('hidden');
            }
        });

        // Pakai GPS saya
        btnUseGPS.addEventListener('click', async () => {
            if (!navigator.geolocation) {
                alert('Browser Anda tidak mendukung Geolocation.');
                return;
            }
            btnUseGPS.disabled = true;
            btnUseGPS.textContent = 'Mengambil lokasi...';
            navigator.geolocation.getCurrentPosition(async (pos) => {
                const { latitude, longitude } = pos.coords;
                latInput.value = latitude.toFixed(7);
                lonInput.value = longitude.toFixed(7);
                previewText.textContent = `Lat: ${latInput.value}, Lon: ${lonInput.value}`;

                // Reverse geocode untuk menampilkan alamat
                try {
                    const url = new URL('https://nominatim.openstreetmap.org/reverse');
                    url.searchParams.set('format', 'jsonv2');
                    url.searchParams.set('lat', latitude);
                    url.searchParams.set('lon', longitude);
                    url.searchParams.set('zoom', '18');
                    url.searchParams.set('addressdetails', '1');

                    const res = await fetch(url.toString(), {
                        headers: { 'Accept-Language': 'id,en;q=0.8' }
                    });
                    const data = await res.json();
                    const display = data?.display_name || '';
                    if (display) {
                        searchBox.value = display;
                        if (addrInput) addrInput.value = display;
                    }
                } catch (e) { console.error(e); }

                btnUseGPS.disabled = false;
                btnUseGPS.textContent = 'Pakai GPS Saya';
            }, (err) => {
                alert('Gagal mengambil lokasi: ' + err.message);
                btnUseGPS.disabled = false;
                btnUseGPS.textContent = 'Pakai GPS Saya';
            }, {
                enableHighAccuracy: true, timeout: 10000, maximumAge: 0
            });
        });
    </script>
</x-app-layout>
