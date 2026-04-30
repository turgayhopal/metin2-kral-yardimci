# ⚔️ Metin2 Kral Yardımcısı

Metin2 **Kralı Yakala** etkinliği için geliştirilmiş, 5x5 tahta üzerinde kart takibi ve tahmin yardımcısı uygulaması.

🌐 **Canlı Demo:** [metin2-kral-yardimci.web.app](https://metin2-kral-yardimci.web.app)

---

## 📱 Ekran Görüntüleri

> Android, iOS ve Web platformlarında çalışır.

---

## 🎮 Oyun Hakkında

Metin2'nin yıllık etkinliği olan **Kralı Yakala**, 5x5 kapalı kartlardan oluşan bir tahta üzerinde oynanır. Amaç; elinizdeki kartları kullanarak tahtadaki tüm kartları açmak ve mümkün olan en yüksek puanı toplamaktır.

### Kart Dağılımı

| Kart | Adet | Puan |
|------|------|------|
| 1 | 5 | +10 |
| 2 | 2 | +20 |
| 3 | 2 | +30 |
| 4 | 1 | +40 |
| 5 | 3 | +50 |
| K (Kral) | 1 | +100 |

### Önemli Kurallar

- **5 kartı** tehlikelidir — açık bir 5'e bitişik hücreye bastığınızda kartınız kaybolur, puan alamazsınız.
- **K kartı** tek hamlede yakalanırsa 100 puan kazanılır ve oyun sona erer.
- Bir **satırdaki tüm kartlar** açılırsa **Bingo** bonusu (+10 puan) kazanılır.

---

## ✨ Uygulama Özellikleri

- 🟥 **Tehlikeli işaretleme** — 5 komşusu olan hücreler otomatik `!` ile işaretlenir
- 🟩 **Güvenli işaretleme** — 5 komşusu olmayan hücreler `✓` ile gösterilir
- 🔢 **Kart sayacı** — Her kartın kalan adedi anlık takip edilir
- ↩️ **Geri al** — Son hamleyi tek tuşla geri alabilirsiniz
- 🎨 **Renk kodlaması** — Her kart değeri kendine özgü renkle gösterilir
- 📱 **Responsive tasarım** — Telefon, tablet ve masaüstünde sorunsuz çalışır

---

## 🚀 Kurulum

### Gereksinimler

- [Flutter SDK](https://flutter.dev/docs/get-started/install) 3.0+
- Dart 3.0+
- Android Studio (Android emülatör / SDK için)

### Çalıştırma

```bash
# Repoyu klonla
git clone https://github.com/kullanici-adin/metin2-kral-yardimci.git
cd metin2-kral-yardimci

# Bağımlılıkları yükle
flutter pub get

# Mobilde çalıştır
flutter run

# Web'de çalıştır
flutter run -d chrome
```

### Build Alma

```bash
# Android APK
flutter build apk

# Web
flutter build web

# Windows
flutter build windows
```

---

## 🌐 Web'e Deploy (Firebase)

```bash
# Firebase CLI kur
npm install -g firebase-tools

# Giriş yap
firebase login

# Web build al
flutter build web

# Yayına al
firebase deploy
```

---

## 🗂️ Proje Yapısı

```
lib/
├── main.dart                 # Uygulama giriş noktası
├── models/
│   └── cell_model.dart       # Hücre ve kart veri modelleri
├── logic/
│   └── game_logic.dart       # Oyun mantığı ve state yönetimi
└── screens/
    └── home_screen.dart      # Ana ekran UI
```

---

## 🛠️ Kullanılan Teknolojiler

| Teknoloji | Açıklama |
|-----------|----------|
| [Flutter](https://flutter.dev) | Cross-platform UI framework |
| [Provider](https://pub.dev/packages/provider) | State management |
| [Firebase Hosting](https://firebase.google.com/products/hosting) | Web hosting |

---

## 📄 Lisans

MIT License — dilediğiniz gibi kullanabilirsiniz.

---

<p align="center">
  <i>Metin2 Kralı Yakala etkinliği için geliştirilmiştir.</i>
</p>
