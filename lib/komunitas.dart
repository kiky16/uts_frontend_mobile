import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'profile.dart';

class KomunitasPage extends StatelessWidget {
  const KomunitasPage({super.key});

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
        Icons.park_outlined,
        'Tanam 1.000 Pohon Bersama',
        'Tahura Djuanda · Minggu, 29 Juni 2025.',
        'Gabung kegiatan',
      ),
      (
        Icons.delete_sweep_outlined,
        'Bandung Bebas Sampah',
        'Taman Film · Sabtu, 5 Juli 2025.',
        '86 peserta',
      ),
      (
        Icons.groups_outlined,
        'Komunitas Bumi Bandung',
        'Berbagi dokumentasi aksi dan inspirasi bersama 2.430 anggota.',
        'Lihat komunitas',
      ),
    ];

    return PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeading(
            eyebrow: 'Bergerak bersama',
            title: 'Komunitas & Kegiatan',
            description:
                'Temukan kegiatan lingkungan dan terhubung dengan pegiat iklim di sekitarmu.',
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