{{-- resources/views/mobile_app/mail-inbox.blade.php --}}
<x-layout-mobile>
    <div class="pt-4 pb-28">
        {{-- Header --}}
        {{-- Header --}}
        <div class="flex items-center gap-3 px-2">
            <a href="{{ url()->previous() }}" class="w-9 h-9 glass flex items-center justify-center rounded-xl">
                <img src="{{ asset('assets/icons/Return.svg') }}" alt="murid.Profile" class="w-4 h-4">
            </a>

            <h1 class="flex-1 text-center text-lg font-semibold text-blue-700">Inbox Pesan</h1>

            <div class="w-9 h-9"></div>
        </div>

        {{-- Email List --}}
        <div class="px-4 pt-4 space-y-2">
            {{-- Email Item - Unread --}}
            {{-- <a href="{{ route('murid.detailed', 1) }}" --}}
            <a href="{{ route('murid.detailed') }}"
                class="block bg-white rounded-xl shadow-sm overflow-hidden active:bg-gray-50">
                <div class="p-4">
                    <div class="flex items-start gap-3">
                        {{-- Avatar --}}
                        <div class="w-10 h-10 rounded-full bg-blue-500 flex-shrink-0 flex items-center justify-center">
                            <span class="text-white font-semibold text-sm">JD</span>
                        </div>

                        {{-- Content --}}
                        <div class="flex-1 min-w-0">
                            <div class="flex items-start justify-between gap-2 mb-1">
                                <h3 class="text-sm font-bold text-gray-900 truncate">John Doe</h3>
                                <div class="flex items-center gap-1 flex-shrink-0">
                                    <span class="text-xs font-medium text-blue-600">10:30</span>
                                    <button type="button" class="p-1">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-gray-400"
                                            fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                            <path stroke-linecap="round" stroke-linejoin="round"
                                                d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z" />
                                        </svg>
                                    </button>
                                </div>
                            </div>
                            <p class="text-sm font-semibold text-gray-900 truncate mb-1">
                                Meeting Schedule Update
                            </p>
                            <p class="text-xs text-gray-600 line-clamp-2">
                                Hi, I wanted to update you about tomorrow's meeting. The time has been changed to 2
                                PM...
                            </p>
                        </div>
                    </div>
                    {{-- Unread Indicator --}}
                    <div class="absolute top-4 left-0 w-1 h-12 bg-blue-600 rounded-r-full"></div>
                </div>
            </a>

            {{-- Email Item - Read --}}
            {{-- <a href="{{ route('murid.detailed', 2) }}" --}}
            <a href="{{ route('murid.detailed') }}"
                class="block bg-white rounded-xl shadow-sm overflow-hidden active:bg-gray-50">
                <div class="p-4">
                    <div class="flex items-start gap-3">
                        {{-- Avatar --}}
                        <div class="w-10 h-10 rounded-full bg-green-500 flex-shrink-0 flex items-center justify-center">
                            <span class="text-white font-semibold text-sm">SA</span>
                        </div>

                        {{-- Content --}}
                        <div class="flex-1 min-w-0">
                            <div class="flex items-start justify-between gap-2 mb-1">
                                <h3 class="text-sm font-medium text-gray-700 truncate">Sarah Anderson</h3>
                                <div class="flex items-center gap-1 flex-shrink-0">
                                    <span class="text-xs text-gray-500">Kemarin</span>
                                    <button type="button" class="p-1">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-yellow-500"
                                            fill="currentColor" viewBox="0 0 24 24" stroke="currentColor"
                                            stroke-width="2">
                                            <path stroke-linecap="round" stroke-linejoin="round"
                                                d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z" />
                                        </svg>
                                    </button>
                                </div>
                            </div>
                            <p class="text-sm text-gray-700 truncate mb-1">
                                Project Documentation
                            </p>
                            <p class="text-xs text-gray-500 line-clamp-2">
                                Please find attached the latest project documentation. Let me know if you have any
                                questions.
                            </p>
                            {{-- Attachment Badge --}}
                            <div class="flex items-center gap-1 mt-2">
                                <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3 text-gray-400" fill="none"
                                    viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                    <path stroke-linecap="round" stroke-linejoin="round"
                                        d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
                                </svg>
                                <span class="text-xs text-gray-500">1 Lampiran</span>
                            </div>
                        </div>
                    </div>
                </div>
            </a>

            {{-- Email Item - Unread --}}
            {{-- <a href="{{ route('murid.detailed', 3) }}" --}}
            <a href="{{ route('murid.detailed') }}"
                class="block bg-white rounded-xl shadow-sm overflow-hidden active:bg-gray-50">
                <div class="p-4">
                    <div class="flex items-start gap-3">
                        {{-- Avatar --}}
                        <div
                            class="w-10 h-10 rounded-full bg-purple-500 flex-shrink-0 flex items-center justify-center">
                            <span class="text-white font-semibold text-sm">MK</span>
                        </div>

                        {{-- Content --}}
                        <div class="flex-1 min-w-0">
                            <div class="flex items-start justify-between gap-2 mb-1">
                                <h3 class="text-sm font-bold text-gray-900 truncate">Marketing Team</h3>
                                <div class="flex items-center gap-1 flex-shrink-0">
                                    <span class="text-xs font-medium text-blue-600">09:15</span>
                                    <button type="button" class="p-1">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-gray-400"
                                            fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                            <path stroke-linecap="round" stroke-linejoin="round"
                                                d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z" />
                                        </svg>
                                    </button>
                                </div>
                            </div>
                            <p class="text-sm font-semibold text-gray-900 truncate mb-1">
                                New Campaign Launch
                            </p>
                            <p class="text-xs text-gray-600 line-clamp-2">
                                Excited to announce our new marketing campaign starting next week. Check out the details
                                in the attachment...
                            </p>
                        </div>
                    </div>
                    {{-- Unread Indicator --}}
                    <div class="absolute top-4 left-0 w-1 h-12 bg-blue-600 rounded-r-full"></div>
                </div>
            </a>

            {{-- Email Item - Read --}}
            {{-- <a href="{{ route('murid.detailed', 4) }}" --}}
            <a href="{{ route('murid.detailed') }}"
                class="block bg-white rounded-xl shadow-sm overflow-hidden active:bg-gray-50">
                <div class="p-4">
                    <div class="flex items-start gap-3">
                        {{-- Avatar --}}
                        <div
                            class="w-10 h-10 rounded-full bg-orange-500 flex-shrink-0 flex items-center justify-center">
                            <span class="text-white font-semibold text-sm">HR</span>
                        </div>

                        {{-- Content --}}
                        <div class="flex-1 min-w-0">
                            <div class="flex items-start justify-between gap-2 mb-1">
                                <h3 class="text-sm font-medium text-gray-700 truncate">HR Department</h3>
                                <div class="flex items-center gap-1 flex-shrink-0">
                                    <span class="text-xs text-gray-500">2 hari lalu</span>
                                    <button type="button" class="p-1">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-gray-400"
                                            fill="none" viewBox="0 0 24 24" stroke="currentColor"
                                            stroke-width="2">
                                            <path stroke-linecap="round" stroke-linejoin="round"
                                                d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z" />
                                        </svg>
                                    </button>
                                </div>
                            </div>
                            <p class="text-sm text-gray-700 truncate mb-1">
                                Monthly Performance Review
                            </p>
                            <p class="text-xs text-gray-500 line-clamp-2">
                                Your monthly performance review is ready. Please check your dashboard for more details.
                            </p>
                        </div>
                    </div>
                </div>
            </a>
        </div>

        {{-- Floating Compose Button --}}
        <button type="button"
            class="fixed bottom-24 right-4 w-14 h-14 bg-blue-600 rounded-full shadow-lg flex items-center justify-center hover:bg-blue-700 transition-colors"
            style="box-shadow: 0 8px 20px rgba(37, 99, 235, 0.3);">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24"
                stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round"
                    d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
            </svg>
        </button>
    </div>


    {{-- Include Navbar --}}
    @include('mobile_app.components.navbar')
</x-layout-mobile>
