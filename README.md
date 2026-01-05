# Coding On The Spot (COTS)

Aplikasi manajemen tugas akademik berbasis Flutter yang dirancang untuk membantu mahasiswa mengelola tugas-tugas kuliah mereka dengan lebih efisien.

## 📋 Deskripsi Proyek

**COTS** adalah solusi mobile untuk mahasiswa yang ingin mengorganisir dan melacak tugas-tugas akademik mereka. Aplikasi ini menyediakan antarmuka yang intuitif dan responsif untuk mengelola deadline, status penyelesaian, dan catatan tugas.

## ✨ Fitur Utama

### 1. Dashboard
- Menampilkan ringkasan statistik (total tugas, tugas selesai)
- Menampilkan 3 tugas terdekat berdasarkan deadline
- Tombol navigasi ke daftar tugas lengkap dan tambah tugas baru
- Pull-to-refresh untuk memperbarui data secara real-time

### 2. Daftar Tugas
- Menampilkan semua tugas dalam format list yang terorganisir
- **Filter berdasarkan status:**
  - Semua
  - Berjalan
  - Selesai
  - Terlambat
- **Fitur pencarian** untuk mencari tugas berdasarkan:
  - Judul tugas
  - Nama mata kuliah
- Menampilkan informasi: judul, mata kuliah, deadline, dan status
- Navigasi ke detail tugas dengan tap

### 3. Tambah Tugas
- Form lengkap untuk membuat tugas baru dengan input:
  - Judul tugas (required)
  - Mata kuliah (required, dropdown picker)
  - Deadline (required, date picker)
  - Catatan (optional)
  - Checkbox untuk menandai sudah selesai
- Validasi form dengan error messages yang informatif
- Tombol Batal dan Simpan
- Loading indicator saat menyimpan

### 4. Detail Tugas
- Menampilkan informasi lengkap tugas:
  - Judul
  - Mata kuliah
  - Deadline
  - Status
  - Catatan
- Checkbox untuk mengubah status penyelesaian
- Tombol "Simpan Perubahan" untuk update status
- Tombol "Edit" untuk fitur edit (placeholder)

## 🛠️ Tech Stack

| Aspek | Teknologi |
|-------|-----------|
| Framework | Flutter |
| Language | Dart |
| State Management | Provider (^6.1.2) |
| Backend | Supabase (PostgreSQL) |
| HTTP Client | http (^1.2.2) |
| Font | Google Fonts - Poppins (^6.2.1) |
| Localization | intl (^0.19.0) |
| Design Pattern | MVC (Model-View-Controller) |
| Architecture | Clean Architecture |

## 📁 Struktur Proyek

```
lib/
├── main.dart                          # Entry point aplikasi
└── cots/                              # Folder utama aplikasi
    ├── config/
    │   └── api_config.dart           # Konfigurasi API Supabase
    ├── controllers/
    │   └── task_controller.dart      # State management dengan Provider
    ├── design_system/
    │   ├── colors.dart               # Palet warna aplikasi
    │   ├── typography.dart           # Gaya teks dan font
    │   ├── spacing.dart              # Konstanta spacing dan border radius
    │   └── styles.dart               # Barrel file untuk design system
    ├── models/
    │   └── task.dart                 # Model data Task
    ├── services/
    │   └── task_service.dart         # Service untuk API calls
    └── presentation/
        ├── pages/
        │   ├── dashboard_page.dart   # Halaman utama (dashboard)
        │   ├── task_list_page.dart   # Halaman daftar tugas lengkap
        │   ├── add_task_page.dart    # Halaman tambah tugas baru
        │   └── detail_task_page.dart # Halaman detail tugas
        └── widgets/
            ├── task_card.dart        # Widget kartu tugas
            ├── custom_input.dart     # Widget input field custom
            ├── custom_checkbox.dart  # Widget checkbox custom
            ├── status_badge.dart     # Widget badge status
            └── custom_button.dart    # Widget tombol custom
```

## 🎨 Design System

### Palet Warna
- **Primary**: #2F6BFF (Biru)
- **Background**: #F7FBFA (Putih kebiruan)
- **Surface**: #FFFFFF (Putih)
- **Text**: #0F172A (Hitam gelap)
- **Muted**: #647488 (Abu-abu)
- **Border**: #E2E8F0 (Abu-abu terang)
- **Danger**: #EF4444 (Merah)
- **Success**: #22C55E (Hijau)
- **Warning**: #F59E0B (Kuning)

### Typography
- **Font**: Poppins (dari Google Fonts)
- **Title**: 20px, Weight 600
- **Section**: 16px, Weight 600
- **Body**: 14px, Weight 400
- **Caption**: 12px, Weight 400
- **Button**: 14px, Weight 600

### Spacing
- **xs**: 4px | **sm**: 8px | **md**: 12px | **lg**: 16px | **xl**: 24px | **xxl**: 32px
- **Border Radius**: sm: 8px | md: 12px | lg: 16px | full: 100px

## 🔌 API Integration

Aplikasi menggunakan **Supabase** sebagai backend dengan endpoint berikut:

- **Base URL**: `https://rpblbedyqmnzpowbumzd.supabase.co`
- **Endpoint**: `/rest/v1/tasks`

### API Endpoints
- `GET /rest/v1/tasks` - Ambil semua tugas
- `GET /rest/v1/tasks?status=eq.STATUS` - Filter tugas berdasarkan status
- `POST /rest/v1/tasks` - Tambah tugas baru
- `PATCH /rest/v1/tasks?id=eq.ID` - Update tugas
- `PATCH /rest/v1/tasks?id=eq.ID` - Toggle status penyelesaian

## 📊 Model Data

### Task Model
```dart
class Task {
  final int? id;
  final String title;
  final String course;
  final DateTime deadline;
  final String status;        // BERJALAN, SELESAI, TERLAMBAT
  final String note;
  final bool isDone;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
```

## 🏗️ Arsitektur

Proyek mengikuti pola **MVC (Model-View-Controller)** dengan pemisahan yang jelas:

- **Models**: Task model dengan serialization (fromJson/toJson)
- **Services**: TaskService untuk HTTP calls ke Supabase API
- **Controllers**: TaskController menggunakan Provider untuk state management
- **Presentation**: Pages dan widgets untuk UI

## 🚀 Alur Aplikasi

1. **Startup**: main.dart → MyApp → ChangeNotifierProvider(TaskController) → DashboardPage
2. **Dashboard**: Fetch tasks → Display summary & recent tasks
3. **Task List**: Filter & search tasks → Display in list
4. **Add Task**: Form input → Validate → POST to API → Refresh list
5. **Detail Task**: Display task info → Toggle status → PATCH to API
6. **Error Handling**: Try-catch di service → Error message di UI

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.2.1      # Font custom dari Google Fonts
  provider: ^6.1.2          # State management
  intl: ^0.19.0             # Internasionalisasi dan formatting
  http: ^1.2.2              # HTTP client untuk API calls

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0     # Linting rules
```

## 💡 Fitur yang Dapat Dikembangkan

- Edit tugas yang sudah ada
- Delete tugas
- Kategori/tag untuk tugas
- Reminder/notification
- Export data
- Dark mode
- Offline support dengan local database
- User authentication
- Sharing tugas dengan teman
- Analytics dan reporting

## 📝 Lisensi

Proyek ini adalah bagian dari pembelajaran Flutter dan Dart.
