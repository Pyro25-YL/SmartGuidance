<x-app-layout>
    <x-slot name="header">
        <div class="flex items-center justify-between">
            <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
                {{ __('Tambah Mata Pelajaran') }}
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

<form action="{{ route('mapel.store') }}" method="POST" class="space-y-6">
    @csrf

    <div>
        <label class="block text-sm font-medium mb-1">Nama Mapel</label>
        <input type="text" name="nama_mapel" value="{{ old('nama_mapel') }}"
               class="w-full rounded-md border-gray-300 dark:bg-gray-900" required>
    </div>

    <div>
        <label class="block text-sm font-medium mb-1">Kelas</label>
        <select name="kelas_id" class="w-full rounded-md border-gray-300 dark:bg-gray-900" required>
            <option value="">-- Pilih Kelas --</option>
            @foreach ($kelasList as $k)
                <option value="{{ $k->id }}" {{ old('kelas_id')==$k->id ? 'selected':'' }}>
                    {{ $k->nama_kelas }}
                </option>
            @endforeach
        </select>
    </div>

    {{-- === Tambahan Kolom Hari === --}}
    <div>
        <label class="block text-sm font-medium mb-1">Hari</label>
        <select name="hari" class="w-full rounded-md border-gray-300 dark:bg-gray-900" required>
            <option value="">-- Pilih Hari --</option>
            @php
                $hariList = ['Senin','Selasa','Rabu','Kamis','Jumat'];
            @endphp

            @foreach ($hariList as $h)
                <option value="{{ $h }}" {{ old('hari') == $h ? 'selected' : '' }}>
                    {{ $h }}
                </option>
            @endforeach
        </select>
    </div>
    {{-- === END Tambahan Hari === --}}

    <div class="grid md:grid-cols-2 gap-4">
        <div>
            <label class="block text-sm font-medium mb-1">Jam Mulai</label>
            <input type="time" name="jam_mulai" value="{{ old('jam_mulai') }}"
                   class="w-full rounded-md border-gray-300 dark:bg-gray-900" required>
        </div>
        <div>
            <label class="block text-sm font-medium mb-1">Jam Akhir</label>
            <input type="time" name="jam_akhir" value="{{ old('jam_akhir') }}"
                   class="w-full rounded-md border-gray-300 dark:bg-gray-900" required>
        </div>
    </div>

    <div>
        <label class="block text-sm font-medium mb-1">Guru Pengampu</label>
        <select name="guru_id" class="w-full rounded-md border-gray-300 dark:bg-gray-900" required>
            <option value="">-- Pilih Guru --</option>
            @foreach ($guruList as $g)
                <option value="{{ $g->id }}" {{ old('guru_id')==$g->id ? 'selected':'' }}>
                    {{ $g->name }}
                </option>
            @endforeach
        </select>
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
