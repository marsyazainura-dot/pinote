# Pinote

Desain UI aplikasi catatan harian sederhana menggunakan Flutter.
**Tugas Individual 02 - Uji Pemahaman Fase 2 (Perancangan/Design).**

Pinote memakai tema warna coral dan teal (palet dari colorhunt.co) dengan logo huruf "P" dan pin.
Aplikasi ini hanya UI: tidak ada database dan tidak ada autentikasi sungguhan.

## Halaman

1. **Splash Screen** - logo, nama aplikasi, tagline, dan progress bar.
2. **Login Statis** - form email dan password (validasi sederhana, demo).
3. **Beranda** - daftar catatan, pencarian, filter kategori, tab Arsip dan Profil.
4. **Tambah Catatan** - form judul, isi, kategori, warna, dan prioritas.
5. **Detail Catatan** - menampilkan isi catatan lengkap.

## Akun demo

- Email: `marsya@gmail.com`
- Password: `1717`

## Struktur folder

```
lib/
  main.dart
  theme.dart
  models/note.dart
  widgets/pinote_logo.dart
  screens/
    splash_screen.dart
    login_screen.dart
    home_screen.dart
    add_note_screen.dart
    note_detail_screen.dart
```

## Cara menjalankan

```
flutter create .
flutter pub get
flutter run
```

`flutter create .` membuat folder platform (android, ios, web, dll.) tanpa menimpa folder `lib`.
