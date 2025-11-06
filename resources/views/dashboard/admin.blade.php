<x-app-layout>
    <x-slot name="header">
        <div class="flex items-center justify-between">
            <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
                {{ __('Dashboard Admin') }}
            </h2>
            <!-- Tombol Add User -->
            <a href="{{ route('users.create') }}"
               class="inline-flex items-center px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium rounded-md shadow">
                + Add User
            </a>
            <a href="{{ route('kelas.create') }}"
               class="inline-flex items-center px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium rounded-md shadow">
                + Add kelas
            </a>
            <a href="{{ route('anggota-kelas.create') }}"
               class="inline-flex items-center px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium rounded-md shadow">
                + Add anggota kelas
            </a>
            <a href="{{ route('alamat-sekolah.create') }}"
               class="inline-flex items-center px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium rounded-md shadow">
                + Add Alamat Sekolah
            </a>
            <a href="{{ route('mapel.create') }}"
               class="inline-flex items-center px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium rounded-md shadow">
                + Add mapel
            </a>
            
        </div>
    </x-slot>

    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 text-gray-900 dark:text-gray-100">
                    {{ __("You're logged in!") }}
                    <p class="mt-4 text-gray-600">Halo, {{ Auth::user()->name }}</p>
                    <p class="mt-2">Anda bisa memantau Murid Anda.</p>                    
                </div>
            </div>
        </div>
    </div>
</x-app-layout>
