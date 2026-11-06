import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

abstract final class AppColors {
  static const forest = Color(0xFF123A2D);
  static const forestLight = Color(0xFF255B48);
  static const green = Color(0xFF477E59);
  static const lime = Color(0xFFB9E352);
  static const cream = Color(0xFFF5F7F2);
  static const ink = Color(0xFF17352C);
  static const muted = Color(0xFF778B82);
  static const border = Color(0xFFE0E6DD);
}

abstract final class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.forest,
      brightness: Brightness.light,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.cream,
      fontFamily: 'sans-serif',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.ink,
          fontSize: 32,
          height: 1.15,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.0,
        ),
        headlineSmall: TextStyle(
          color: AppColors.ink,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
        titleMedium: TextStyle(
          color: AppColors.ink,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(
          color: AppColors.muted,
          fontSize: 13,
          height: 1.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.border),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        height: 68,
        backgroundColor: AppColors.forest,
        indicatorColor: AppColors.forestLight,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(color: Colors.white),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFAFBF8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}

class ChallengeItem {
  const ChallengeItem({
    required this.title,
    required this.description,
    required this.points,
    required this.icon,
    required this.color,
  });

  final String title;
  final String description;
  final int points;
  final IconData icon;
  final Color color;
}

const challenges = <ChallengeItem>[
  ChallengeItem(
    title: 'Bawa botol minum sendiri',
    description: 'Hindari membeli minuman dalam kemasan sekali pakai hari ini.',
    points: 30,
    icon: Icons.water_drop_outlined,
    color: Color(0xFF3E8361),
  ),
  ChallengeItem(
    title: 'Bersepeda untuk jarak dekat',
    description: 'Gunakan sepeda untuk satu perjalanan berjarak di bawah 5 km.',
    points: 50,
    icon: Icons.directions_bike_outlined,
    color: Color(0xFFB77B27),
  ),
  ChallengeItem(
    title: 'Matikan perangkat tak terpakai',
    description: 'Cabut perangkat dan charger yang tidak sedang digunakan.',
    points: 25,
    icon: Icons.bolt_outlined,
    color: Color(0xFF47869A),
  ),
  ChallengeItem(
    title: 'Gunakan transportasi umum',
    description: 'Bepergian menggunakan bus atau kereta hari ini.',
    points: 40,
    icon: Icons.directions_bus_outlined,
    color: Color(0xFF3E8361),
  ),
  ChallengeItem(
    title: 'Pilah sampah organik',
    description: 'Pisahkan sisa makanan ke tempat sampah kompostabel.',
    points: 35,
    icon: Icons.compost_outlined,
    color: Color(0xFFB77B27),
  ),
  ChallengeItem(
    title: 'Gunakan tas belanja kain',
    description: 'Bawa tas belanja sendiri saat pergi ke supermarket.',
    points: 20,
    icon: Icons.shopping_bag_outlined,
    color: Color(0xFF47869A),
  ),
  ChallengeItem(
    title: 'Hemat air saat mandi',
    description: 'Batasi waktu mandi tidak lebih dari 5 menit.',
    points: 30,
    icon: Icons.shower_outlined,
    color: Color(0xFF3E8361),
  ),
  ChallengeItem(
    title: 'Habiskan porsi makan',
    description: 'Tidak menyisakan makanan untuk mengurangi limbah pangan.',
    points: 25,
    icon: Icons.restaurant_outlined,
    color: Color(0xFFB77B27),
  ),
  ChallengeItem(
    title: 'Tanam satu tanaman',
    description: 'Rawat atau tanam tanaman hijau di pekarangan rumah.',
    points: 60,
    icon: Icons.park_outlined,
    color: Color(0xFF47869A),
  ),
  ChallengeItem(
    title: 'Gunakan tangga manual',
    description: 'Pilih tangga biasa daripada menggunakan lift/eskalator.',
    points: 20,
    icon: Icons.stairs_outlined,
    color: Color(0xFF3E8361),
  ),
  ChallengeItem(
    title: 'Gunakan sedotan daur ulang',
    description: 'Gunakan sedotan stainless atau hindari penggunaan sedotan.',
    points: 15,
    icon: Icons.local_cafe_outlined,
    color: Color(0xFFB77B27),
  ),
  ChallengeItem(
    title: 'Gunakan lampu LED',
    description: 'Pastikan pencahayaan rumah menggunakan lampu hemat energi.',
    points: 30,
    icon: Icons.lightbulb_outline,
    color: Color(0xFF47869A),
  ),
];

class PageContainer extends StatelessWidget {
  const PageContainer({
    required this.child,
    super.key,
    this.maxWidth = 1280,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16,
      conditionalValues: [
        const Condition.largerThan(name: MOBILE, value: 36),
      ],
    ).value;

    final verticalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 20,
      conditionalValues: [
        const Condition.largerThan(name: MOBILE, value: 34),
      ],
    ).value;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}

class PageHeading extends StatelessWidget {
  const PageHeading({
    required this.eyebrow,
    required this.title,
    required this.description,
    super.key,
  });

  final String eyebrow;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Eyebrow(eyebrow),
        const SizedBox(height: 6),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: isMobile ? 26 : 34,
              ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: isMobile ? 12 : 13,
                ),
          ),
        ),
      ],
    );
  }
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: Color(0xFF769084),
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.4,
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    required this.title,
    this.subtitle,
    this.trailing,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: Color(0xFF95A29B),
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    required this.children,
    super.key,
    this.wideColumns = 3,
    this.mediumColumns = 2,
    this.spacing = 14,
  });

  final List<Widget> children;
  final int wideColumns;
  final int mediumColumns;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return ResponsiveGridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: children.length,
      gridDelegate: ResponsiveGridDelegate(
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        minCrossAxisExtent: 280,
        maxCrossAxisExtent: 400,
      ),
      itemBuilder: (context, index) => children[index],
    );
  }
}

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
    required this.action,
    super.key,
    this.onTap,
    this.actionIcon = Icons.arrow_forward,
  });

  final String number;
  final IconData icon;
  final String title;
  final String description;
  final String action;
  final VoidCallback? onTap;
  final IconData actionIcon;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 18 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: isMobile ? 40 : 46,
                  height: isMobile ? 40 : 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9F3DF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.green,
                    size: isMobile ? 20 : 24,
                  ),
                ),
                Text(
                  number,
                  style: TextStyle(
                    color: const Color(0xFFCDD5CF),
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 14 : 22),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: isMobile ? 14 : 15,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: isMobile ? 12 : 13,
                  ),
            ),
            const Spacer(),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onTap ?? () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: AppColors.green,
              ),
              iconAlignment: IconAlignment.end,
              icon: Icon(actionIcon, size: 16),
              label: Text(
                action,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showDetailDialog(BuildContext context, String title, String message) {
    showAdaptiveDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    final cardPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16,
      conditionalValues: [
        const Condition.largerThan(name: MOBILE, value: 28),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 16,
      conditionalValues: [
        const Condition.largerThan(name: MOBILE, value: 26),
      ],
    ).value;

    return PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeading(
            eyebrow: 'Profil pengguna',
            title: 'Profil Saya',
            description:
                'Kelola informasi akun dan lihat ringkasan perjalanan hijaumu.',
          ),
          SizedBox(height: spacing),

          // Kartu Profil Utama (Full Width & Adaptif)
          SizedBox(
            width: double.infinity,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  children: [
                    Container(
                      width: isMobile ? 80 : 100,
                      height: isMobile ? 80 : 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD7BB85),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'AR',
                        style: TextStyle(
                          color: AppColors.forest,
                          fontSize: isMobile ? 24 : 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Andi Rahman',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontSize: isMobile ? 20 : 22,
                          ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Bandung, Indonesia',
                      style: TextStyle(color: AppColors.muted, fontSize: 13),
                    ),
                    const SizedBox(height: 18),

                    // Row Statistik 3 Kolom yang Mengisi Sepenuhnya Lebar Kartu
                    Row(
                      children: const [
                        Expanded(child: _ProfileStat(label: 'LEVEL', value: '8')),
                        SizedBox(width: 8),
                        Expanded(child: _ProfileStat(label: 'POIN', value: '1.240')),
                        SizedBox(width: 8),
                        Expanded(child: _ProfileStat(label: 'AKSI', value: '34')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ListView Menu
          Card(
            clipBehavior: Clip.antiAlias,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final menuData = [
                  {
                    'icon': Icons.person_outline,
                    'title': 'Informasi pribadi',
                    'dialogTitle': 'Informasi Pribadi',
                    'dialogContent':
                        'Nama: Andi Rahman\nEmail: andi.rahman@example.com\nLokasi: Bandung, Indonesia',
                  },
                  {
                    'icon': Icons.notifications_none,
                    'title': 'Pengaturan notifikasi',
                    'dialogTitle': 'Pengaturan Notifikasi',
                    'dialogContent':
                        'Pengaturan notifikasi pengingat aksi harian dan pembaruan komunitas aktif.',
                  },
                  {
                    'icon': Icons.shield_outlined,
                    'title': 'Privasi dan keamanan',
                    'dialogTitle': 'Privasi dan Keamanan',
                    'dialogContent':
                        'Akun Anda terhubung dengan autentikasi aman. Kata sandi dapat diperbarui di sini.',
                  },
                ];

                final item = menuData[index];
                return ListTile(
                  dense: isMobile,
                  leading: Icon(
                    item['icon'] as IconData,
                    size: isMobile ? 20 : 24,
                  ),
                  title: Text(
                    item['title'] as String,
                    style: TextStyle(
                      fontSize: isMobile ? 13 : 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () {
                    _showDetailDialog(
                      context,
                      item['dialogTitle'] as String,
                      item['dialogContent'] as String,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 12,
        vertical: isMobile ? 10 : 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F6E9),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.ink,
                fontSize: isMobile ? 15 : 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}