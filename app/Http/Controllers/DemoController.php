<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Product;

class DemoController extends Controller
{
    public function index(Request $request)
    {
        // Pagination
        $perPage = 10;
        $items = Product::inRandomOrder()->paginate($perPage);

        //sleep(rand(5, 10));

        // Performance stats
        $stats = [
            'coroutines' => count(\Async\getCoroutines()),
            'memory_usage' => memory_get_usage(true),
            'memory_peak' => memory_get_peak_usage(true),
            'memory_usage_mb' => round(memory_get_usage(true) / 1024 / 1024, 2),
            'memory_peak_mb' => round(memory_get_peak_usage(true) / 1024 / 1024, 2),
        ];

        //sleep(rand(5, 10));

        // AJAX request - return only products
        if ($request->ajax()) {
            return view('partials.products', compact('items'));
        }

        return view('demo', compact('items', 'stats'));
    }
}
