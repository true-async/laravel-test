<div class="products-grid">
    @foreach($items as $item)
    <div class="product">
        <div class="product-header">
            <div class="product-name">{{ $item->name }}</div>
            <div class="product-id">#{{ $item->id }}</div>
        </div>
        <div class="product-category">{{ $item->category }}</div>
        <div class="product-price">${{ number_format($item->price, 2) }}</div>
        <div class="product-details">
            <div class="stock {{ $item->stock < 20 ? 'low' : ($item->stock > 70 ? 'high' : '') }}">
                <span>📦</span>
                <span>{{ $item->stock }} in stock</span>
            </div>
            <div class="rating">★ {{ number_format($item->rating, 1) }}</div>
        </div>
    </div>
    @endforeach
</div>

<div class="pagination">
    @if ($items->onFirstPage())
        <span class="disabled">← Previous</span>
    @else
        <a href="{{ $items->previousPageUrl() }}">← Previous</a>
    @endif

    @foreach(range(1, $items->lastPage()) as $page)
        @if($page == $items->currentPage())
            <span class="active">{{ $page }}</span>
        @else
            <a href="{{ $items->url($page) }}">{{ $page }}</a>
        @endif
    @endforeach

    @if ($items->hasMorePages())
        <a href="{{ $items->nextPageUrl() }}">Next →</a>
    @else
        <span class="disabled">Next →</span>
    @endif
</div>
