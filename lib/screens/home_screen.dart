import 'package:flutter/material.dart';

import '../models/note.dart';
import '../theme.dart';
import '../widgets/pinote_logo.dart';
import 'add_note_screen.dart';
import 'login_screen.dart';
import 'note_detail_screen.dart';

// Ganti nama dan email pengguna di sini
const String userName = 'marsya';
const String userEmail = 'pinote@gmail.com';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Note> _notes = sampleNotes();
  final List<Note> _archived = [];
  final _filters = ['Semua', ...categories];
  String _filter = 'Semua';
  String _query = '';
  int _tab = 0; // 0 Beranda, 1 Arsip, 2 Profil
  bool _notif = true;

  List<Note> get _visible => _notes.where((n) {
        final byCategory = _filter == 'Semua' || n.category == _filter;
        final byQuery =
            n.title.toLowerCase().contains(_query.toLowerCase().trim());
        return byCategory && byQuery;
      }).toList();

  // ---------- aksi ----------
  Future<void> _addNote() async {
    final note = await Navigator.of(context).push<Note>(
      MaterialPageRoute(builder: (_) => const AddNoteScreen()),
    );
    if (note != null) setState(() => _notes.insert(0, note));
  }

  Future<void> _openDetail(Note note, List<Note> from) async {
    final deleted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => NoteDetailScreen(note: note)),
    );
    if (deleted == true && mounted) setState(() => from.remove(note));
  }

  void _snack(String msg, {VoidCallback? undo}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        action: undo == null
            ? null
            : SnackBarAction(label: 'Urungkan', onPressed: undo),
      ));
  }

  void _archive(Note note) {
    setState(() {
      _notes.remove(note);
      _archived.insert(0, note);
    });
    _snack('Catatan diarsipkan', undo: () => _restore(note));
  }

  void _restore(Note note) {
    setState(() {
      _archived.remove(note);
      _notes.insert(0, note);
    });
    _snack('Catatan dikembalikan ke Beranda');
  }

  Future<bool> _confirm(String title, String message, String yes) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: Text(yes),
          ),
        ],
      ),
    );
    return ok == true;
  }

  Future<void> _delete(Note note, List<Note> from) async {
    final ok = await _confirm(
        'Hapus catatan?', '"${note.title}" akan dihapus permanen.', 'Hapus');
    if (ok && mounted) setState(() => from.remove(note));
  }

  Future<void> _logout() async {
    final ok = await _confirm(
        'Keluar?', 'Kamu akan kembali ke halaman login.', 'Keluar');
    if (ok && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  // ---------- build ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _tab == 0
          ? FloatingActionButton(
              onPressed: _addNote,
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.add_rounded, size: 30),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryDark,
        unselectedItemColor: AppColors.textMuted,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.folder_open_rounded), label: 'Arsip'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded), label: 'Profil'),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _tab,
          children: [_buildHome(), _buildArchive(), _buildProfile()],
        ),
      ),
    );
  }

  // ---------- tab Beranda ----------
  Widget _buildHome() {
    final notes = _visible;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Halo,',
                        style: TextStyle(
                            fontSize: 16, color: AppColors.textMuted)),
                    Text('marsya 👋',
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _tab = 2),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: const Icon(Icons.person_rounded,
                      color: AppColors.primaryDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Apa yang ingin kamu catat hari ini?',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: const InputDecoration(
                    hintText: 'Cari catatan...',
                    isDense: true,
                    prefixIcon:
                        Icon(Icons.search_rounded, color: AppColors.textMuted),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child:
                    const Icon(Icons.tune_rounded, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final selected = _filters[i] == _filter;
                return GestureDetector(
                  onTap: () => setState(() => _filter = _filters[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color:
                              selected ? AppColors.primary : AppColors.border),
                    ),
                    child: Text(
                      _filters[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? AppColors.onPrimary
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: notes.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada catatan.\nKetuk + untuk menambahkan.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 90),
                    itemCount: notes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final note = notes[i];
                      return _NoteCard(
                        note: note,
                        onTap: () => _openDetail(note, _notes),
                        menu: const <PopupMenuEntry<String>>[
                          PopupMenuItem(
                              value: 'archive', child: Text('Arsipkan')),
                          PopupMenuItem(value: 'delete', child: Text('Hapus')),
                        ],
                        onMenu: (v) {
                          if (v == 'archive') _archive(note);
                          if (v == 'delete') _delete(note, _notes);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ---------- tab Arsip ----------
  Widget _buildArchive() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Arsip',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text('${_archived.length} catatan diarsipkan',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
          const SizedBox(height: 16),
          Expanded(
            child: _archived.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inventory_2_outlined,
                            size: 56, color: AppColors.textMuted),
                        SizedBox(height: 12),
                        Text(
                          'Arsip masih kosong.\nCatatan yang diarsipkan akan muncul di sini.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: _archived.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final note = _archived[i];
                      return _NoteCard(
                        note: note,
                        onTap: () => _openDetail(note, _archived),
                        menu: const <PopupMenuEntry<String>>[
                          PopupMenuItem(
                              value: 'restore', child: Text('Kembalikan')),
                          PopupMenuItem(value: 'delete', child: Text('Hapus')),
                        ],
                        onMenu: (v) {
                          if (v == 'restore') _restore(note);
                          if (v == 'delete') _delete(note, _archived);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ---------- tab Profil ----------
  Widget _buildProfile() {
    final highCount = _notes.where((n) => n.priority == 'Tinggi').length;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Profil',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 44,
            backgroundColor: AppColors.aqua,
            child: Text(
              userName.isEmpty ? '?' : userName[0].toUpperCase(),
              style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark),
            ),
          ),
          const SizedBox(height: 12),
          Text(userName,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          const Text(userEmail, style: TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: _StatBox(value: '${_notes.length}', label: 'Catatan')),
              const SizedBox(width: 12),
              Expanded(
                  child:
                      _StatBox(value: '${_archived.length}', label: 'Arsip')),
              const SizedBox(width: 12),
              Expanded(
                  child:
                      _StatBox(value: '$highCount', label: 'Prioritas tinggi')),
            ],
          ),
          const SizedBox(height: 20),
          Material(
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.border),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline_rounded,
                      color: AppColors.primaryDark),
                  title: const Text('Edit profil'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _snack('Fitur edit profil belum tersedia'),
                ),
                const Divider(height: 1, color: AppColors.border),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_none_rounded,
                      color: AppColors.primaryDark),
                  title: const Text('Notifikasi'),
                  value: _notif,
                  activeColor: Colors.white,
                  activeTrackColor: AppColors.primary,
                  onChanged: (v) => setState(() => _notif = v),
                ),
                const Divider(height: 1, color: AppColors.border),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded,
                      color: AppColors.primaryDark),
                  title: const Text('Tentang Pinote'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => showAboutDialog(
                    context: context,
                    applicationName: 'Pinote',
                    applicationVersion: '1.0.0',
                    applicationIcon: const PinoteLogo(size: 48),
                    children: const [
                      Text(
                          'Aplikasi catatan harian sederhana. Pin ide, simpan momen.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Keluar'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  const _StatBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark)),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final List<PopupMenuEntry<String>> menu;
  final ValueChanged<String> onMenu;

  const _NoteCard({
    required this.note,
    required this.onTap,
    required this.menu,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: note.color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 4, 10),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                    color: Colors.white54, shape: BoxShape.circle),
                child: Icon(note.icon, color: AppColors.primaryDark, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(note.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 3),
                    Text(formatDate(note.date),
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded,
                    color: AppColors.textMuted),
                onSelected: onMenu,
                itemBuilder: (_) => menu,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
