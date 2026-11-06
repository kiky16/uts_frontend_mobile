import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'profile.dart';

class SampahPage extends StatelessWidget {
  const SampahPage({super.key});

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
        Icons.eco_outlined,
        'Sampah organik',
        'Sisa makanan, daun, dan bahan alami dapat diolah menjadi kompos.',
        'Panduan kompos',
      ),
      (
        Icons.delete_outline,
        'Sampah anorganik',
        'Pisahkan plastik, kaca, kertas, dan logam agar dapat didaur ulang.',
        'Lihat panduan',
      ),
      (
        Icons.location_on_outlined,
        'Bank sampah terdekat',
        'Temukan titik pengumpulan sampah terpilah di sekitar lokasimu.',
        '8 lokasi',
      ),
    ];

    return PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeading(
            eyebrow: 'Pilah dengan benar',
            title: 'Pengelolaan Sampah',
            description:
                'Panduan praktis untuk mengurangi, memilah, dan mengolah sampah sehari-hari.',
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