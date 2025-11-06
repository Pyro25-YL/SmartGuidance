{{-- resources/views/mobile_app/form-absen.blade.php --}}
<x-layout-mobile>
    <div class="pt-4 pb-28 px-2">
        {{-- Header --}}
        <div class="flex items-center gap-3">
            <a href="javascript:history.back()" class="w-9 h-9 glass flex items-center justify-center rounded-xl">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-gray-700" fill="none" viewBox="0 0 24 24"
                    stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.6" d="M15 19l-7-7 7-7" />
                </svg>
            </a>

            <h1 class="flex-1 text-center text-lg font-semibold text-blue-700">Form Absen Kelas</h1>

            <div class="w-9 h-9"></div>
        </div>

        {{-- <form action="{{ route('absen.store') }}" method="POST" enctype="multipart/form-data" class="mt-6 space-y-5"> --}}
        <form method="POST" enctype="multipart/form-data" class="mt-6 space-y-5">
            @csrf

            {{-- Lokasi saat ini --}}
            <div>
                <label class="text-sm font-medium text-blue-700">Lokasi saat ini <span
                        class="text-red-500">*</span></label>
                <div class="mt-2">
                    <button type="button" id="btn-locate"
                        class="w-full bg-white rounded-xl px-4 py-3 shadow-sm flex items-center gap-3 transition-colors duration-200 hover:bg-blue-50">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 flex-shrink-0" id="location-icon"
                            fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.6">
                            <path stroke-linecap="round" stroke-linejoin="round"
                                d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                            <path stroke-linecap="round" stroke-linejoin="round" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                        </svg>
                        <span id="location-text" class="flex-1 text-left text-sm text-gray-600">Klik untuk mendapatkan
                            lokasi anda</span>
                        <input id="location" name="location" type="hidden" />
                    </button>
                </div>
            </div>

            {{-- Upload bukti kehadiran --}}
            <div>
                <label class="text-sm font-medium text-blue-700">Upload bukti kehadiran <span
                        class="text-red-500">*</span></label>
                <div class="mt-2">
                    <label
                        class="flex items-center gap-3 bg-white rounded-xl px-4 py-3 shadow-sm cursor-pointer hover:bg-gray-50 transition-colors">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-gray-400 flex-shrink-0"
                            viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6">
                            <path d="M12 3v12" stroke-linecap="round" stroke-linejoin="round" />
                            <path d="M8 7l4-4 4 4" stroke-linecap="round" stroke-linejoin="round" />
                            <path d="M21 21H3" stroke-linecap="round" stroke-linejoin="round" />
                        </svg>
                        <span id="bukti-name" class="text-sm text-gray-600">Unggah bukti kehadiran</span>
                        <input id="bukti" name="bukti" type="file" accept="image/*,application/pdf"
                            class="hidden" />
                    </label>
                </div>
            </div>

            {{-- Keterangan Hadir --}}
            <div x-data="{
                open: false,
                selectedValue: 'hadir',
                selectedLabel: 'Hadir'
            }" class="relative">
                <label class="text-sm font-medium text-blue-700">
                    Keterangan Hadir <span class="text-red-500">*</span>
                </label>
                <div class="mt-2">
                    {{-- Selected Value Display --}}
                    <button type="button" @click="open = !open"
                        class="w-full bg-white rounded-xl px-4 py-3 text-sm shadow-sm border border-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-200 text-left flex items-center justify-between">
                        <span x-text="selectedLabel"></span>
                        <svg class="w-4 h-4 text-gray-400 transition-transform" :class="{ 'rotate-180': open }"
                            fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7">
                            </path>
                        </svg>
                    </button>

                    {{-- Hidden Input --}}
                    <input type="hidden" name="keterangan" x-model="selectedValue">

                    {{-- Dropdown --}}
                    <div x-show="open" @click.outside="open = false" x-cloak
                        class="absolute mt-2 left-0 w-full bg-white rounded-xl shadow-lg border border-gray-100 z-50"
                        role="menu" aria-orientation="vertical" x-transition>
                        <ul class="py-2">
                            <li>
                                <button type="button"
                                    @click="selectedValue = 'hadir'; selectedLabel = 'Hadir'; open = false"
                                    class="w-full text-left px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none">
                                    Hadir
                                </button>
                            </li>
                            <li>
                                <button type="button"
                                    @click="selectedValue = 'izin'; selectedLabel = 'Izin'; open = false"
                                    class="w-full text-left px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none">
                                    Izin
                                </button>
                            </li>
                            <li>
                                <button type="button"
                                    @click="selectedValue = 'sakit'; selectedLabel = 'Sakit'; open = false"
                                    class="w-full text-left px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none">
                                    Sakit
                                </button>
                            </li>
                            <li>
                                <button type="button"
                                    @click="selectedValue = 'alfa'; selectedLabel = 'Alfa'; open = false"
                                    class="w-full text-left px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none">
                                    Alfa
                                </button>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

            {{-- Surat Izin --}}
            <div>
                <label class="text-sm font-medium text-blue-700">Surat Izin</label>
                <div class="mt-2">
                    <label
                        class="flex items-center gap-3 bg-white rounded-xl px-4 py-3 shadow-sm cursor-pointer hover:bg-gray-50 transition-colors">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-gray-400 flex-shrink-0"
                            viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6">
                            <path d="M3 7h18" stroke-linecap="round" stroke-linejoin="round" />
                            <path d="M8 21h8" stroke-linecap="round" stroke-linejoin="round" />
                        </svg>
                        <span id="izin-name" class="text-sm text-gray-600">Unggah Surat Izin</span>
                        <input id="izin" name="izin" type="file" accept="image/*,application/pdf"
                            class="hidden" />
                    </label>
                </div>
            </div>

            {{-- Submit --}}
            <div class="mt-4">
                <button type="submit" class="w-full py-3 rounded-xl bg-white text-blue-700 font-semibold shadow"
                    style="box-shadow: 0 8px 20px rgba(59,130,246,0.12);">
                    Unggah File
                </button>
            </div>
        </form>
    </div>

    {{-- include navbar jika perlu --}}
    @include('mobile_app.components.navbar')

    {{-- small inline JS untuk interaksi kecil (lokasi & file name) --}}
    <script>
        // lokasi (simple navigator geolocation; permission modal browser)
        document.getElementById('btn-locate')?.addEventListener('click', function() {
            if (!navigator.geolocation) {
                alert('Geolocation tidak tersedia di browser ini.');
                return;
            }

            const btnLocate = this;
            const locationText = document.getElementById('location-text');
            const locationIcon = document.getElementById('location-icon');

            // Change to loading state
            btnLocate.classList.add('bg-blue-50');
            locationText.textContent = 'Mencari lokasi...';
            locationIcon.classList.add('text-blue-600', 'animate-pulse');

            navigator.geolocation.getCurrentPosition((pos) => {
                const lat = pos.coords.latitude.toFixed(6);
                const lon = pos.coords.longitude.toFixed(6);

                document.getElementById('location').value = lat + ', ' + lon;

                // Change to success state
                btnLocate.classList.remove('bg-blue-50');
                btnLocate.classList.add('bg-blue-500');
                locationText.classList.remove('text-gray-600');
                locationText.classList.add('text-white', 'font-medium');
                locationText.textContent = lat + ', ' + lon;
                locationIcon.classList.remove('text-gray-400', 'animate-pulse');
                locationIcon.classList.add('text-white');
            }, (err) => {
                alert('Gagal mendapatkan lokasi: ' + (err.message || 'permission denied'));

                // Reset to initial state
                btnLocate.classList.remove('bg-blue-50');
                locationText.textContent = 'Klik untuk mendapatkan lokasi anda';
                locationIcon.classList.remove('text-blue-600', 'animate-pulse');
            }, {
                enableHighAccuracy: true,
                timeout: 10000
            });
        });

        // show selected file name
        const buktiInput = document.getElementById('bukti');
        const buktiName = document.getElementById('bukti-name');
        buktiInput?.addEventListener('change', function() {
            if (this.files && this.files.length > 0) {
                buktiName.textContent = this.files[0].name;
            } else {
                buktiName.textContent = 'Unggah bukti kehadiran';
            }
        });

        const izinInput = document.getElementById('izin');
        const izinName = document.getElementById('izin-name');
        izinInput?.addEventListener('change', function() {
            if (this.files && this.files.length > 0) {
                izinName.textContent = this.files[0].name;
            } else {
                izinName.textContent = 'Unggah Surat Izin';
            }
        });
    </script>
</x-layout-mobile>
3
