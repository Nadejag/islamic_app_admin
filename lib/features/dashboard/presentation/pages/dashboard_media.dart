part of 'dashboard_page.dart';

class _MediaManagementBody extends StatelessWidget {
  const _MediaManagementBody({required this.onBackToDashboard, this.compact = false});

  final VoidCallback onBackToDashboard;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    const cards = [
      _MediaItemCard(title: 'Surah Al-Mulk - Tafseer', meta: '12.4 MB    Oct 24, 2023', icon: Icons.volume_up_rounded, thumbColor: Color(0xFF0F2D42)),
      _MediaItemCard(title: 'Morning Dhikr Poster', meta: '1.8 MB    Oct 23, 2023', icon: Icons.image_outlined, thumbColor: Color(0xFF304E43)),
      _MediaItemCard(title: 'Understanding Sabr', meta: '452 MB    Oct 22, 2023', icon: Icons.play_circle_fill_rounded, thumbColor: Color(0xFF354949)),
      _MediaItemCard(title: 'Fiqh of Fasting - PDF', meta: '4.2 MB    Oct 21, 2023', icon: Icons.picture_as_pdf_rounded, thumbColor: Color(0xFF3A3E30)),
      _MediaItemCard(title: 'Friday Khutbah Audio', meta: '28 MB    Oct 20, 2023', icon: Icons.volume_up_rounded, thumbColor: Color(0xFF213D44)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(onPressed: onBackToDashboard, icon: const Icon(Icons.arrow_back, color: AppColors.white), tooltip: 'Back to Dashboard'),
            const SizedBox(width: 4),
            const Text('Content Media Library', style: TextStyle(color: AppColors.white, fontSize: 24, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: const Color(0xFF0E3529), border: Border.all(color: AppColors.stroke)),
          child: const Row(
            children: [
              _MediaTabChip('All Media', active: true),
              SizedBox(width: 8),
              _MediaTabChip('Audio'),
              SizedBox(width: 8),
              _MediaTabChip('Video'),
              SizedBox(width: 8),
              _MediaTabChip('Images'),
              SizedBox(width: 8),
              _MediaTabChip('Documents'),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: compact
              ? ListView(
                  children: [
                    const Wrap(spacing: 14, runSpacing: 14, children: cards),
                    const SizedBox(height: 14),
                    const _MediaStoragePanel(compact: true),
                  ],
                )
              : const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(spacing: 14, runSpacing: 14, children: cards),
                      ),
                    ),
                    SizedBox(width: 16),
                    SizedBox(width: 320, child: _MediaStoragePanel()),
                  ],
                ),
        ),
      ],
    );
  }
}

class _MediaTabChip extends StatelessWidget {
  const _MediaTabChip(this.label, {this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(color: active ? AppColors.green : const Color(0xFF12392A), borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: TextStyle(color: active ? const Color(0xFF032519) : const Color(0xFFA5C0B6), fontSize: 14, fontWeight: FontWeight.w700)),
    );
  }
}

class _MediaItemCard extends StatelessWidget {
  const _MediaItemCard({required this.title, required this.meta, required this.icon, required this.thumbColor});

  final String title;
  final String meta;
  final IconData icon;
  final Color thumbColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF12392A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.stroke),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(color: thumbColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(14))),
              child: Center(child: Icon(icon, color: AppColors.green, size: 42)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(meta, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MediaStoragePanel extends StatelessWidget {
  const _MediaStoragePanel({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF12392A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.storage_rounded, color: AppColors.green, size: 18),
              SizedBox(width: 8),
              Text('Storage Statistics', style: TextStyle(color: AppColors.white, fontSize: 30, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F3427),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.stroke),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TOTAL USAGE', style: TextStyle(color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: .8)),
                SizedBox(height: 6),
                Row(
                  children: [
                    Text('128.5 GB', style: TextStyle(color: AppColors.white, fontSize: 38, fontWeight: FontWeight.w700)),
                    Spacer(),
                    Text('64% of 200GB', style: TextStyle(color: Color(0xFFE2C64A), fontSize: 13, fontWeight: FontWeight.w700)),
                  ],
                ),
                SizedBox(height: 8),
                _AnimatedBar(progress: .64, color: AppColors.green),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Expanded(child: _StorageMiniCard(label: 'AUDIO FILES', value: '42.1 GB')),
              SizedBox(width: 8),
              Expanded(child: _StorageMiniCard(label: 'VIDEO LESSONS', value: '76.3 GB')),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Expanded(child: _StorageMiniCard(label: 'INSPIRATIONS', value: '8.2 GB')),
              SizedBox(width: 8),
              Expanded(child: _StorageMiniCard(label: 'TAFSEER PDFS', value: '1.9 GB')),
            ],
          ),
          const SizedBox(height: 14),
          const Text('Recent Uploads', style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          const _RecentUploadRow(icon: Icons.music_note, iconBg: Color(0xFF0F4D38), title: 'Surah An-Nasr.mp3', meta: 'Uploaded by Admin Zahid • 2m ago'),
          const SizedBox(height: 8),
          const _RecentUploadRow(icon: Icons.image, iconBg: Color(0xFF4B4A1C), title: 'Ramadan_Kareem_24.jpg', meta: 'Uploaded by Content_Mod • 14m ago'),
          const SizedBox(height: 8),
          const _RecentUploadRow(icon: Icons.movie_creation_outlined, iconBg: Color(0xFF113B5A), title: 'Hajj_Guide_v2.mp4', meta: 'Uploaded by Scholar_Reviewer • 1h ago'),
          if (compact) const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _StorageMiniCard extends StatelessWidget {
  const _StorageMiniCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3427),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: AppColors.white, fontSize: 28, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _RecentUploadRow extends StatelessWidget {
  const _RecentUploadRow({required this.icon, required this.iconBg, required this.title, required this.meta});

  final IconData icon;
  final Color iconBg;
  final String title;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: AppColors.green, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w700)),
              Text(meta, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
