{{-- resources/views/mobile_app/list-kelas.blade.php --}}
<x-layout-mobile>
    <div class="pt-4 pb-28">
        {{-- HEADER --}}
        <div class="flex items-center gap-3 px-2">
            <a href="{{ url()->previous() }}" class="w-10 h-10 glass flex items-center justify-center rounded-lg">
                <!-- back icon -->
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-gray-700" fill="none" viewBox="0 0 24 24"
                    stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.6" d="M15 19l-7-7 7-7" />
                </svg>
            </a>
            <h1 class="flex-1 text-center text-lg font-bold text-blue-700">List Kelas</h1>
            <div class="w-10 h-10"></div>
        </div>

        {{-- SEARCH --}}
        <div class="mt-4 px-2">
            <div class="flex items-center bg-white rounded-full px-4 py-2 shadow-sm">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-gray-400" fill="none" viewBox="0 0 24 24"
                    stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.6"
                        d="M21 21l-4.35-4.35M11 19a8 8 0 100-16 8 8 0 000 16z" />
                </svg>
                <input type="text" placeholder="Cari Kelas..."
                    class="ml-2 w-full bg-transparent border-none focus:outline-none text-sm text-gray-700 placeholder-gray-400" />
            </div>
        </div>

        {{-- CARDS --}}
        <div class="mt-6 px-2 space-y-4">
            @php
                $cards = [
                    [
                        'title' => 'Bahasa Indonesia a',
                        'school' => 'SMKN 1 Benoyo',
                        'time' => '07:15 AM',
                        'date' => '10 Okt 2025',
                        'bg' => 'linear-gradient(135deg,#E9D7FF,#EAD8FF)',
                    ],
                    [
                        'title' => 'Pendidikan Pancasila',
                        'school' => 'SMKN 1 Benoyo',
                        'time' => '08:00 AM',
                        'date' => '10 Okt 2025',
                        'bg' => 'linear-gradient(135deg,#FFDCE6,#FFE6F0)',
                    ],
                    [
                        'title' => 'Matematika Dasar',
                        'school' => 'SMKN 1 Benoyo',
                        'time' => '09:30 AM',
                        'date' => '10 Okt 2025',
                        'bg' => 'linear-gradient(135deg,#D1E9FF,#E0F2FE)',
                    ],
                    [
                        'title' => 'Bahasa Inggris',
                        'school' => 'SMKN 1 Benoyo',
                        'time' => '10:15 AM',
                        'date' => '10 Okt 2025',
                        'bg' => 'linear-gradient(135deg,#FDE68A,#FECACA)',
                    ],
                ];
            @endphp

            @foreach ($cards as $c)
                <article class="relative overflow-hidden rounded-xl h-[168px] w-full p-5"
                    style="background: {{ $c['bg'] }};">
                    <div class="flex justify-between h-full">
                        <div class="max-w-[66%] flex flex-col justify-between">
                            <div>
                                <h3 class="text-[16px] font-bold text-gray-800">{{ $c['title'] }}</h3>
                                <p class="text-[10px] font-light text-gray-600 mt-1">{{ $c['school'] }}</p>
                            </div>

                            <div>
                                <div class="flex items-center gap-2">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-gray-600"
                                        viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6">
                                        <path d="M12 7v5l3 3" stroke-linecap="round" stroke-linejoin="round" />
                                        <circle cx="12" cy="12" r="9" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg>
                                    <span class="text-[8px] font-normal text-gray-700">{{ $c['time'] }}</span>
                                </div>
                                <div class="flex items-center gap-2 mt-1">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-gray-600"
                                        viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6">
                                        <path d="M7 7h10M7 11h10M7 15h10" stroke-linecap="round"
                                            stroke-linejoin="round" />
                                    </svg>
                                    <span class="text-[8px] font-normal text-gray-700">{{ $c['date'] }}</span>
                                </div>
                            </div>

                            <a href="{{ route('murid.kelasDetail') }}"
                                class="mt-3 inline-flex justify-center items-center px-5 py-1.5 rounded-full text-[12px] font-semibold text-orange-500 bg-white"
                                style="box-shadow: 0 6px 18px rgba(233,215,255,0.3);">
                                Mulai
                            </a>

                        </div>

                        {{-- Decorative --}}
                        <svg class="absolute right-3 top-3 w-36 h-36 opacity-20" viewBox="0 0 200 200"
                            xmlns="http://www.w3.org/2000/svg">
                            <rect x="50" y="5" width="120" height="120" rx="24" fill="#fff"
                                transform="rotate(20 110 65)"></rect>
                        </svg>
                    </div>
                </article>
            @endforeach
        </div>
    </div>

    {{-- Bottom navbar --}}
    @include('mobile_app.components.navbar')
</x-layout-mobile>
