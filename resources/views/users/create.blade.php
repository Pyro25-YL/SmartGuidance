<x-app-layout>
    <x-slot name="header">
        <div class="flex items-center justify-between">
            <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
                {{ __('Add User') }}
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

                    <form action="{{ route('users.store') }}" method="POST" enctype="multipart/form-data" class="space-y-6">
                        @csrf

                        <div>
                            <label class="block text-sm font-medium mb-1">Nama</label>
                            <input type="text" name="name" value="{{ old('name') }}" class="w-full rounded-md border-gray-300 dark:bg-gray-900" required>
                        </div>

                        <div>
                            <label class="block text-sm font-medium mb-1">NISN / NIP</label>
                            <input type="number" name="nisn_nip" value="{{ old('nisn_nip') }}" class="w-full rounded-md border-gray-300 dark:bg-gray-900" required>
                        </div>

                        <div>
                            <label class="block text-sm font-medium mb-1">Password</label>
                            <input type="password" name="password" class="w-full rounded-md border-gray-300 dark:bg-gray-900" required>
                        </div>

                        <div>
                            <label class="block text-sm font-medium mb-1">Role</label>
                            <select name="role" class="w-full rounded-md border-gray-300 dark:bg-gray-900" required>
                                <option value="">-- Pilih Role --</option>
                                <option value="admin" {{ old('role')=='admin'?'selected':'' }}>Admin</option>
                                <option value="guru" {{ old('role')=='guru'?'selected':'' }}>Guru</option>
                                <option value="murid" {{ old('role')=='murid'?'selected':'' }}>Murid</option>
                                <option value="wali_murid" {{ old('role')=='wali_murid'?'selected':'' }}>Wali Murid</option>
                            </select>
                        </div>

                        <div>
                            <label class="block text-sm font-medium mb-1">Jenis Kelamin</label>
                            <select name="jenis_kelamin" class="w-full rounded-md border-gray-300 dark:bg-gray-900">
                                <option value="">-- Pilih --</option>
                                <option value="L" {{ old('jenis_kelamin')=='L'?'selected':'' }}>Laki-laki</option>
                                <option value="P" {{ old('jenis_kelamin')=='P'?'selected':'' }}>Perempuan</option>
                            </select>
                        </div>

                        <div>
                            <label class="block text-sm font-medium mb-1">Foto (opsional)</label>
                            <input type="file" name="foto" accept="image/*" class="w-full rounded-md border-gray-300 dark:bg-gray-900">
                            <p class="text-xs text-gray-500 mt-1">Maks 100MB. Tipe gambar (jpg, png, webp, dll).</p>
                        </div>

                        <div class="pt-4">
                            <button type="submit" class="px-5 py-2.5 rounded-md bg-blue-600 hover:bg-blue-700 text-white font-medium">
                                Simpan
                            </button>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </div>
</x-app-layout>
