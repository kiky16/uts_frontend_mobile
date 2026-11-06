import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'profile.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({
    required this.completedChallenges,
    required this.onToggleChallenge,
    required this.onOpenPage,
    this.latestEmission = 42.8,
    super.key,
  });

  final Set<int> completedChallenges;
  final ValueChanged<int> onToggleChallenge;
  final ValueChanged<int> onOpenPage;
  final double latestEmission;

  @override
  Widget build(BuildContext context) {
    // Penentuan Breakpoint Responsif
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    // Padding Halaman Adaptif
    final contentSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 16,
      conditionalValues: [
        const Condition.largerThan(name: MOBILE, value: 24),
      ],
    ).value;

    final chart = _ImpactCard(
      onOpenCalculator: () => onOpenPage(1),
      latestEmission: latestEmission,
    );

    final challenge = _ChallengeCard(
      completed: completedChallenges,
      onToggle: onToggleChallenge,
      onOpenAll: () => onOpenPage(2),
    );

    return PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Welcome Header (Adaptif Mobile & Desktop)
          _Welcome(
            onOpenChallenges: () => onOpenPage(2),
            completedCount: completedChallenges.length,
            totalTarget: challenges.length,
          ),
          SizedBox(height: contentSpacing),

          // 2. Responsive Stat Cards (Grid Otomatis Menyesuaikan Ukuran Layar)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 280, // Maksimum lebar per kartu statistik
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 80, // Tinggi tetap kartu compact
            ),
            itemBuilder: (context, index) {
              final stats = [
                const _StatCard(
                  icon: Icons.eco_outlined,
                  label: 'EMISI DIHEMAT',
                  value: '28,4',
                  unit: 'kg CO₂e',
                  note: '↑ 12% dari minggu lalu',
                  color: Color(0xFF43864D),
                  background: Color(0xFFE9F5DC),
                ),
                _StatCard(
                  icon: Icons.track_changes_outlined,
                  label: 'AKSI SELESAI',
                  value: '${completedChallenges.length}',
                  unit: 'aksi',
                  note: '+${completedChallenges.length} minggu ini',
                  color: const Color(0xFFB27A27),
                  background: const Color(0xFFFBEFD4),
                ),
                const _StatCard(
                  icon: Icons.bolt_outlined,
                  label: 'ENERGI DIHEMAT',
                  value: '18,6',
                  unit: 'kWh',
                  note: 'Setara 14 jam AC',
                  color: Color(0xFF367B92),
                  background: Color(0xFFDFF0F0),
                ),
                const _StatCard(
                  icon: Icons.park_outlined,
                  label: 'POHON VIRTUAL',
                  value: '12',
                  unit: 'pohon',
                  note: 'Top 15% komunitas',
                  color: Color(0xFF73629B),
                  background: Color(0xFFEEE9F6),
                ),
              ];
              return stats[index];
            },
          ),
          SizedBox(height: contentSpacing),

          // 3. Section Dampak Karbon & Tantangan (ROW di Desktop, COLUMN di Mobile)
          ResponsiveRowColumn(
            layout: isDesktop
                ? ResponsiveRowColumnType.ROW
                : ResponsiveRowColumnType.COLUMN,
            rowCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveRowColumnItem(rowFlex: 3, child: chart),
              ResponsiveRowColumnItem(
                child: SizedBox(
                  width: isDesktop ? 16 : 0,
                  height: isDesktop ? 0 : 16,
                ),
              ),
              ResponsiveRowColumnItem(rowFlex: 2, child: challenge),
            ],
          ),
          SizedBox(height: contentSpacing),

          // 4. Section Tips & Event Carousel (ROW di Desktop, COLUMN di Mobile)
          ResponsiveRowColumn(
            layout: isDesktop
                ? ResponsiveRowColumnType.ROW
                : ResponsiveRowColumnType.COLUMN,
            rowCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 6,
                child: _TipCard(onReadMore: () => onOpenPage(4)),
              ),
              ResponsiveRowColumnItem(
                child: SizedBox(
                  width: isDesktop ? 16 : 0,
                  height: isDesktop ? 0 : 16,
                ),
              ),
              ResponsiveRowColumnItem(
                rowFlex: 4,
                child: _EventCard(
                  onOpenCommunity: () => onOpenPage(6),
                  isMobile: isMobile,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Welcome extends StatelessWidget {
  const _Welcome({
    required this.onOpenChallenges,
    required this.completedCount,
    required this.totalTarget,
  });

  final VoidCallback onOpenChallenges;
  final int completedCount;
  final int totalTarget;

  @override
  Widget build(BuildContext context) {
    final progress = (completedCount / totalTarget).clamp(0.0, 1.0);
    final percentage = (progress * 100).round();
    final remaining = (totalTarget - completedCount).clamp(0, totalTarget);

    return LayoutBuilder(
      builder: (context, constraints) {
        final intro = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('Selamat datang kembali'),
            const SizedBox(height: 8),
            Text(
              'Aksi kecilmu berarti\nbesar untuk bumi.',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'Terus bergerak. Kamu sudah membuat dampak positif minggu ini.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        );

        final goal = InkWell(
          onTap: onOpenChallenges,
          borderRadius: BorderRadius.circular(15),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Menggunakan valueColor sebagai pengganti parameter color
                        CircularProgressIndicator.adaptive(
                          value: progress,
                          strokeWidth: 6,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF77A937),
                          ),
                          backgroundColor: const Color(0xFFE7ECDF),
                        ),
                        Text(
                          '$percentage%',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Eyebrow('Target mingguan'),
                      const SizedBox(height: 4),
                      Text(
                        '$completedCount dari $totalTarget aksi',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        remaining > 0
                            ? '$remaining aksi lagi untuk mencapai target'
                            : 'Target minggu ini tercapai! 🎉',
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        if (constraints.maxWidth < 720) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [intro, const SizedBox(height: 16), goal],
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: intro),
            goal,
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.note,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final String note;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF93A099),
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .5,
                    ),
                  ),
                  const SizedBox(height: 1),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: AppColors.ink),
                      children: [
                        TextSpan(
                          text: '$value ',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: unit,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 9.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    note,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.muted, fontSize: 8.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImpactCard extends StatelessWidget {
  const _ImpactCard({
    required this.onOpenCalculator,
    required this.latestEmission,
  });

  final VoidCallback onOpenCalculator;
  final double latestEmission;

  @override
  Widget build(BuildContext context) {
    const baselineEmission = 10.0;
    final history = [.62, .45, .75, .38, .56, .29];
    final todayFactor = (latestEmission / baselineEmission).clamp(0.1, 1.0);
    final values = [...history, todayFactor];

    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    const baselineWeekly = 46.5;
    final percentageChange =
        ((latestEmission - baselineWeekly) / baselineWeekly * 100);
    final isDecrease = percentageChange <= 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(
              title: 'Dampak karbonmu',
              subtitle: 'Perkembangan emisi 7 hari terakhir',
              trailing: TextButton(
                onPressed: onOpenCalculator,
                child: const Text('Lihat detail'),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Eyebrow('Total emisi minggu ini'),
                    const SizedBox(height: 4),
                    Text(
                      '${latestEmission.toStringAsFixed(1)} kg CO₂e',
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Chip(
                  label: Text(
                    '${isDecrease ? '↓' : '↑'} ${percentageChange.abs().toStringAsFixed(1)}%',
                  ),
                  backgroundColor: isDecrease
                      ? const Color(0xFFE7F4E9)
                      : const Color(0xFFFEEBEB),
                  labelStyle: TextStyle(
                    color: isDecrease
                        ? const Color(0xFF378057)
                        : const Color(0xFFC53030),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                  side: BorderSide.none,
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 135,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(values.length, (index) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: AnimatedFractionallySizedBox(
                                duration: const Duration(milliseconds: 300),
                                heightFactor: values[index],
                                widthFactor: .6,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: index == 6
                                        ? const Color(0xFF3D7956)
                                        : const Color(0xFFA9C8AA),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            days[index],
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F6E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.eco_outlined, color: AppColors.green, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Gunakan transportasi umum 2× minggu ini untuk menghemat hingga 5,4 kg CO₂e.',
                      style: TextStyle(
                        color: Color(0xFF557064),
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({
    required this.completed,
    required this.onToggle,
    required this.onOpenAll,
  });

  final Set<int> completed;
  final ValueChanged<int> onToggle;
  final VoidCallback onOpenAll;

  @override
  Widget build(BuildContext context) {
    final dailyChallenges = challenges.take(3).toList();
    var dailyCompletedCount = 0;
    for (var i = 0; i < dailyChallenges.length; i++) {
      if (completed.contains(i)) dailyCompletedCount++;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SectionTitle(
              title: 'Tantangan hari ini',
              subtitle: 'Selesaikan aksi dan kumpulkan poin',
              trailing: TextButton(
                onPressed: onOpenAll,
                child: const Text('Semua'),
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(dailyChallenges.length, (index) {
              final item = dailyChallenges[index];
              final done = completed.contains(index);
              return ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () => onToggle(index),
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    done ? Icons.check : item.icon,
                    color: item.color,
                    size: 20,
                  ),
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    color: done ? AppColors.muted : AppColors.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    decoration: done ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(
                  '+${item.points} poin',
                  style: const TextStyle(
                    color: Color(0xFF6D9858),
                    fontSize: 10,
                  ),
                ),
                trailing: Icon(
                  done ? Icons.check_circle : Icons.circle_outlined,
                  color: done ? AppColors.green : AppColors.border,
                  size: 20,
                ),
              );
            }),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$dailyCompletedCount/3 selesai',
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'Hebat, lanjutkan aksimu!',
                  style: TextStyle(color: AppColors.muted, fontSize: 10),
                ),
              ],
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: dailyCompletedCount / 3,
              minHeight: 5,
              color: const Color(0xFF78A64C),
              backgroundColor: const Color(0xFFE7ECE5),
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.onReadMore});

  final VoidCallback onReadMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F2DD),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF8EAC0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.bolt_outlined, color: Color(0xFF977024)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow('Tips hari ini'),
                const SizedBox(height: 6),
                Text(
                  'Cabut charger setelah digunakan',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Charger yang tetap terpasang masih mengonsumsi listrik. Kebiasaan sederhana ini bisa menghemat hingga 10% energi rumah.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                TextButton(
                  onPressed: onReadMore,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Baca selengkapnya →'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({
    required this.onOpenCommunity,
    this.isMobile = false,
  });

  final VoidCallback onOpenCommunity;
  final bool isMobile;

  static const _events = [
    {
      'image': 'assets/1.jpeg',
      'title': 'Tanam 1.000 Pohon Bersama',
      'location': 'Tahura Djuanda · 29 Juni',
    },
    {
      'image': 'assets/2.jpg',
      'title': 'Aksi Bersih Hutan',
      'location': 'Hutan Indah · 15 Juli',
    },
    {
      'image': 'assets/3.jpg',
      'title': 'Workshop Kompos Mandiri',
      'location': 'Hutan Sibolangit · 10 Agustus',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: CarouselSlider(
        options: CarouselOptions(
          height: isMobile ? 190 : 180,
          viewportFraction: 1.0,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          pauseAutoPlayOnTouch: true,
          enableInfiniteScroll: true,
        ),
        items: _events.map((event) {
          return Builder(
            builder: (BuildContext context) {
              return Stack(
                children: [
                  // Background Image
                  Positioned.fill(
                    child: Image.asset(
                      event['image']!,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Gradient Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Teks & Tombol
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'KEGIATAN TERDEKAT',
                          style: TextStyle(
                            color: AppColors.lime,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          event['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Colors.white70,
                              size: 15,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              event['location']!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        FilledButton(
                          onPressed: onOpenCommunity,
                          style: FilledButton.styleFrom(
                            foregroundColor: AppColors.forest,
                            backgroundColor: const Color(0xFFD2EB8C),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            minimumSize: Size.zero,
                          ),
                          child: const Text('Lihat kegiatan'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        }).toList(),
      ),
    );
  }
}