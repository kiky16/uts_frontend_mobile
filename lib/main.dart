import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'beranda.dart';
import 'edukasi.dart';
import 'kalkulator.dart';
import 'kelolasph.dart';
import 'komunitas.dart';
import 'notifikasi.dart';
import 'pencapaian.dart';
import 'profile.dart';
import 'tantangan.dart';

void main() {
  runApp(const BumiKitaApp());
}

class BumiKitaApp extends StatelessWidget {
  const BumiKitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BumiKita',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  final Set<int> _completedChallenges = {0};
  double _latestEmission = 42.8;

  // State daftar notifikasi di level utama
  final List<NotificationItemData> _notifications = [
    NotificationItemData(
      id: 1,
      title: 'Tantangan Harian Diperbarui',
      description: '3 tantangan baru hari ini sudah siap untuk diselesaikan!',
      time: '10 menit yang lalu',
      icon: Icons.track_changes_outlined,
      isUnread: true,
    ),
    NotificationItemData(
      id: 2,
      title: 'Pencapaian Baru Dibuka!',
      description: 'Selamat! Kamu berhasil menghemat 25 kg CO₂e minggu ini.',
      time: '2 jam yang lalu',
      icon: Icons.emoji_events_outlined,
      isUnread: true,
    ),
    NotificationItemData(
      id: 3,
      title: 'Kegiatan Komunitas Terdekat',
      description:
          'Acara "Tanam 1.000 Pohon Bersama" akan dimulai 2 hari lagi.',
      time: '1 hari yang lalu',
      icon: Icons.groups_outlined,
      isUnread: false,
    ),
    NotificationItemData(
      id: 4,
      title: 'Tips Lingkungan Hari Ini',
      description:
          'Pelajari cara mengurangi sampah plastik di kehidupan sehari-hari.',
      time: '3 hari yang lalu',
      icon: Icons.lightbulb_outline,
      isUnread: false,
    ),
  ];

  static const _destinations = <_AppDestination>[
    _AppDestination('Beranda', Icons.home_outlined),
    _AppDestination('Kalkulator', Icons.calculate_outlined),
    _AppDestination('Tantangan', Icons.track_changes_outlined),
    _AppDestination('Kelola Sampah', Icons.delete_outline),
    _AppDestination('Edukasi', Icons.menu_book_outlined),
    _AppDestination('Pencapaian', Icons.emoji_events_outlined),
    _AppDestination('Komunitas', Icons.groups_outlined),
    _AppDestination('Profil', Icons.person_outline),
  ];

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleChallenge(int index) {
    setState(() {
      if (!_completedChallenges.add(index)) {
        _completedChallenges.remove(index);
      }
    });
  }

  void _updateEmission(double newValue) {
    setState(() {
      _latestEmission = double.parse(newValue.toStringAsFixed(1));
    });
  }

  void _markNotificationAsRead(int index) {
    setState(() {
      _notifications[index].isUnread = false;
    });
  }

  void _deleteNotification(int index) {
    setState(() {
      _notifications.removeAt(index);
    });
  }

  Widget _currentPage() {
    switch (_selectedIndex) {
      case 0:
        return BerandaPage(
          completedChallenges: _completedChallenges,
          onToggleChallenge: _toggleChallenge,
          onOpenPage: _selectPage,
          latestEmission: _latestEmission,
        );

      case 1:
        return KalkulatorPage(onSaveResult: _updateEmission);

      case 2:
        return TantanganPage(
          completedChallenges: _completedChallenges,
          onToggleChallenge: _toggleChallenge,
        );

      case 3:
        return const SampahPage();

      case 4:
        return const EdukasiPage();

      case 5:
        return const PencapaianPage();

      case 6:
        return const KomunitasPage();

      case 7:
        return const ProfilePage();

      case 8:
        return NotifikasiPage(
          notifications: _notifications,
          onMarkAsRead: _markNotificationAsRead,
          onDeleteNotification: _deleteNotification,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;

    // Perbaikan aman untuk mengecek ketersediaan notifikasi yang belum dibaca
    final hasUnreadNotifications =
        _notifications.isNotEmpty &&
        _notifications.any((item) => item.isUnread);

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop)
            _DesktopSidebar(
              selectedIndex: _selectedIndex,
              onSelected: _selectPage,
              destinations: _destinations,
            ),
          Expanded(
            child: Column(
              children: [
                _TopBar(
                  isDesktop: isDesktop,
                  hasUnreadNotifications: hasUnreadNotifications,
                  onOpenProfile: () => _selectPage(7),
                  onOpenNotification: () => _selectPage(8),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: KeyedSubtree(
                      key: ValueKey(_selectedIndex),
                      child: _currentPage(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex > 7 ? 0 : _selectedIndex,
              onDestinationSelected: _selectPage,
              destinations: _destinations
                  .map(
                    (item) => NavigationDestination(
                      icon: Icon(item.icon),
                      label: item.label,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _DesktopSidebar extends StatelessWidget {
  const _DesktopSidebar({
    required this.selectedIndex,
    required this.onSelected,
    required this.destinations,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<_AppDestination> destinations;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248,
      color: AppColors.forest,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                _BrandMark(),
                SizedBox(width: 10),
                Text(
                  'BumiKita',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...List.generate(destinations.length, (index) {
                    final item = destinations[index];
                    final selected = selectedIndex == index;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: ListTile(
                        selected: selected,
                        selectedTileColor: AppColors.forestLight,
                        textColor: const Color(0xFF9DBBAD),
                        selectedColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        leading: Icon(item.icon, size: 21),
                        title: Text(
                          item.label,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () => onSelected(index),
                      ),
                    );
                  }),
                  const SizedBox(height: 14),
                  const _LevelCard(),
                  const SizedBox(height: 14),
                  const Divider(color: Color(0xFF315647)),
                  ListTile(
                    onTap: () => onSelected(7),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFD7BB85),
                      child: Text(
                        'AR',
                        style: TextStyle(
                          color: AppColors.forest,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    title: const Text(
                      'Andi Rahman',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: const Text(
                      'Bandung, Indonesia',
                      style: TextStyle(color: Color(0xFF7FA092), fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatefulWidget {
  const _TopBar({
    required this.isDesktop,
    required this.hasUnreadNotifications,
    required this.onOpenProfile,
    required this.onOpenNotification,
  });

  final bool isDesktop;
  final bool hasUnreadNotifications;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenNotification;

  @override
  State<_TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<_TopBar> {
  final TextEditingController _searchController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  static const List<Map<String, dynamic>> _articles = [
    {
      'title': 'Manfaat Menanam Pohon untuk Lingkungan',
      'category': 'Edukasi Pohon',
      'isAccessible': true,
    },
    {
      'title': 'Cara Merawat Pohon di Area Perkotaan',
      'category': 'Tips & Panduan',
      'isAccessible': false,
    },
    {
      'title': 'Pohon Penghasil Oksigen Terbanyak',
      'category': 'Pengetahuan Lingkungan',
      'isAccessible': true,
    },
    {
      'title': 'Peran Akar Pohon Dalam Mencegah Erosi',
      'category': 'Sains Alam',
      'isAccessible': false,
    },
  ];

  List<Map<String, dynamic>> _filteredArticles = [];

  void _onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      _hideOverlay();
      return;
    }

    setState(() {
      _filteredArticles = _articles.where((article) {
        final title = article['title'].toString().toLowerCase();
        return title.contains(query.toLowerCase());
      }).toList();
    });

    _showOverlay();
  }

  void _showOverlay() {
    _hideOverlay();

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 390,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 48),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 250),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _filteredArticles.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Kata atau artikel tidak ada',
                        style: TextStyle(color: AppColors.muted, fontSize: 13),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _filteredArticles.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = _filteredArticles[index];
                        final bool isAccessible = item['isAccessible'] ?? false;

                        return ListTile(
                          dense: true,
                          title: Text(
                            item['title'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            item['category'],
                            style: const TextStyle(fontSize: 10),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: isAccessible
                                  ? const Color(0xFFE9F5DC)
                                  : const Color(0xFFFEEBEB),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isAccessible
                                  ? 'Dapat Diakses'
                                  : 'Tidak Dapat Diakses',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: isAccessible
                                    ? const Color(0xFF43864D)
                                    : const Color(0xFFC53030),
                              ),
                            ),
                          ),
                          onTap: () {
                            _searchController.text = item['title'];
                            _hideOverlay();
                          },
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _hideOverlay();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      padding: EdgeInsets.symmetric(horizontal: widget.isDesktop ? 42 : 18),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFBF8),
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (!widget.isDesktop) ...[
            const _BrandMark(size: 32),
            const SizedBox(width: 8),
            const Text(
              'BumiKita',
              style: TextStyle(
                color: AppColors.forest,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ] else
            CompositedTransformTarget(
              link: _layerLink,
              child: SizedBox(
                width: 390,
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Cari artikel tentang pohon...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
              ),
            ),
          const Spacer(),
          IconButton(
            tooltip: 'Notifikasi',
            onPressed: widget.onOpenNotification,
            icon: Badge(
              isLabelVisible: widget.hasUnreadNotifications,
              smallSize: 7,
              child: const Icon(Icons.notifications_none),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: widget.onOpenProfile,
            borderRadius: BorderRadius.circular(20),
            child: const CircleAvatar(
              radius: 17,
              backgroundColor: Color(0xFFD7BB85),
              child: Text(
                'AR',
                style: TextStyle(
                  color: AppColors.forest,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({this.size = 36});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.lime,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(
        Icons.eco_outlined,
        color: AppColors.forest,
        size: size * .58,
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF194535),
        border: Border.all(color: const Color(0xFF315A4A)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LEVEL 8',
                style: TextStyle(
                  color: AppColors.lime,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Eco Guardian',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 13),
          Text(
            '1.240 poin',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 9),
          LinearProgressIndicator(
            value: .75,
            minHeight: 5,
            backgroundColor: Color(0xFF315949),
            color: AppColors.lime,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          SizedBox(height: 8),
          Text(
            '260 poin menuju level berikutnya',
            style: TextStyle(color: Color(0xFF89A99B), fontSize: 9),
          ),
        ],
      ),
    );
  }
}

class _AppDestination {
  const _AppDestination(this.label, this.icon);

  final String label;
  final IconData icon;
}
