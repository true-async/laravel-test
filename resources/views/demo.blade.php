<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laravel + TrueAsync PHP Demo</title>
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background: #fff;
            color: #333;
            line-height: 1.6;
        }

        /* Header в стиле PHP.net */
        header {
            background: #8892BF;
            color: white;
            padding: 0;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px 20px;
            display: flex;
            align-items: center;
            gap: 30px;
        }

        .logo-section {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .logo {
            width: 80px;
            height: 80px;
            background: white;
            border-radius: 8px;
            padding: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .logo img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .title-section h1 {
            font-size: 2em;
            font-weight: 400;
            margin-bottom: 5px;
        }

        .title-section p {
            font-size: 0.95em;
            opacity: 0.9;
        }

        .version-badge {
            background: rgba(255,255,255,0.2);
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.85em;
            margin-left: auto;
            white-space: nowrap;
        }

        /* Main content */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .intro {
            background: #f7f7f9;
            border-left: 4px solid #8892BF;
            padding: 20px 25px;
            margin-bottom: 40px;
            border-radius: 4px;
        }

        .intro h2 {
            color: #8892BF;
            font-size: 1.4em;
            font-weight: 500;
            margin-bottom: 10px;
        }

        .intro p {
            color: #666;
            font-size: 0.95em;
        }

        .stats {
            display: flex;
            gap: 20px;
            margin-top: 15px;
            flex-wrap: wrap;
        }

        .stat {
            background: white;
            padding: 8px 16px;
            border-radius: 4px;
            font-size: 0.9em;
            color: #555;
            border: 1px solid #e0e0e0;
        }

        .stat strong {
            color: #8892BF;
        }

        /* Performance Stats Block */
        .performance-stats {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 8px;
            margin-bottom: 40px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .performance-stats h3 {
            font-size: 1.3em;
            font-weight: 500;
            margin-bottom: 20px;
            border: none;
            color: white;
            padding: 0;
        }

        .perf-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .perf-item {
            background: rgba(255,255,255,0.15);
            padding: 15px 20px;
            border-radius: 6px;
            backdrop-filter: blur(10px);
        }

        .perf-label {
            font-size: 0.85em;
            opacity: 0.9;
            margin-bottom: 5px;
        }

        .perf-value {
            font-size: 1.8em;
            font-weight: 600;
            font-family: 'Courier New', monospace;
        }

        .perf-unit {
            font-size: 0.6em;
            opacity: 0.8;
            margin-left: 5px;
        }

        /* Products section */
        h3 {
            font-size: 1.5em;
            font-weight: 500;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #8892BF;
        }

        #products-container {
            position: relative;
        }

        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .product {
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 4px;
            padding: 20px;
            transition: box-shadow 0.2s;
        }

        .product:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            border-color: #8892BF;
        }

        .product-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 12px;
        }

        .product-id {
            background: #f0f0f0;
            color: #666;
            font-size: 0.85em;
            padding: 4px 10px;
            border-radius: 12px;
            font-weight: 600;
        }

        .product-name {
            font-size: 1.1em;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            flex: 1;
            padding-right: 10px;
        }

        .product-category {
            display: inline-block;
            background: #e8eaf6;
            color: #5c6bc0;
            font-size: 0.8em;
            padding: 4px 10px;
            border-radius: 3px;
            margin-bottom: 12px;
            font-weight: 500;
        }

        .product-price {
            font-size: 1.8em;
            color: #8892BF;
            font-weight: 600;
            margin: 12px 0;
        }

        .product-details {
            display: flex;
            justify-content: space-between;
            padding-top: 12px;
            border-top: 1px solid #f0f0f0;
            font-size: 0.9em;
            color: #666;
        }

        .stock {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .stock.low {
            color: #d32f2f;
        }

        .stock.high {
            color: #388e3c;
        }

        .rating {
            color: #ffa726;
            font-weight: 500;
        }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 5px;
            margin: 30px 0;
            flex-wrap: wrap;
        }

        .pagination a,
        .pagination span {
            display: inline-block;
            padding: 6px 12px;
            min-width: 36px;
            text-align: center;
            border: 1px solid #e0e0e0;
            border-radius: 3px;
            text-decoration: none;
            color: #8892BF;
            background: white;
            font-size: 0.9em;
            transition: all 0.2s;
        }

        .pagination a:hover {
            background: #8892BF;
            color: white;
            border-color: #8892BF;
        }

        .pagination span.active {
            background: #8892BF;
            color: white;
            border-color: #8892BF;
            font-weight: 600;
        }

        .pagination span.disabled {
            color: #ccc;
            cursor: not-allowed;
            background: #f5f5f5;
        }

        /* Loading spinner */
        .loading {
            opacity: 0.5;
            pointer-events: none;
            position: relative;
        }

        .loading::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 40px;
            height: 40px;
            margin: -20px 0 0 -20px;
            border: 4px solid #f3f3f3;
            border-top: 4px solid #8892BF;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Footer */
        footer {
            background: #f7f7f9;
            border-top: 1px solid #e0e0e0;
            padding: 30px 20px;
            margin-top: 40px;
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            text-align: center;
            color: #666;
            font-size: 0.9em;
        }

        .footer-content p {
            margin: 5px 0;
        }

        .footer-links {
            margin-top: 15px;
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        .footer-links a {
            color: #8892BF;
            text-decoration: none;
            font-weight: 500;
        }

        .footer-links a:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                text-align: center;
            }

            .version-badge {
                margin-left: 0;
                margin-top: 10px;
            }

            .title-section h1 {
                font-size: 1.5em;
            }

            .products-grid {
                grid-template-columns: 1fr;
            }

            .stats {
                flex-direction: column;
            }

            .perf-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <header>
        <div class="header-content">
            <div class="logo-section">
                <div class="logo">
                    <img src="https://avatars.githubusercontent.com/u/208614027?s=400&u=431cdf4a962a3e9675a00fb8ceedf542a62a08ef&v=4" alt="TrueAsync Logo">
                </div>
                <div class="title-section">
                    <h1>Laravel + TrueAsync PHP</h1>
                    <p>High-performance async application with coroutines</p>
                </div>
            </div>
            <div class="version-badge">
                PHP {{ PHP_VERSION }} • Laravel {{ app()->version() }}
            </div>
        </div>
    </header>

    <div class="container">
        <div class="intro">
            <h2>Hello World!</h2>
            <p>
                This demo showcases Laravel running on <strong>TrueAsync PHP</strong> with <strong>FrankenPHP</strong>.
                Each HTTP request is handled in its own coroutine, enabling true concurrency without blocking operations.
            </p>
            <div class="stats">
                <div class="stat"><strong>{{ $items->total() }}</strong> total products</div>
                <div class="stat"><strong>{{ $items->perPage() }}</strong> per page</div>
                <div class="stat"><strong>Fresh DB connection</strong> per request</div>
                <div class="stat"><strong>Async/Await</strong> enabled</div>
            </div>
        </div>

        <!-- Performance Stats -->
        <div class="performance-stats">
            <h3>⚡ Real-time Performance Metrics</h3>
            <div class="perf-grid">
                <div class="perf-item">
                    <div class="perf-label">Active Coroutines</div>
                    <div class="perf-value">
                        {{ $stats['coroutines'] }}
                        <span class="perf-unit">coroutines</span>
                    </div>
                </div>
                <div class="perf-item">
                    <div class="perf-label">Memory Usage</div>
                    <div class="perf-value">
                        {{ $stats['memory_usage_mb'] }}
                        <span class="perf-unit">MB</span>
                    </div>
                </div>
                <div class="perf-item">
                    <div class="perf-label">Peak Memory</div>
                    <div class="perf-value">
                        {{ $stats['memory_peak_mb'] }}
                        <span class="perf-unit">MB</span>
                    </div>
                </div>
            </div>
        </div>

        <h3>Product Catalog (Page {{ $items->currentPage() }} of {{ $items->lastPage() }})</h3>

        <div id="products-container">
            @include('partials.products')
        </div>
    </div>

    <footer>
        <div class="footer-content">
            <p><strong>Powered by TrueAsync PHP</strong></p>
            <p>Laravel Framework • FrankenPHP • Coroutine-based execution</p>
            <p style="margin-top: 10px; font-size: 0.85em; color: #999;">
                Each request creates a fresh application instance and database connection for complete isolation
            </p>
            <div class="footer-links">
                <a href="https://laravel.com" target="_blank">Laravel Documentation</a>
                <a href="https://github.com/true-async" target="_blank">TrueAsync GitHub</a>
            </div>
        </div>
    </footer>

    <script>
        // AJAX Pagination
        document.addEventListener('DOMContentLoaded', function() {
            document.addEventListener('click', function(e) {
                if (e.target.matches('.pagination a')) {
                    e.preventDefault();

                    const url = e.target.getAttribute('href');
                    const container = document.getElementById('products-container');

                    // Add loading state
                    container.classList.add('loading');

                    // Fetch new page
                    fetch(url, {
                        headers: {
                            'X-Requested-With': 'XMLHttpRequest',
                            'Accept': 'text/html'
                        }
                    })
                    .then(response => response.text())
                    .then(html => {
                        container.innerHTML = html;
                        container.classList.remove('loading');

                        // Scroll to top of products
                        container.scrollIntoView({ behavior: 'smooth', block: 'start' });

                        // Update URL without reload
                        window.history.pushState({}, '', url);
                    })
                    .catch(error => {
                        console.error('Error loading products:', error);
                        container.classList.remove('loading');
                    });
                }
            });
        });
    </script>
</body>
</html>
