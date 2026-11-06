import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'profile.dart';

class PencapaianPage extends StatelessWidget {
  const PencapaianPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Penentuan status breakpoint (HP / Mobile vs Layar Lebar)
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    // Spacing halaman adaptif (20px pada Mobile, 30px pada Desktop/Tablet)
    final pageSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 20,
      conditionalValues: [
        const Condition.largerThan(name: MOBILE, value: 30),
      ],
    ).value;

    // Jarak antar kartu grid adaptif (12px pada Mobile, 16px pada Desktop/Tablet)
    final gridSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 12,
      conditionalValues: [
        const Condition.largerThan(name: MOBILE, value: 16),
      ],
    ).value;

    // Tinggi kartu adaptif
    final cardHeight = ResponsiveValue<double>(
      context,
      defaultValue: 275,
      conditionalValues: [
        const Condition.largerThan(name: MOBILE, value: 290),
      ],
    ).value;

    const items = [
      (
        Icons.emoji_events_outlined,
        'Eco Guardian',
        'Level 8 · 1.240 poin terkumpul dari 34 aksi.',
        '260 poin lagi',
      ),
      (
        Icons.park_outlined,
        'Penjaga Hutan',
        'Berhasil mendukung penanaman 10 pohon virtual.',
        'Lencana baru',
      ),
      (
        Icons.groups_outlined,
        'Peringkat komunitas',
        'Kamu berada di peringkat 24 dari 1.280 anggota Bandung.',
        'Top 2%',
      ),
    ];

    return PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeading(
            eyebrow: 'Perjalanan hijaumu',
            title: 'Poin & Pencapaian',
            description:
                'Lihat perkembangan level, lencana, dan posisi kamu di komunitas.',
          ),
          SizedBox(height: pageSpacing),

          // GridView dengan tata letak adaptif
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: isMobile ? double.infinity : 360,
              mainAxisSpacing: gridSpacing,
              crossAxisSpacing: gridSpacing,
              mainAxisExtent: cardHeight,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return FeatureCard(
                number: '0${index + 1}',
                icon: item.$1,
                title: item.$2,
                description: item.$3,
                action: item.$4,
              );
            },
          ),
        ],
      ),
    );
  }
}