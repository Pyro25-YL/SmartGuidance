<div class="fixed bottom-0 left-0 right-0 z-50">
    <div class="mx-auto max-w-md px-4">
        <div class="fixed bottom-3 left-1/2 -translate-x-1/2 z-50 w-[92%] max-w-md">
            <div class="mx-auto flex justify-center items-center p-1 mb-1"
                style="
                  background: rgba(255,255,255,0.36);
                  border-radius: 53px;
                  border: 1px solid #C2DEFF;
                  backdrop-filter: blur(10px) saturate(1.18);
                  -webkit-backdrop-filter: blur(10px) saturate(1.18);
                  box-shadow: 0 6px 20px rgba(12,18,40,0.06);
                ">
                <div class="flex items-center gap-7">

                    {{-- Kelas / Absen --}}
                    <a href="{{ route('kelas.create') }}" class="flex flex-col items-center justify-center text-center"
                        aria-current="{{ request()->routeIs('kelas.create') ? 'page' : 'false' }}">
                        <div class="flex items-center justify-center rounded-lg py-2 px-2"
                            style="min-width:40px; min-height:40px;">
                            @if (request()->routeIs('kelas.create'))
                                <img src="{{ asset('assets/icons/Library books-active.svg') }}" alt="Absen"
                                    class="w-7 h-7">
                            @else
                                <img src="{{ asset('assets/icons/Library books.svg') }}" alt="Absen" class="w-7 h-7">
                            @endif
                        </div>
                        <span
                            class="text-[10px] mt-0.5 {{ request()->routeIs('kelas.create') ? 'text-orange-500 font-semibold' : 'text-gray-600' }}"></span>
                    </a>

                    {{-- Home --}}
                    <a href="{{ route('kelas.create') ?? '#' }}"
                        class="flex flex-col items-center justify-center text-center"
                        aria-current="{{ request()->routeIs('kelas.create') ? 'page' : 'false' }}">
                        <div class="flex items-center justify-center rounded-lg py-2 px-2"
                            style="min-width:40px; min-height:40px;">
                            @if (request()->routeIs('kelas.create'))
                                <img src="{{ asset('assets/icons/Home-active.svg') }}" alt="Home" class="w-7 h-7">
                            @else
                                <img src="{{ asset('assets/icons/Home.svg') }}" alt="Home" class="w-7 h-7">
                            @endif
                        </div>
                        <span
                            class="text-[10px] mt-0.5 {{ request()->routeIs('kelas.create') ? 'text-orange-500 font-semibold' : 'text-gray-600' }}"></span>
                    </a>

                    {{-- Profile --}}
                    <a href="{{ route('kelas.create') ?? '#' }}"
                        class="flex flex-col items-center justify-center text-center"
                        aria-current="{{ request()->routeIs('kelas.create') ? 'page' : 'false' }}">
                        <div class="flex items-center justify-center rounded-lg py-2 px-2"
                            style="min-width:40px; min-height:40px;">
                            @if (request()->routeIs('kelas.create'))
                                <img src="{{ asset('assets/icons/Person-active.svg') }}" alt="kelas.create"
                                    class="w-7 h-7">
                            @else
                                <img src="{{ asset('assets/icons/Person.svg') }}" alt="kelas.create" class="w-7 h-7">
                            @endif
                        </div>
                        <span
                            class="text-[10px] mt-0.5 {{ request()->routeIs('kelas.create') ? 'text-orange-500 font-semibold' : 'text-gray-600' }}"></span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
