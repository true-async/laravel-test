<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Product;

class ProductSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $categories = ['Electronics', 'Books', 'Clothing', 'Home & Garden', 'Sports'];
        $adjectives = ['Amazing', 'Premium', 'Deluxe', 'Professional', 'Modern', 'Classic', 'Vintage', 'Smart', 'Ultimate', 'Essential'];
        $nouns = ['Gadget', 'Device', 'Tool', 'Kit', 'Set', 'Bundle', 'Collection', 'System', 'Pack', 'Combo'];

        // Clear existing products
        Product::truncate();

        // Create 50 products
        for ($i = 1; $i <= 50; $i++) {
            Product::create([
                'name' => $adjectives[array_rand($adjectives)] . ' ' . $nouns[array_rand($nouns)] . ' #' . $i,
                'category' => $categories[array_rand($categories)],
                'price' => rand(1000, 99900) / 100, // 10.00 to 999.00
                'stock' => rand(0, 100),
                'rating' => rand(30, 50) / 10, // 3.0 to 5.0
            ]);
        }

        $this->command->info('Created 50 products successfully!');
    }
}
