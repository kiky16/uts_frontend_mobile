import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'profile.dart';

class TantanganPage extends StatelessWidget {
  const TantanganPage({
    required this.completedChallenges,
    required this.onToggleChallenge,
    super.key,
  });

  final Set<int> completedChallenges;
  final ValueChanged<int> onToggleChallenge;

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

    return PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeading(
            eyebrow: 'Aksi nyata',
            title: 'Tantangan Aksi Iklim',
            description:
                'Selesaikan misi sederhana, bangun kebiasaan baik, dan kumpulkan poin.',
          ),
          SizedBox(height: pageSpacing),

          // GridView dengan tata letak adaptif
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: challenges.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: isMobile ? double.infinity : 360,
              mainAxisSpacing: gridSpacing,
              crossAxisSpacing: gridSpacing,
              mainAxisExtent: cardHeight,
            ),
            itemBuilder: (context, index) {
              final item = challenges[index];
              final done = completedChallenges.contains(index);
              final cardNumber = index < 9 ? '0${index + 1}' : '${index + 1}';

              return FeatureCard(
                number: cardNumber,
                icon: item.icon,
                title: item.title,
                description: item.description,
                action: done ? 'Selesai' : '+${item.points} poin',
                actionIcon: done ? Icons.check_circle : Icons.arrow_forward,
                onTap: () => onToggleChallenge(index),
              );
            },
          ),
        ],
      ),
    );
  }
}