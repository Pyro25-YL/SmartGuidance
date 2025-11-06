{{-- resources/views/layouts/mobile.blade.php --}}
@props(['title' => 'Aplikasi Sekolah'])

<!doctype html>
<html lang="id">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover" />
    <meta name="theme-color" content="#F3F4F6" />
    <title>{{ $title }}</title>

    {{-- Vite (sesuaikan kalau kamu pakai Mix atau asset biasa) --}}
    @if (file_exists(public_path('build/manifest.json')))
        @vite(['resources/css/app.css', 'resources/js/app.js'])
    @else
        <link href="{{ asset('css/app.css') }}" rel="stylesheet">
    @endif

    <style>
        :root {
            --glass-blur: 10px;
            --glass-saturate: 1.18;
            --glass-shadow-color: rgba(12, 18, 40, 0.06);
            --glass-border: rgba(255, 255, 255, 0.65);
        }

        html,
        body {
            height: 100%;
            background: #edf0f3;
        }

        .phone-frame {
            max-width: 380px;
            margin: 0 auto;
            padding: env(safe-area-inset-top) 16px calc(env(safe-area-inset-bottom) + 96px) 16px;
            min-height: 100vh;
            box-sizing: border-box;
        }

        .glass {
            background: linear-gradient(30deg, rgba(255, 255, 255, 0.75), rgba(255, 255, 255, 0.55));
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            box-shadow: 0 8px 30px var(--glass-shadow-color);
            backdrop-filter: blur(var(--glass-blur)) saturate(var(--glass-saturate));
            -webkit-backdrop-filter: blur(var(--glass-blur)) saturate(var(--glass-saturate));
        }

        .glass-nav {
            background: linear-gradient(30deg, rgba(255, 255, 255, 0.92), rgba(250, 250, 255, 0.80));
            border: 1px solid rgba(255, 255, 255, 0.72);
            border-radius: 32px;
            padding: 10px;
            box-shadow: 0 6px 24px rgba(12, 18, 40, 0.06);
            backdrop-filter: blur(12px) saturate(1.15);
            -webkit-backdrop-filter: blur(12px) saturate(1.15);
        }

        .page-content {
            padding-bottom: 120px;
        }
    </style>
</head>

<body class="antialiased text-gray-900">
    <div class="phone-frame">
        <main class="page-content">
            {{ $slot }}
        </main>
    </div>
</body>

</html>
