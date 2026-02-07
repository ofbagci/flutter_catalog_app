# Flutter Catalog App

Flutter ile geliştirilmiş modern bir e-ticaret katalog uygulaması. Ürünler bir API'den çekilip ve sepet ile favori işlevselliğiyle birlikte temiz bir arayüzde sunuldu.

## Özellikler

- **Ürün Kataloğu** -- REST API'den çekilen ürünler 2 sütunlu grid düzeninde listelendi.
- **Arama** -- Ürünleri isme veya tagline'a göre anlık olarak filtreleyin.
- **Otomatik Kayan Banner** -- Ana ekranda döngüsel olarak kayan promosyon banner'ları oluşturuldu.
- **Ürün Detay** -- Açıklama, fiyat, teknik özellikler ve 1:1 ürün görseli ile birlikte favori butonu içeren detay sayfası tasarlandı.
- **Sepet** -- Detay sayfasından ürünleri sepete ekleyin, sepet ekranından kaldırın. Lokal state, network bağımlılığı yok.
- **Favoriler** -- Detay sayfasından favori ekleyin/çıkarın, favoriler ekranından yönetin. Lokal state, network bağımlılığı yok.
- **Hesabım** -- Kullanıcı bilgileri ve ayar seçenekleri içeren statik profil sayfası.

## Teknoloji ve Kısıtlamalar

- **Flutter** (Dart)
- Network istekleri için **http** paketi (tek harici bağımlılık)
- **3. parti state management yok** -- built-in `setState`, `FutureBuilder` ve `InheritedWidget` kullanıldı.
- **Performans odaklı** -- `const` constructor'lar, lazy rendering için `ListView.builder` / `GridView.builder`, tab state koruma için `IndexedStack`
- **Widget dönen metot yok** -- her UI parçası ayrı bir widget sınıfıdır.

## API

- **Endpoint:** `GET https://wantapi.com/products.php`
- **Response yapısı:**
```json
{
  "status": "",
  "meta": {},
  "data": [
    {
      "id": 1,
      "name": "iPhone 15 Pro",
      "tagline": "Titanium. So strong. So light. So Pro.",
      "description": "...",
      "price": "$999",
      "currency": "USD",
      "image": "https://wantapi.com/assets/images/iphone.png",
      "specs": {
        "chip": "A17 Pro",
        "material": "Titanium",
        "camera": "48MP Main"
      }
    }
  ]
}
```

## Proje Yapısı

Feature-based klasör mimarisi:

```
lib/
├── main.dart                              # Uygulama giriş noktası
├── app.dart                               # MaterialApp + AppStateWidget sarmalayıcı
├── core/
│   ├── constants/
│   │   └── api_constants.dart             # API URL sabitleri
│   ├── models/
│   │   └── product_model.dart             # Product veri modeli (fromJson)
│   └── services/
│       └── product_service.dart           # Ürün çekme HTTP servisi
├── features/
│   ├── home/
│   │   ├── home_page.dart                 # FutureBuilder ile ana ekran
│   │   └── widgets/
│   │       ├── home_search_bar.dart       # Arama TextField
│   │       ├── banner_slider.dart         # Otomatik kayan PageView banner
│   │       ├── product_grid.dart          # SliverGrid sarmalayıcı
│   │       └── product_grid_item.dart     # Grid içindeki ürün kartı
│   ├── product_detail/
│   │   ├── product_detail_page.dart       # Ürün detay ekranı
│   │   └── widgets/
│   │       ├── product_image_section.dart  # 1:1 görsel + favori butonu
│   │       └── add_to_cart_bottom_bar.dart # Sepete Ekle alt barı
│   ├── cart/
│   │   ├── cart_page.dart                 # Sepet ekranı
│   │   └── widgets/
│   │       └── cart_list_item.dart        # Sepet liste satır öğesi
│   ├── favorites/
│   │   ├── favorites_page.dart            # Favoriler ekranı
│   │   └── widgets/
│   │       └── favorite_list_item.dart    # Favori liste satır öğesi
│   └── account/
│       └── account_page.dart              # Hesabım ekranı (sadece UI)
└── shared/
    ├── state/
    │   └── app_state.dart                 # Sepet ve favoriler için InheritedWidget
    └── widgets/
        └── bottom_nav_shell.dart          # IndexedStack ile BottomNavigationBar
```

## Ekranlar

### Anasayfa
- "Discover" başlıklı AppBar ve Hesabım sayfasına yönlendiren ayarlar ikonu.
- Anlık filtreleme yapan arama çubuğu, dışına tıklayınca klavye kapanır.
- Otomatik kayan banner slider (3 banner, 3 saniyede bir döngü).
- Ürün grid'i (crossAxisCount: 2, spacing: 10, childAspectRatio: 0.7).

### Ürün Detay
- AppBar'da geri butonu ve ürün adı.
- 1:1 oran ürün görseli, sağ üstte favori toggle butonu (Stack ile).
- Ürün adı, tagline, açıklama, fiyat, para birimi ve teknik özellikler tablosu.
- Altta sabit fiyat gösterimi ve "Add to Cart" butonu.

### Sepetim
- 64x64 ürün görseli, isim, tagline, fiyat ve kaldır butonu ile sepet öğeleri.
- Sepet boşken boş durum görünümü.

### Favoriler
- 64x64 ürün görseli, isim, tagline, fiyat ve kaldır butonu ile favori öğeleri.
- Favori yokken boş durum görünümü.

### Hesabım
- Profil avatarı, isim ve e-posta.
- Bilgi bölümü (telefon, adres, doğum tarihi).
- Ayarlar listesi (bildirimler, tema, dil, gizlilik, hakkında).

## State Yönetimi

3. parti paket kullanmadan `InheritedWidget` pattern'i:

- **`AppStateWidget`** (StatefulWidget) widget ağacının en üstünde yer alır, sepet ve favori listelerini tutar.
- **`AppStateScope`** (InheritedWidget) state ve metotları (`addToCart`, `removeFromCart`, `toggleFavorite`, `isFavorite`, `isInCart`) tüm alt widget'lara `AppStateScope.of(context)` ile sunar.

## Başlangıç

```bash
# Bağımlılıkları yükle
flutter pub get

# Uygulamayı çalıştır
flutter run
```

Flutter SDK ^3.10.3 gerektirir.
