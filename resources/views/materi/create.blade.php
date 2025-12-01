<x-app-layout>
    <x-slot name="header">
        <div class="flex items-center justify-between">
            <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
                {{ __('Input Materi Pembelajaran') }}
            </h2>
        </div>
    </x-slot>

    <div class="py-12">
        <div class="max-w-6xl mx-auto sm:px-6 lg:px-8">
            <div class="grid md:grid-cols-3 gap-6">

                {{-- Kolom kiri: list mapel hari ini --}}
                <div class="md:col-span-1">
                    <div class="bg-white dark:bg-gray-800 shadow-sm rounded-lg p-4">
                        <h3 class="font-semibold mb-3">Mapel Hari Ini</h3>

                        @if ($mapelHariIni->isEmpty())
                            <p class="text-sm text-gray-600 dark:text-gray-300">
                                Tidak ada jadwal mapel untuk hari ini.
                            </p>
                        @else
                            <ul class="space-y-2">
                                @foreach ($mapelHariIni as $m)
                                    <li>
                                        <a href="{{ route('materi.create', ['mapel_id' => $m->id]) }}"
                                           class="block px-3 py-2 rounded-md border border-gray-200 dark:border-gray-700
                                                  hover:bg-blue-50 dark:hover:bg-gray-700">
                                            <div class="font-medium">{{ $m->nama_mapel }}</div>
                                            <div class="text-xs text-gray-600 dark:text-gray-300">
                                                Kelas: {{ $m->kelas->nama_kelas ?? '-' }}<br>
                                                Jam: {{ $m->jam_mulai }} - {{ $m->jam_akhir }}
                                            </div>
                                        </a>
                                    </li>
                                @endforeach
                            </ul>
                        @endif
                    </div>
                </div>

                {{-- Kolom kanan: form input materi --}}
                <div class="md:col-span-2">
                    <div class="bg-white dark:bg-gray-800 shadow-sm rounded-lg p-6 text-gray-900 dark:text-gray-100">

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

                        @if ($selectedMapel)
                            <form action="{{ route('materi.store') }}" method="POST" class="space-y-5">
                                @csrf

                                <div>
                                    <label class="block text-sm font-medium mb-1">Mata Pelajaran</label>
                                    <input type="text"
                                           value="{{ $selectedMapel->nama_mapel }}"
                                           class="w-full rounded-md border-gray-300 dark:bg-gray-900"
                                           readonly>
                                    <input type="hidden" name="mapel_id" value="{{ $selectedMapel->id }}">
                                </div>

                                <div>
                                    <label class="block text-sm font-medium mb-1">Materi</label>
                                    <textarea name="materi" rows="6"
                                              class="w-full rounded-md border-gray-300 dark:bg-gray-900"
                                              placeholder="Tuliskan materi yang diajarkan hari ini...">{{ old('materi') }}</textarea>
                                </div>

                                <div>
                                    <button type="submit"
                                            class="px-5 py-2.5 rounded-md bg-blue-600 hover:bg-blue-700 text-white font-medium">
                                        Simpan Materi
                                    </button>
                                </div>
                            </form>
                        @else
                            <p class="text-sm text-gray-600 dark:text-gray-300">
                                Silakan pilih mapel di sebelah kiri terlebih dahulu.  
                                Jika belum mengisi absensi, Anda akan otomatis diarahkan ke halaman absensi guru.
                            </p>
                        @endif

                    </div>
                </div>

            </div>
        </div>
    </div>
</x-app-layout>
