{{-- resources/views/mobile_app/mailbox-detail.blade.php --}}
<x-layout-mobile>
    <div class="pt-4 pb-28">
        {{-- HEADER --}}
        <div class="flex items-center gap-3 px-4">
            <a href="{{ url()->previous() }}"
                class="w-10 h-10 bg-white flex items-center justify-center rounded-lg shadow-sm">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-gray-700" fill="none" viewBox="0 0 24 24"
                    stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.6" d="M15 19l-7-7 7-7" />
                </svg>
            </a>
            <h1 class="flex-1 text-center text-lg font-bold text-blue-700">Detail Mail</h1>
            <div class="w-10 h-10"></div>
        </div>

        {{-- MAIL HEADER CARD --}}
        <div class="mt-6 mx-4 relative overflow-hidden rounded-xl p-5"
            style="background: linear-gradient(135deg, #E9D7FF, #EAD8FF);">
            <div class="relative z-10">
                <h2 class="text-xl font-bold text-gray-800">Absen Datang Sekolah</h2>
                <p class="text-xs text-gray-600 mt-1">Sekolah Dasar - Kelas 12</p>

                <div class="flex items-center gap-4 mt-4">
                    <div class="flex items-center gap-2">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-gray-600" viewBox="0 0 24 24"
                            fill="none" stroke="currentColor" stroke-width="1.6">
                            <path d="M12 7v5l3 3" stroke-linecap="round" stroke-linejoin="round" />
                            <circle cx="12" cy="12" r="9" />
                        </svg>
                        <span class="text-[10px] text-gray-700">8:00 AM</span>
                    </div>

                    <div class="flex items-center gap-2">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-gray-600" viewBox="0 0 24 24"
                            fill="none" stroke="currentColor" stroke-width="1.6">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
                            <path d="M16 2v4M8 2v4M3 10h18" />
                        </svg>
                        <span class="text-[10px] text-gray-700">10 Okt 2025</span>
                    </div>
                </div>

                <div class="flex items-center gap-2 mt-4">
                    <div class="w-8 h-8 rounded-full overflow-hidden">
                        <img src="https://ui-avatars.com/api/?name=Ibu+Tri+Murti&background=7C3AED&color=fff"
                            alt="Sender" class="w-full h-full object-cover">
                    </div>
                    <span class="text-xs font-medium text-gray-700">Ibu Tri Murti</span>
                </div>
            </div>

            {{-- Decorative --}}
            <svg class="absolute right-3 top-3 w-36 h-36 opacity-20" viewBox="0 0 200 200"
                xmlns="http://www.w3.org/2000/svg">
                <rect x="50" y="5" width="120" height="120" rx="24" fill="#fff"
                    transform="rotate(20 110 65)"></rect>
            </svg>
        </div>

        {{-- CONTENT SECTION --}}
        <div class="mt-6 px-4">
            <h3 class="text-sm font-semibold text-gray-700">Tentang mail ini</h3>
            <p class="mt-2 text-sm text-gray-600 leading-relaxed">
                Mail ini merupakan pemberitahuan absen siswa yang tidak hadir pada hari ini. Siswa atas nama Budi
                Santoso tidak hadir pada tanggal 10 Oktober 2025. Mohon untuk segera melakukan tindak lanjut dengan
                menghubungi orang tua atau wali murid.
            </p>
        </div>

        {{-- ABSEN SECTION --}}
        <div class="mt-8 px-4">
            <h3 class="text-lg font-bold text-blue-700">Absen</h3>

            {{-- Absen Card --}}
            <div class="mt-4 bg-blue-50 rounded-xl p-4">
                <h4 class="text-sm font-bold text-blue-800">Absen Mata Pelajaran</h4>
                <p class="text-xs text-blue-600 mt-1">Pemantauan absen murid</p>

                <div
                    class="mt-3 inline-flex items-center px-4 py-1 rounded-full text-[10px] font-semibold text-yellow-600 bg-white">
                    Murid
                </div>
            </div>
        </div>

        {{-- MATERI SECTION --}}
        <div class="mt-8 px-4">
            <h3 class="text-lg font-bold text-blue-700">Materi</h3>

            {{-- Materi Items --}}
            <div class="mt-4 space-y-3">
                {{-- Materi 1 - Unlocked --}}
                <div class="bg-blue-50 rounded-xl p-4 flex items-start gap-3">
                    <div class="w-10 h-10 bg-blue-200 rounded-lg flex items-center justify-center flex-shrink-0">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-blue-600" viewBox="0 0 24 24"
                            fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M9 11l3 3L22 4" stroke-linecap="round" stroke-linejoin="round" />
                            <path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11" stroke-linecap="round"
                                stroke-linejoin="round" />
                        </svg>
                    </div>

                    <div class="flex-1">
                        <div class="flex items-start justify-between">
                            <div>
                                <h4 class="text-sm font-bold text-gray-800">Materi SPOK dari KBBI</h4>
                                <p class="text-[10px] text-gray-600 mt-1">penjelasan SPOK menurut KBBI</p>
                            </div>
                            <div class="flex items-center gap-1 text-[10px] text-gray-500">
                                <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3" viewBox="0 0 24 24"
                                    fill="none" stroke="currentColor" stroke-width="1.6">
                                    <path d="M12 7v5l3 3" stroke-linecap="round" stroke-linejoin="round" />
                                    <circle cx="12" cy="12" r="9" />
                                </svg>
                                <span>2 Jam</span>
                            </div>
                        </div>

                        <div
                            class="mt-2 inline-flex items-center px-3 py-1 rounded-full text-[10px] font-semibold text-blue-600 bg-white">
                            Materi
                        </div>
                    </div>
                </div>

                @php
                    $lockedMaterials = [
                        [
                            'title' => 'Materi SPOK dari KBBI',
                            'desc' => 'penjelasan SPOK menurut KBBI',
                            'time' => '2 Jam',
                        ],
                        [
                            'title' => 'Materi SPOK dari KBBI',
                            'desc' => 'penjelasan SPOK menurut KBBI',
                            'time' => '2 Jam',
                        ],
                        [
                            'title' => 'Materi SPOK dari KBBI',
                            'desc' => 'penjelasan SPOK menurut KBBI',
                            'time' => '2 Jam',
                        ],
                    ];
                @endphp

                @foreach ($lockedMaterials as $material)
                    {{-- Materi Locked --}}
                    <div class="bg-gray-50 rounded-xl p-4 flex items-start gap-3 opacity-60">
                        <div class="w-10 h-10 bg-gray-200 rounded-lg flex items-center justify-center flex-shrink-0">
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-gray-500" viewBox="0 0 24 24"
                                fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                                <path d="M7 11V7a5 5 0 0110 0v4" />
                            </svg>
                        </div>

                        <div class="flex-1">
                            <div class="flex items-start justify-between">
                                <div>
                                    <h4 class="text-sm font-bold text-gray-600">{{ $material['title'] }}</h4>
                                    <p class="text-[10px] text-gray-500 mt-1">{{ $material['desc'] }}</p>
                                </div>
                                <div class="flex items-center gap-1 text-[10px] text-gray-400">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="1.6">
                                        <path d="M12 7v5l3 3" stroke-linecap="round" stroke-linejoin="round" />
                                        <circle cx="12" cy="12" r="9" />
                                    </svg>
                                    <span>{{ $material['time'] }}</span>
                                </div>
                            </div>

                            <div
                                class="mt-2 inline-flex items-center px-3 py-1 rounded-full text-[10px] font-semibold text-gray-500 bg-white">
                                Materi
                            </div>
                        </div>
                    </div>
                @endforeach
            </div>
        </div>
    </div>

    {{-- Bottom navbar --}}
    @include('mobile_app.components.navbar')
</x-layout-mobile>
