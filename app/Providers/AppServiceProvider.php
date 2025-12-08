<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use App\Database\CoroutineAwareDatabaseManager;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        // Register coroutine-aware database manager
        $this->app->singleton('db', function ($app) {
            return new CoroutineAwareDatabaseManager($app, $app['db.factory']);
        });
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        //
    }
}
