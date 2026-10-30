import 'package:flutter/material.dart';

import '../theme.dart';

class Note {
  final String title;
  final String content;
  final String category; // Penting / Pribadi / Kerja
  final Color color;
  final String priority; // Rendah / Sedang / Tinggi
  final DateTime date;

  const Note({
    required this.title,
    required this.content,
    required this.category,
    required this.color,
    required this.priority,
    required this.date,
  });

  IconData get icon => categoryIcon(category);
}

const categories = ['Penting', 'Pribadi', 'Kerja'];
const priorities = ['Rendah', 'Sedang', 'Tinggi'];

IconData categoryIcon(String category) {
  switch (category) {
    case 'Penting':
      return Icons.push_pin_rounded;
    case 'Kerja':
      return Icons.work_rounded;
    default:
      return Icons.favorite_rounded;
  }
}

const _months = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
];

String formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

String formatTime(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}.${d.minute.toString().padLeft(2, '0')}';

/// Data contoh (UI saja, tanpa database).
List<Note> sampleNotes() => [
      Note(
        title: 'Ide Aplikasi',
        content:
            'Ide untuk membuat aplikasi catatan sederhana dengan fitur kategori, warna, dan prioritas. Aplikasi ini digunakan untuk mencatat ide, rencana, dan hal penting sehari-hari.',
        category: 'Penting',
        color: AppColors.noteYellow,
        priority: 'Tinggi',
        date: DateTime(2026, 10, 19, 9, 30),
      ),
      Note(
        title: 'Rencana Mingguan',
        content:
            'Senin: rapat tim.\nRabu: kumpulkan tugas Flutter.\nJumat: olahraga dan beres-beres kamar.',
        category: 'Kerja',
        color: AppColors.noteMint,
        priority: 'Sedang',
        date: DateTime(2026, 10, 18, 20, 15),
      ),
      Note(
        title: 'Catatan Kuliah',
        content:
            'Fase perancangan (design) mencakup wireframe, mockup, dan prototipe. Pastikan tampilan konsisten di semua halaman.',
        category: 'Pribadi',
        color: AppColors.notePurple,
        priority: 'Sedang',
        date: DateTime(2026, 10, 17, 14, 0),
      ),
      Note(
        title: 'Hal yang Perlu Dibeli',
        content: 'Buku tulis, pulpen gel, charger, dan snack untuk begadang.',
        category: 'Pribadi',
        color: AppColors.notePink,
        priority: 'Rendah',
        date: DateTime(2026, 10, 16, 17, 45),
      ),
      Note(
        title: 'Jurnal Harian',
        content:
            'Hari ini cukup produktif. Selesai membuat desain awal aplikasi dan mulai menulis kodenya.',
        category: 'Pribadi',
        color: AppColors.noteBlue,
        priority: 'Rendah',
        date: DateTime(2026, 10, 15, 21, 30),
      ),
    ];
