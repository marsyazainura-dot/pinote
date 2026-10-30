import 'package:flutter/material.dart';

import '../models/note.dart';
import '../theme.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  String? _category;
  Color _color = AppColors.noteColors[0];
  String _priority = 'Sedang';

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
            const SnackBar(content: Text('Judul catatan wajib diisi')));
      return;
    }
    Navigator.of(context).pop(
      Note(
        title: _titleCtrl.text.trim(),
        content: _contentCtrl.text.trim(),
        category: _category ?? 'Pribadi',
        color: _color,
        priority: _priority,
        date: DateTime.now(),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8),
        child: Text(text,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Catatan')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Judul Catatan'),
              TextField(
                controller: _titleCtrl,
                textCapitalization: TextCapitalization.sentences,
                decoration:
                    const InputDecoration(hintText: 'Masukkan judul catatan'),
              ),
              _label('Isi Catatan'),
              TextField(
                controller: _contentCtrl,
                minLines: 5,
                maxLines: 8,
                textCapitalization: TextCapitalization.sentences,
                decoration:
                    const InputDecoration(hintText: 'Tulis catatan Anda di sini...'),
              ),
              _label('Kategori'),
              DropdownButtonFormField<String>(
                value: _category,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                decoration: const InputDecoration(
                  hintText: 'Pilih kategori',
                  prefixIcon: Icon(Icons.label_outline_rounded,
                      color: AppColors.textMuted),
                ),
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v),
              ),
              _label('Warna'),
              Row(
                children: AppColors.noteColors.map((c) {
                  final selected = c == _color;
                  return Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: GestureDetector(
                      onTap: () => setState(() => _color = c),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : Colors.black12,
                            width: selected ? 2.5 : 1,
                          ),
                        ),
                        child: selected
                            ? const Icon(Icons.check_rounded,
                                size: 20, color: AppColors.primary)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
              _label('Prioritas'),
              Row(
                children: priorities.map((p) {
                  final selected = p == _priority;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: p == priorities.last ? 0 : 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _priority = p),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          height: 42,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selected ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.border),
                          ),
                          child: Text(
                            p,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color:
                                  selected ? Colors.white : AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),
              ElevatedButton(onPressed: _save, child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}
