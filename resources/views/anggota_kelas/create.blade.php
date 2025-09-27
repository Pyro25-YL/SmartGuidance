<x-app-layout>
    <x-slot name="header">
        <div class="flex items-center justify-between">
            <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
                {{ __('Tambah Anggota Kelas') }}
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

                    <form action="{{ route('anggota-kelas.store') }}" method="POST" class="space-y-6">
                        @csrf

                        <div>
                            <label class="block text-sm font-medium mb-1">Kelas</label>
                            <select name="kelas_id" class="w-full rounded-md border-gray-300 dark:bg-gray-900" required>
                                <option value="">-- Pilih Kelas --</option>
                                @foreach ($kelasList as $k)
                                    <option value="{{ $k->id }}" {{ old('kelas_id') == $k->id ? 'selected' : '' }}>
                                        {{ $k->nama_kelas }}
                                    </option>
                                @endforeach
                            </select>
                        </div>

                        <div>
                            <label class="block text-sm font-medium mb-1">Siswa (Role: Murid)</label>
                            <select name="siswa_id" class="w-full rounded-md border-gray-300 dark:bg-gray-900" required>
                                <option value="">-- Pilih Siswa --</option>
                                @foreach ($siswaList as $s)
                                    <option value="{{ $s->id }}" {{ old('siswa_id') == $s->id ? 'selected' : '' }}>
                                        {{ $s->name }} @if($s->nisn_nip) — {{ $s->nisn_nip }} @endif
                                    </option>
                                @endforeach
                            </select>
                            <p class="text-xs text-gray-500 mt-1">Dropdown ini hanya berisi user dengan role <b>murid</b>.</p>
                        </div>

                        <div>
                            <label class="block text-sm font-medium mb-1">Orang Tua / Wali (Opsional, Role: Wali Murid)</label>
                            <select name="ortu_id" class="w-full rounded-md border-gray-300 dark:bg-gray-900">
                                <option value="">-- (Opsional) Pilih Wali Murid --</option>
                                @foreach ($ortuList as $o)
                                    <option value="{{ $o->id }}" {{ old('ortu_id') == $o->id ? 'selected' : '' }}>
                                        {{ $o->name }} @if($o->nisn_nip) — {{ $o->nisn_nip }} @endif
                                    </option>
                                @endforeach
                            </select>
                            <p class="text-xs text-gray-500 mt-1">Kosongkan jika belum ingin mengaitkan wali murid.</p>
                        </div>

                        <div class="pt-4">
                            <button type="submit"
                                    class="px-5 py-2.5 rounded-md bg-blue-600 hover:bg-blue-700 text-white font-medium">
                                Simpan
                            </button>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </div>
</x-app-layout>
