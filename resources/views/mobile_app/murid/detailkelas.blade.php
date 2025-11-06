{{-- resources/views/mobile_app/detail-kelas.blade.php --}}
<x-layout-mobile>
    <div class="pt-4 pb-28">
        {{-- Header --}}
        <div class="flex items-center gap-3 px-2">
            <a href="{{ url()->previous() }}" class="w-9 h-9 glass flex items-center justify-center rounded-xl">
                <img src="{{ asset('assets/icons/Return.svg') }}" alt="murid.Profile" class="w-4 h-4">
            </a>

            <h1 class="flex-1 text-center text-lg font-semibold text-blue-700">Detail Kelas</h1>

            <div class="w-9 h-9"></div>
        </div>

        {{-- Kartu ringkasan kelas --}}
        <div class="mt-4 px-2">
            <article class="relative overflow-hidden rounded-xl h-[100px] w-full p-4"
                style="background: linear-gradient(135deg,#E9D7FF,#EAD8FF);">
                <div class="flex flex-col h-full">
                    <div class="leading-tight">
                        <h3 class="text-[16px] font-bold text-gray-800">Bahasa Indonesia</h3>
                        <p class="text-[10px] font-light text-gray-600">Sekolah Dasar - Kelas 12</p>

                        {{-- Time + Date + Teacher with space-between --}}
                        <div class="flex items-center justify-between mt-0.5 w-full">
                            {{-- Time + Date container --}}
                            <div class="flex items-center gap-3">
                                {{-- Time --}}
                                <div class="flex items-center gap-1">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-gray-600"
                                        viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6">
                                        <path d="M12 7v5l3 3" stroke-linecap="round" stroke-linejoin="round" />
                                        <circle cx="12" cy="12" r="9" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg>
                                    <span class="text-[10px] font-normal text-gray-700">9:00 AM</span>
                                </div>

                                {{-- Date --}}
                                <div class="flex items-center gap-1">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-gray-600"
                                        viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6">
                                        <path d="M7 7h10M7 11h10M7 15h10" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg>
                                    <span class="text-[10px] font-normal text-gray-700">10 Okt 2025</span>
                                </div>
                            </div>

                            {{-- Teacher badge --}}
                            <div class="flex items-center gap-2 px-2 py-0.5 rounded-md text-white"
                                style="background: linear-gradient(135deg,#C9B6F5,#D4B8FF);">
                                <img src="https://i.pravatar.cc/28?u=teacher" alt="guru"
                                    class="w-6 h-6 rounded-full border border-white">
                                <div class="text-[9px] leading-tight">
                                    <div class="font-semibold">Ibu Tri Murti</div>
                                    <div class="text-[8px] opacity-80">Pengajar</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    {{-- Decorative --}}
                    <svg class="absolute right-3 top-3 w-36 h-36 opacity-20" viewBox="0 0 200 200"
                        xmlns="http://www.w3.org/2000/svg">
                        <rect x="50" y="5" width="120" height="120" rx="24" fill="#fff"
                            transform="rotate(20 110 65)"></rect>
                    </svg>
                </div>
            </article>
        </div>

        {{-- Deskripsi --}}
        <div class="mt-4 px-2">
            <h3 class="text-[12px] font-semibold text-gray-700">Tentang kelas ini</h3>
            <p class="text-[10px] font-reguler text-gray-600 mt-2">
                Kelas ini merupakan kelas bahasa indonesia yang diajar oleh Ibu Tri Murti, S.Pd, M.Pd dengan berfokus
                pada struktur kata.
            </p>
        </div>

        {{-- Absen section --}}
        <div class="mt-6 px-2">
            <h4 class="text-base font-bold text-blue-700">Absen</h4>

            <div class="mt-3">
                <div class="bg-blue-100 rounded-xl p-4">
                    <h5 class="text-sm font-semibold text-blue-800">Absen Mata Pelajaran</h5>
                    <p class="text-xs text-blue-700/80 mt-1">Pemantauan absen murid</p>

                    <a href="{{ route('murid.absen.form') }}"
                        class="mt-4 flex justify-center items-center px-6 py-2 rounded-full text-sm font-semibold bg-white text-blue-800 shadow"
                        style="box-shadow: 0 6px 18px rgba(0,0,0,0.06);">
                        Mulai
                    </a>

                </div>
            </div>
        </div>

        {{-- Materi section --}}
        <div class="mt-6 px-2">
            <h4 class="text-base font-semibold text-blue-600">Materi</h4>

            @php
                $materials = [
                    [
                        'title' => 'Materi SPOK dari KBBI',
                        'desc' => 'penjelasan SPOK menurut KBBI',
                        'duration' => '2 Jam',
                        'locked' => false,
                    ],
                    [
                        'title' => 'Materi SPOK dari KBBI',
                        'desc' => 'penjelasan SPOK menurut KBBI',
                        'duration' => '2 Jam',
                        'locked' => true,
                    ],
                    [
                        'title' => 'Materi SPOK dari KBBI',
                        'desc' => 'penjelasan SPOK menurut KBBI',
                        'duration' => '2 Jam',
                        'locked' => true,
                    ],
                    [
                        'title' => 'Materi SPOK dari KBBI',
                        'desc' => 'penjelasan SPOK menurut KBBI',
                        'duration' => '2 Jam',
                        'locked' => true,
                    ],
                ];
            @endphp

            <div class="mt-4 space-y-3">
                @foreach ($materials as $m)
                    <div class="flex items-start gap-3">
                        {{-- left icon --}}
                        <div
                            class="flex items-center justify-center w-12 h-12 rounded-2xl flex-shrink-0
                    @if (!$m['locked']) bg-blue-100 text-blue-600 @else bg-gray-100 text-gray-400 @endif">
                            @if (!$m['locked'])
                                <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none"
                                    viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" />
                                </svg>
                            @else
                                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none"
                                    viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                    <rect x="5" y="11" width="14" height="10" rx="2"
                                        stroke-linecap="round" stroke-linejoin="round" />
                                    <path d="M7 11V7a5 5 0 0110 0v4" stroke-linecap="round" stroke-linejoin="round" />
                                </svg>
                            @endif
                        </div>

                        {{-- right card --}}
                        <div
                            class="flex-1 rounded-2xl p-4
                    @if (!$m['locked']) bg-blue-50 @else bg-gray-50 @endif">

                            {{-- Title and Duration --}}
                            <div class="flex items-start justify-between gap-3 mb-2">
                                <h5
                                    class="text-sm font-semibold @if (!$m['locked']) text-blue-900 @else text-gray-700 @endif">
                                    {{ $m['title'] }}
                                </h5>

                                <div
                                    class="flex items-center gap-1 flex-shrink-0 @if (!$m['locked']) text-blue-600 @else text-gray-500 @endif">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none"
                                        viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8">
                                        <circle cx="12" cy="12" r="9" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                        <path d="M12 7v5l3 3" stroke-linecap="round" stroke-linejoin="round" />
                                    </svg>
                                    <span class="text-xs font-medium">{{ $m['duration'] }}</span>
                                </div>
                            </div>

                            {{-- Description --}}
                            <p
                                class="text-xs @if (!$m['locked']) text-blue-700 @else text-gray-600 @endif mb-3">
                                {{ $m['desc'] }}
                            </p>

                            {{-- Button --}}
                            @if (!$m['locked'])
                                <a href="#"
                                    class="inline-block px-5 py-1.5 rounded-full text-xs font-semibold bg-white text-blue-600 shadow-sm">
                                    Materi
                                </a>
                            @else
                                <button disabled
                                    class="inline-block px-5 py-1.5 rounded-full text-xs font-semibold bg-white text-gray-400 cursor-not-allowed">
                                    Materi
                                </button>
                            @endif
                        </div>
                    </div>
                @endforeach
            </div>
        </div>
    </div>


    {{-- Bottom navbar --}}
    @include('mobile_app.components.navbar')
</x-layout-mobile>
