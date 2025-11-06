{{-- resources/views/dashboard/mobile-blade.php --}}
<x-layout-mobile>
    <div class="pt-4 pb-28">
        {{-- Header --}}
        <div class="flex items-center gap-3 px-2">
            <a href="{{ url()->previous() }}" class="w-9 h-9 glass flex items-center justify-center rounded-full">
             
            </a>

            <h1 class="flex-1 text-center text-lg font-semibold text-blue-700">Detail Kelas</h1>

            <div class="w-9 h-9"></div>
        </div>


        @if (Auth::check())
            <div class="mt-6 px-2">
                <p class="text-sm text-gray-500">Halo,</p>
                <h1 class="text-2xl font-extrabold text-gray-800 leading-tight">
                    {{ Auth::user()->name }}
                </h1>
                <p class="text-sm text-gray-400 mt-1">Sudah siap kelas ?</p>
            </div>
        @else
            <div class="mt-6 px-2">
                <p class="text-sm text-gray-500">Halo,</p>
                <h1 class="text-2xl font-extrabold text-gray-800 leading-tight">
                    Tamu
                </h1>
                <p class="text-sm text-gray-400 mt-1">Sudah login ?</p>
            </div>
        @endif


        {{-- CONTROLS --}}
        <div class="mt-5 px-2 flex items-center gap-3">
            <div class="flex-1 flex items-center">
                {{-- Filter pill with dropdown --}}
                <div class="relative inline-block" x-data="{ open: false }">
                    {{-- Visible pill --}}
                    <div id="filter-pill" @click="open = !open"
                        class="inline-flex items-center gap-3 bg-white/60 px-3 py-2 rounded-[35px] shadow-sm cursor-pointer select-none border border-gray-200"
                        role="button" aria-haspopup="true" :aria-expanded="open.toString()" tabindex="0">

                        {{-- Left icon circle --}}
                        <div class="flex items-center justify-center w-6 h-6 rounded-full bg-gray-700">
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5 text-white" fill="none"
                                viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.6"
                                    d="M3 7h18M3 12h12M3 17h6" />
                            </svg>
                        </div>

                        {{-- Label --}}
                        <span id="filter-label" class="text-[10px] font-medium text-gray-700">Prioritas Murid</span>

                        {{-- Caret --}}
                        <svg xmlns="http://www.w3.org/2000/svg"
                            class="w-3.5 h-3.5 ml-1 text-gray-400 transform transition-transform"
                            :class="open ? 'rotate-180' : ''" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.6"
                                d="M19 9l-7 7-7-7" />
                        </svg>
                    </div>

                    {{-- Dropdown --}}
                    <div x-show="open" @click.outside="open = false"
                        class="absolute mt-2 left-0 w-48 bg-white rounded-xl shadow-lg border border-gray-100 z-50"
                        role="menu" aria-orientation="vertical" aria-labelledby="filter-pill">
                        <ul class="py-2">
                            <li>
                                <button type="button"
                                    class="w-full text-left px-4 py-2 text-[10px] font-medium text-gray-700 hover:bg-gray-50 focus:outline-none"
                                    data-value="prioritas" data-label="Prioritas Murid">
                                    Prioritas Murid
                                </button>
                            </li>
                            <li>
                                <button type="button"
                                    class="w-full text-left px-4 py-2 text-[10px] font-medium text-gray-700 hover:bg-gray-50 focus:outline-none"
                                    data-value="kelas" data-label="Kelas Murid">
                                    Kelas Murid
                                </button>
                            </li>
                        </ul>
                    </div>
                </div>

                {{-- Search button aligned right --}}
                <button class="w-10 h-10 glass flex items-center justify-center rounded-xl ml-auto">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-gray-700" fill="none"
                        viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.6"
                            d="M21 21l-4.35-4.35M11 19a8 8 0 100-16 8 8 0 000 16z" />
                    </svg>
                </button>
            </div>

        </div>

        {{-- SECTION TITLE --}}
        <div class="mt-6 px-2">
            <h2 class="text-[16px] font-bold text-gray-800">Prioritas Murid</h2>
        </div>

        {{-- TESTING DOANG  --}}
        @php
            $absensi = [
                [
                    'sekolah' => 'SMKN 1 Benoyo',
                    'jam' => '07:15 AM',
                    'tanggal' => '30 Sep 2025',
                ],
                [
                    'sekolah' => 'SMA Negeri 2 Surabaya',
                    'jam' => '07:25 AM',
                    'tanggal' => '29 Sep 2025',
                ],
                [
                    'sekolah' => 'SMP Negeri 1 Malang',
                    'jam' => '07:05 AM',
                    'tanggal' => '28 Sep 2025',
                ],
            ];
        @endphp

        {{-- CARD --}}
        <div class="mt-4 px-2 space-y-4">

            @php
                $backgrounds = [
                    'linear-gradient(135deg,#E9D7FF,#EAD8FF)',
                    'linear-gradient(135deg,#FFDCE6,#FFE6F0)',
                    'linear-gradient(135deg,#D1E9FF,#E0F2FE)',
                    'linear-gradient(135deg,#FDE68A,#FECACA)',
                ];
            @endphp

            @forelse($absensi as $index => $item)
                <article class="relative overflow-hidden rounded-xl h-[168px] w-full p-5"
                    style="background: {{ $backgrounds[$index % count($backgrounds)] }};">
                    <div class="flex justify-between h-full">
                        <div class="max-w-[66%] flex flex-col justify-between">
                            <div>
                                <h3 class="text-[16px] font-bold text-gray-800">Absen Datang Sekolah</h3>
                                <p class="text-[10px] font-light text-gray-600 mt-1">
                                    {{ $item->sekolah ?? 'SMKN 1 Benoyo' }}</p>
                            </div>

                            <div class="flex items-center gap-2">
                                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-gray-600"
                                    viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6">
                                    <path d="M12 7v5l3 3" stroke-linecap="round" stroke-linejoin="round" />
                                    <circle cx="12" cy="12" r="9" stroke-linecap="round"
                                        stroke-linejoin="round" />
                                </svg>
                                <span class="text-[8px] font-normal text-gray-700">{{ $item->jam ?? '9:00 AM' }}</span>
                            </div>

                            <div class="flex items-center gap-2">
                                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-gray-600"
                                    viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6">
                                    <path d="M7 7h10M7 11h10M7 15h10" stroke-linecap="round"
                                        stroke-linejoin="round" />
                                </svg>
                                <span
                                    class="text-[8px] font-normal text-gray-700">{{ $item->tanggal ?? '10 Okt 2025' }}</span>
                            </div>

                            <button
                                class="mt-3 inline-flex justify-center items-center px-5 py-1.5 rounded-full text-[12px] font-semibold text-orange-500 bg-white"
                                style="box-shadow: 0 6px 18px rgba(233,215,255,0.3);">
                                Mulai
                            </button>
                        </div>
                    </div>
                </article>
            @empty
                <article class="relative overflow-hidden rounded-[12px] h-[168px] w-full p-5"
                    style="background-image: url('/storage/bg-card.png'); 
               background-size: cover; 
               background-position: center;">
                </article>
            @endforelse


        </div>

    </div>

    {{-- bottom navbar (terpisah file) --}}
    @include('mobile_app.components.navbar')
</x-layout-mobile>
