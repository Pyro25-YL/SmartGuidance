{{-- resources/views/mobile_app/profil-pengguna.blade.php --}}
<x-layout-mobile>
    <div class="min-h-screen bg-gray-50 pb-28">
        {{-- Header --}}
        <div class="bg-white px-4 py-4 flex items-center gap-3 shadow-sm">
            <a href="javascript:history.back()" class="w-9 h-9 flex items-center justify-center">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 text-gray-700" fill="none" viewBox="0 0 24 24"
                    stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
                </svg>
            </a>
            <h1 class="flex-1 text-center text-lg font-semibold text-blue-600 pr-9">Profil Pengguna</h1>
        </div>

        <div class="px-4 pt-6 space-y-6">
            {{-- Profile Photo --}}
            <div class="flex justify-center">
                <div class="relative">
                    <img src="https://via.placeholder.com/120" alt="Profile Photo"
                        class="w-28 h-28 rounded-full object-cover border-4 border-white shadow-lg">
                    <button type="button"
                        class="absolute bottom-0 right-0 w-8 h-8 bg-blue-600 rounded-full flex items-center justify-center shadow-lg">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-white" fill="none"
                            viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round"
                                d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                        </svg>
                    </button>
                </div>
            </div>

            {{-- Nama Section --}}
            <div>
                <label class="text-xs font-semibold text-blue-400 uppercase tracking-wide mb-2 block">Nama</label>
                <div class="bg-white rounded-xl px-4 py-3 shadow-sm flex items-center gap-3">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-gray-400 flex-shrink-0" fill="none"
                        viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.6">
                        <path stroke-linecap="round" stroke-linejoin="round"
                            d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                    </svg>
                    <input disabled type="text" value="Fransiska Anggun Olivia"
                        class="flex-1 text-sm text-gray-700 bg-transparent focus:outline-none border-none"
                        placeholder="Nama Lengkap">
                </div>
            </div>

            {{-- Informasi Pribadi --}}
            <div>
                <label class="text-xs font-semibold text-blue-400 uppercase tracking-wide mb-2 block">Informasi
                    Pribadi</label>
                <div class="bg-white rounded-xl shadow-sm divide-y divide-gray-100">
                    {{-- NIK --}}
                    <div class="px-4 py-3 flex items-center gap-3">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-gray-400 flex-shrink-0"
                            fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.6">
                            <path stroke-linecap="round" stroke-linejoin="round"
                                d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                        </svg>
                        <input disabled type="text" value="350402130123O084"
                            class="flex-1 text-sm text-gray-700 bg-transparent focus:outline-none border-none"
                            placeholder="NIK anda ">
                    </div>

                    {{-- No Telepon --}}
                    <div class="px-4 py-3 flex items-center gap-3">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-gray-400 flex-shrink-0"
                            fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.6">
                            <path stroke-linecap="round" stroke-linejoin="round"
                                d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                        </svg>
                        <input disabled type="email" value="350402130123O084@siswa.smea.ac.id"
                            class="flex-1 text-sm text-gray-700 bg-transparent focus:outline-none border-none"
                            placeholder="No Telepon">
                    </div>

                    {{-- Alamat Orang Tua --}}
                    <div class="px-4 py-3 flex items-center gap-3">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-gray-400 flex-shrink-0"
                            fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.6">
                            <path stroke-linecap="round" stroke-linejoin="round"
                                d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
                        </svg>
                        <input disabled type="text" value="Joko Sembung Maem Dawet"
                            class="flex-1 text-sm text-gray-700 bg-transparent focus:outline-none border-none"
                            placeholder="Alamat Orang Tua">
                    </div>
                </div>
            </div>

            {{-- Informasi Orang Tua Section --}}
            <div>
                <label class="text-xs font-semibold text-blue-400 uppercase tracking-wide mb-2 block">Informasi Orang
                    Tua</label>
                <div class="bg-white rounded-xl shadow-sm divide-y divide-gray-100">
                    {{-- Nama Orang Tua --}}
                    <div class="px-4 py-3 flex items-center gap-3">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-gray-400 flex-shrink-0"
                            fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.6">
                            <path stroke-linecap="round" stroke-linejoin="round"
                                d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                        </svg>
                        <input disabled type="text" value="Joko Prayitno"
                            class="flex-1 text-sm text-gray-700 bg-transparent focus:outline-none border-none"
                            placeholder="Nama Orang Tua">
                    </div>

                    {{-- No Telepon --}}
                    <div class="px-4 py-3 flex items-center gap-3">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-gray-400 flex-shrink-0"
                            fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.6">
                            <path stroke-linecap="round" stroke-linejoin="round"
                                d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                        </svg>
                        <input disabled type="tel" value="089123456789"
                            class="flex-1 text-sm text-gray-700 bg-transparent focus:outline-none border-none"
                            placeholder="No Telepon">
                    </div>

                    {{-- Alamat Orang Tua --}}
                    <div class="px-4 py-3 flex items-center gap-3">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-gray-400 flex-shrink-0"
                            fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.6">
                            <path stroke-linecap="round" stroke-linejoin="round"
                                d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
                        </svg>
                        <input disabled type="text" value="Ds. Pucanglabon, Kec. Pacitan, Kab. Tulungagung ..."
                            class="flex-1 text-sm text-gray-700 bg-transparent focus:outline-none border-none"
                            placeholder="Alamat Orang Tua">
                    </div>
                </div>
            </div>

            {{-- Logout Button --}}
            <div class="pt-2">
                <button type="button"
                    class="w-full py-3 rounded-xl bg-white text-red-600 font-semibold shadow-sm border border-red-100 hover:bg-red-50 transition-colors">
                    Keluar
                </button>
            </div>
        </div>
    </div>

    {{-- Include Navbar --}}
    @include('mobile_app.components.navbar')
</x-layout-mobile>
