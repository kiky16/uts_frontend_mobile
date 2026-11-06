import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'profile.dart';

class NotificationItemData {
  NotificationItemData({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    this.isUnread = true,
  });

  final int id;
  final String title;
  final String description;
  final String time;
  final IconData icon;
  bool isUnread;
}

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({
    required this.notifications,
    required this.onMarkAsRead,
    required this.onDeleteNotification,
    super.key,
  });

  final List<NotificationItemData> notifications;
  final ValueChanged<int> onMarkAsRead;
  final ValueChanged<int> onDeleteNotification;

  void _openNotificationDetail(
    BuildContext context,
    NotificationItemData item,
    int index,
  ) {
    onMarkAsRead(index);

    // Dialog Adaptif mengikuti gaya sistem operasi (Android / iOS)
    showAdaptiveDialog(
      context: context,
      builder: (dialogContext) => AlertDialog.adaptive(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(item.icon, color: AppColors.forest),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.description,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.time,
              style: const TextStyle(color: AppColors.muted, fontSize: 11),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              onDeleteNotification(index);
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFC53030),
            ),
            child: const Text('Hapus'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.forest),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    // Spacing adaptif
    final pageSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 16,
      conditionalValues: [const Condition.largerThan(name: MOBILE, value: 24)],
    ).value;

    final itemPadding = ResponsiveValue<EdgeInsets>(
      context,
      defaultValue: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      conditionalValues: [
        const Condition.largerThan(
          name: MOBILE,
          value: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
      ],
    ).value;

    return PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeading(
            eyebrow: 'Pusat Pesan',
            title: 'Notifikasi',
            description: 'Pantau pembaruan aktivitas, pencapaian, dan pengingat aksi iklimmu.',
          ),
          SizedBox(height: pageSpacing),
          notifications.isEmpty
              ? Card(
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 24 : 32),
                    child: Center(
                      child: Text(
                        'Tidak ada notifikasi tersisa',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: isMobile ? 13 : 14,
                        ),
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: isMobile ? 6 : 8),
                  itemBuilder: (context, index) {
                    final item = notifications[index];
                    return Card(
                      elevation: 0,
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        onTap: () =>
                            _openNotificationDetail(context, item, index),
                        dense: isMobile,
                        contentPadding: itemPadding,
                        tileColor: item.isUnread
                            ? const Color(0xFFF4F8EF)
                            : Colors.white,
                        leading: Container(
                          width: isMobile ? 34 : 38,
                          height: isMobile ? 34 : 38,
                          decoration: BoxDecoration(
                            color: AppColors.forest.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            item.icon,
                            color: AppColors.forest,
                            size: isMobile ? 18 : 20,
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  color: AppColors.ink,
                                  fontSize: isMobile ? 12.5 : 13.5,
                                  fontWeight: item.isUnread
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                ),
                              ),
                            ),
                            if (item.isUnread)
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: AppColors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.description,
                                style: TextStyle(
                                  color: AppColors.muted,
                                  fontSize: isMobile ? 11 : 11.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.time,
                                style: const TextStyle(
                                  color: Color(0xFF98A7A0),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
