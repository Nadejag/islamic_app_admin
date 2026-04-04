 part of 'dashboard_page.dart';

const int _kMediaStorageCapacityBytes = 200 * 1024 * 1024 * 1024;

Future<void> _showMediaUploadDialog(BuildContext context) async {
  final settingsRef = FirebaseFirestore.instance
      .collection('settings')
      .doc('media_library');
  final ayahSettingsRef = FirebaseFirestore.instance
      .collection('home_content')
      .doc('ayah_of_the_day');

  final settingsSnap = await settingsRef.get();
  final ayahSettingsSnap = await ayahSettingsRef.get();
  if (!context.mounted) return;

  final settings = settingsSnap.data() ?? <String, dynamic>{};
  final ayahSettings = ayahSettingsSnap.data() ?? <String, dynamic>{};

  final titleCtl = TextEditingController();
  final cloudNameCtl = TextEditingController(
    text:
        (settings['cloudinaryCloudName'] as String?) ??
        (ayahSettings['cloudinaryCloudName'] as String?) ??
        '',   
  );
  final uploadPresetCtl = TextEditingController(
    text:
        (settings['cloudinaryUploadPreset'] as String?) ??
        (ayahSettings['cloudinaryUploadPreset'] as String?) ??
        '',
  );
  final folderCtl = TextEditingController(
    text:
        (settings['cloudinaryFolder'] as String?) ??
        (ayahSettings['cloudinaryFolder'] as String?) ??
        'admin_media',
  );
  String category = 'Images';
  bool applyToAyah = true;

  final confirmed =
      await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Upload New Media'),
                content: SizedBox(
                  width: 420,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: titleCtl,
                          decoration: const InputDecoration(
                            labelText: 'Title (optional)',
                            hintText: 'Use a readable media title',
                          ),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          initialValue: category,
                          decoration: const InputDecoration(
                            labelText: 'Media Type',
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Images',
                              child: Text('Images'),
                            ),
                            DropdownMenuItem(
                              value: 'Audio',
                              child: Text('Audio'),
                            ),
                            DropdownMenuItem(
                              value: 'Video',
                              child: Text('Video'),
                            ),
                            DropdownMenuItem(
                              value: 'Documents',
                              child: Text('Documents'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                category = value;
                                if (category != 'Images' &&
                                    category != 'Audio') {
                                  applyToAyah = false;
                                }
                              });
                            }
                          },
                        ),
                        if (category == 'Images' || category == 'Audio') ...[
                          const SizedBox(height: 10),
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            value: applyToAyah,
                            title: Text(
                              category == 'Images'
                                  ? 'Apply image to Ayah of the Day'
                                  : 'Apply audio to Ayah of the Day',
                            ),
                            subtitle: Text(
                              category == 'Images'
                                  ? 'Use this uploaded image on the live home card.'
                                  : 'Use this uploaded audio on the live Ayah player.',
                            ),
                            onChanged: (value) {
                              setState(() => applyToAyah = value);
                            },
                          ),
                        ],
                        const SizedBox(height: 10),
                        TextField(
                          controller: cloudNameCtl,
                          decoration: const InputDecoration(
                            labelText: 'Cloudinary Cloud Name',
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: uploadPresetCtl,
                          decoration: const InputDecoration(
                            labelText: 'Unsigned Upload Preset',
                            helperText:
                                'This preset must be marked Unsigned in Cloudinary',
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: folderCtl,
                          decoration: const InputDecoration(
                            labelText: 'Cloudinary Folder',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: const Text('Cancel'),
                  ),
                  FilledButton.icon(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Choose File'),
                  ),
                ],
              );
            },
          );
        },
      ) ??
      false;

  if (!confirmed || !context.mounted) return;

  final cloudName = cloudNameCtl.text.trim();
  final uploadPreset = uploadPresetCtl.text.trim();
  final folder = folderCtl.text.trim();

  if (cloudName.isEmpty || uploadPreset.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Enter Cloudinary cloud name and upload preset first.'),
      ),
    );
    return;
  }

  final result = await FilePicker.platform.pickFiles(
    type: _pickerTypeForCategory(category),
    withData: true,
    allowMultiple: false,
    allowedExtensions: _allowedExtensionsForCategory(category),
  );
  if (!context.mounted) return;
  if (result == null || result.files.isEmpty) return;

  final file = result.files.single;
  final bytes = file.bytes;
  if (bytes == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not read the selected file.')),
    );
    return;
  }

  try {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Uploading "${file.name}"...')));

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/auto/upload'),
    )..fields['upload_preset'] = uploadPreset;

    if (folder.isNotEmpty) {
      request.fields['folder'] = folder;
    }

    request.files.add(
      http.MultipartFile.fromBytes('file', bytes, filename: file.name),
    );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Cloudinary upload failed: $responseBody');
    }

    final decoded = jsonDecode(responseBody);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected Cloudinary response: $responseBody');
    }

    final secureUrl = decoded['secure_url'] as String?;
    if (secureUrl == null || secureUrl.isEmpty) {
      throw Exception('Cloudinary did not return a secure URL.');
    }

    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName?.trim();
    final email = user?.email?.trim();
    final uploadedBy = (displayName != null && displayName.isNotEmpty)
        ? displayName
        : (email != null && email.isNotEmpty)
        ? email
        : (user?.uid ?? 'Super Admin');

    final title = titleCtl.text.trim().isEmpty
        ? file.name
        : titleCtl.text.trim();
    final config = {
      'cloudinaryCloudName': cloudName,
      'cloudinaryUploadPreset': uploadPreset,
      'cloudinaryFolder': folder,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': user?.uid ?? 'unknown_admin',
    };

    await settingsRef.set(config, SetOptions(merge: true));
    await ayahSettingsRef.set(config, SetOptions(merge: true));
    final mediaDoc = await FirebaseFirestore.instance
        .collection('media_library')
        .add({
          'title': title,
          'fileName': file.name,
          'category': category,
          'url': secureUrl,
          'publicId': decoded['public_id'],
          'resourceType': decoded['resource_type'] ?? 'raw',
          'format': (decoded['format'] as String?) ?? (file.extension ?? ''),
          'sizeBytes': (decoded['bytes'] as num?)?.round() ?? file.size,
          'uploadedAt': FieldValue.serverTimestamp(),
          'uploadedBy': uploadedBy,
          'uploadedByUid': user?.uid ?? 'unknown_admin',
          'source': 'cloudinary',
        });

    if (applyToAyah && category == 'Images') {
      await _syncImageToAyah(
        context,
        imageUrl: secureUrl,
        publicId: decoded['public_id'] as String?,
        mediaItemId: mediaDoc.id,
        mediaTitle: title,
        showFeedback: false,
      );
    } else if (applyToAyah && category == 'Audio') {
      await _syncAudioToAyah(
        context,
        audioUrl: secureUrl,
        publicId: decoded['public_id'] as String?,
        mediaItemId: mediaDoc.id,
        mediaTitle: title,
        showFeedback: false,
      );
    }

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          applyToAyah && (category == 'Images' || category == 'Audio')
              ? '"$title" uploaded and applied to Ayah in realtime.'
              : '"$title" uploaded and synced in realtime.',
        ),
      ),
    );
  } catch (e) {
    debugPrint('Cloudinary media upload failed: $e');
    if (!context.mounted) return;
    final friendlyMessage = _readableCloudinaryUploadMessage(e);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(friendlyMessage),
        duration: const Duration(seconds: 8),
      ),
    );
  }
}

FileType _pickerTypeForCategory(String category) {
  switch (category) {
    case 'Audio':
      return FileType.audio;
    case 'Video':
      return FileType.video;
    case 'Images':
      return FileType.image;
    case 'Documents':
      return FileType.custom;
    default:
      return FileType.any;
  }
}

List<String>? _allowedExtensionsForCategory(String category) {
  if (category != 'Documents') return null;
  return const ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx', 'txt'];
}

String _readableCloudinaryUploadMessage(Object error) {
  final raw = error.toString();
  final normalized = raw.toLowerCase();

  if (normalized.contains(
    'upload preset must be whitelisted for unsigned uploads',
  )) {
    return 'Cloudinary preset is not unsigned. In Cloudinary → Settings → Upload → Upload presets, create or edit a preset, enable "Unsigned", then use that preset here.';
  }

  if (normalized.contains('must supply api_key')) {
    return 'Cloudinary is missing the API key configuration. Check your Cloudinary setup and try again.';
  }

  return raw;
}

Future<void> _syncImageToAyah(
  BuildContext context, {
  required String imageUrl,
  String? publicId,
  String? mediaItemId,
  String? mediaTitle,
  bool showFeedback = true,
}) async {
  try {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_admin';
    await FirebaseFirestore.instance
        .collection('home_content')
        .doc('ayah_of_the_day')
        .set({
          'imageUrl': imageUrl,
          if (publicId != null && publicId.isNotEmpty)
            'imagePublicId': publicId,
          if (mediaItemId != null && mediaItemId.isNotEmpty)
            'linkedMediaLibraryItemId': mediaItemId,
          if (mediaTitle != null && mediaTitle.isNotEmpty)
            'linkedMediaTitle': mediaTitle,
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': uid,
        }, SetOptions(merge: true));

    if (!context.mounted || !showFeedback) return;
    final targetLabel = (mediaTitle != null && mediaTitle.isNotEmpty)
        ? '"$mediaTitle"'
        : 'selected media';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ayah image updated from $targetLabel.')),
    );
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Could not update Ayah image: $e')));
  }
}

Future<void> _syncAudioToAyah(
  BuildContext context, {
  required String audioUrl,
  String? publicId,
  String? mediaItemId,
  String? mediaTitle,
  bool showFeedback = true,
}) async {
  try {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_admin';
    await FirebaseFirestore.instance
        .collection('home_content')
        .doc('ayah_of_the_day')
        .set({
          'audioUrl': audioUrl,
          if (publicId != null && publicId.isNotEmpty)
            'audioPublicId': publicId,
          if (mediaItemId != null && mediaItemId.isNotEmpty)
            'linkedAudioMediaLibraryItemId': mediaItemId,
          if (mediaTitle != null && mediaTitle.isNotEmpty)
            'linkedAudioMediaTitle': mediaTitle,
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': uid,
        }, SetOptions(merge: true));

    if (!context.mounted || !showFeedback) return;
    final targetLabel = (mediaTitle != null && mediaTitle.isNotEmpty)
        ? '"$mediaTitle"'
        : 'selected audio';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ayah audio updated from $targetLabel.')),
    );
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Could not update Ayah audio: $e')));
  }
}

class _MediaManagementBody extends StatefulWidget {
  const _MediaManagementBody({
    required this.onBackToDashboard,
    this.compact = false,
  });

  final VoidCallback onBackToDashboard;
  final bool compact;

  @override
  State<_MediaManagementBody> createState() => _MediaManagementBodyState();
}

class _MediaManagementBodyState extends State<_MediaManagementBody> {
  static const List<String> _tabs = [
    'All Media',
    'Audio',
    'Video',
    'Images',
    'Documents',
  ];

  String _selectedTab = 'All Media';

  List<_MediaLibraryItem> _visibleItems(
    List<_MediaLibraryItem> items,
    String searchQuery,
  ) {
    final q = searchQuery.trim().toLowerCase();
    return items.where((item) {
      final matchesTab =
          _selectedTab == 'All Media' || item.category == _selectedTab;
      if (!matchesTab) return false;
      if (q.isEmpty) return true;
      return item.title.toLowerCase().contains(q) ||
          item.uploadedBy.toLowerCase().contains(q) ||
          item.category.toLowerCase().contains(q) ||
          item.url.toLowerCase().contains(q) ||
          item.format.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> _deleteItem(_MediaLibraryItem item) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Delete media item?'),
            content: Text(
              'This removes "${item.title}" from the realtime media library.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    try {
      await FirebaseFirestore.instance
          .collection('media_library')
          .doc(item.id)
          .delete();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deleted "${item.title}" from live media.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not delete media item: $e')),
      );
    }
  }

  void _copyUrl(_MediaLibraryItem item) {
    Clipboard.setData(ClipboardData(text: item.url));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Copied URL for "${item.title}".')));
  }

  Future<void> _useForAyah(_MediaLibraryItem item) async {
    if (item.url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This media item has no usable URL.')),
      );
      return;
    }

    if (item.isImage) {
      await _syncImageToAyah(
        context,
        imageUrl: item.url,
        publicId: item.publicId,
        mediaItemId: item.id,
        mediaTitle: item.title,
      );
      return;
    }

    if (item.isAudio) {
      await _syncAudioToAyah(
        context,
        audioUrl: item.url,
        publicId: item.publicId,
        mediaItemId: item.id,
        mediaTitle: item.title,
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Only image or audio media can be used for Ayah.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = context.select(
      (DashboardCubit cubit) => cubit.state.searchQuery,
    );

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('media_library')
          .orderBy('uploadedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        final docs =
            snapshot.data?.docs ??
            <QueryDocumentSnapshot<Map<String, dynamic>>>[];
        final allItems = docs.map(_MediaLibraryItem.fromDoc).toList();
        final visibleItems = _visibleItems(allItems, searchQuery);
        final stats = _MediaStats.fromItems(allItems);

        Widget libraryContent;
        if (snapshot.hasError) {
          libraryContent = _MediaFeedbackCard(
            message:
                'Could not load the realtime media library: ${snapshot.error}',
          );
        } else if (visibleItems.isEmpty) {
          libraryContent = _MediaFeedbackCard(
            message: docs.isEmpty
                ? 'No media uploaded yet. Use the Upload button to add images, audio, video, or documents in realtime.'
                : 'No media matches the current search or selected filter.',
          );
        } else {
          libraryContent = Wrap(
            spacing: 14,
            runSpacing: 14,
            children: visibleItems
                .map(
                  (item) => _MediaItemCard(
                    item: item,
                    onCopy: () => _copyUrl(item),
                    onDelete: () => _deleteItem(item),
                    onUseForAyah: (item.isImage || item.isAudio)
                        ? () => _useForAyah(item)
                        : null,
                  ),
                )
                .toList(),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: widget.onBackToDashboard,
                  icon: const Icon(Icons.arrow_back, color: AppColors.white),
                  tooltip: 'Back to Dashboard',
                ),
                const SizedBox(width: 4),
                const Expanded(
                  child: Text(
                    'Content Media Library',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F3427),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.stroke),
                  ),
                  child: Text(
                    '${allItems.length} live files',
                    style: const TextStyle(
                      color: AppColors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0E3529),
                border: Border.all(color: AppColors.stroke),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _tabs
                      .map(
                        (tab) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _MediaTabChip(
                            tab,
                            active: tab == _selectedTab,
                            onTap: () => setState(() => _selectedTab = tab),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: widget.compact
                  ? ListView(
                      children: [
                        if (snapshot.connectionState ==
                                ConnectionState.waiting &&
                            !snapshot.hasData)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 14),
                            child: LinearProgressIndicator(),
                          ),
                        libraryContent,
                        const SizedBox(height: 14),
                        _MediaStoragePanel(
                          stats: stats,
                          recentItems: allItems.take(3).toList(),
                          compact: true,
                        ),
                        const SizedBox(height: 14),
                        const _AyahRealtimeControlPanel(compact: true),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (snapshot.connectionState ==
                                        ConnectionState.waiting &&
                                    !snapshot.hasData)
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 14),
                                    child: LinearProgressIndicator(),
                                  ),
                                libraryContent,
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 360,
                          child: ListView(
                            children: [
                              _MediaStoragePanel(
                                stats: stats,
                                recentItems: allItems.take(3).toList(),
                              ),
                              const SizedBox(height: 14),
                              const _AyahRealtimeControlPanel(),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _MediaTabChip extends StatelessWidget {
  const _MediaTabChip(this.label, {this.active = false, this.onTap});

  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.green : const Color(0xFF12392A),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? const Color(0xFF032519) : const Color(0xFFA5C0B6),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _MediaItemCard extends StatelessWidget {
  const _MediaItemCard({
    required this.item,
    required this.onCopy,
    required this.onDelete,
    this.onUseForAyah,
  });

  final _MediaLibraryItem item;
  final VoidCallback onCopy;
  final VoidCallback onDelete;
  final VoidCallback? onUseForAyah;

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
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: item.thumbColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                  ),
                  child: item.isImage && item.url.isNotEmpty
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(14),
                          ),
                          child: Image.network(
                            item.url,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                  child: Icon(
                                    item.icon,
                                    color: AppColors.green,
                                    size: 42,
                                  ),
                                ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            item.icon,
                            color: AppColors.green,
                            size: 42,
                          ),
                        ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: PopupMenuButton<String>(
                    color: const Color(0xFF12392A),
                    onSelected: (value) {
                      if (value == 'copy') {
                        onCopy();
                      } else if (value == 'ayah') {
                        onUseForAyah?.call();
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'copy',
                        child: Text('Copy URL'),
                      ),
                      if (item.isImage || item.isAudio)
                        PopupMenuItem(
                          value: 'ayah',
                          child: Text(
                            item.isImage
                                ? 'Use for Ayah Image'
                                : 'Use for Ayah Audio',
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                    icon: const Icon(
                      Icons.more_vert,
                      color: AppColors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.metaLine,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F3427),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          item.category,
                          style: const TextStyle(
                            color: AppColors.green,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        item.formatLabel,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if ((item.isImage || item.isAudio) &&
                      onUseForAyah != null) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: onUseForAyah,
                        icon: Icon(
                          item.isImage
                              ? Icons.auto_awesome_outlined
                              : Icons.audiotrack,
                          size: 16,
                        ),
                        label: Text(
                          item.isImage
                              ? 'Use for Ayah Image'
                              : 'Use for Ayah Audio',
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.green,
                          side: const BorderSide(color: AppColors.strokeBright),
                        ),
                      ),
                    ),
                  ],
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
  const _MediaStoragePanel({
    required this.stats,
    required this.recentItems,
    this.compact = false,
  });

  final _MediaStats stats;
  final List<_MediaLibraryItem> recentItems;
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
          Row(
            children: [
              const Icon(
                Icons.storage_rounded,
                color: AppColors.green,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Storage Statistics',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: compact ? 22 : 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TOTAL USAGE',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .8,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      stats.totalLabel,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: compact ? 28 : 38,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      stats.progressLabel,
                      style: const TextStyle(
                        color: Color(0xFFE2C64A),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _AnimatedBar(progress: stats.progress, color: AppColors.green),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _StorageMiniCard(
                  label: 'AUDIO FILES',
                  value: stats.audioLabel,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StorageMiniCard(
                  label: 'VIDEO LESSONS',
                  value: stats.videoLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _StorageMiniCard(
                  label: 'IMAGE FILES',
                  value: stats.imageLabel,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StorageMiniCard(
                  label: 'DOCUMENT FILES',
                  value: stats.documentLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Recent Uploads',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          if (recentItems.isEmpty)
            const Text(
              'No recent uploads yet.',
              style: TextStyle(color: AppColors.muted, fontSize: 13),
            )
          else
            for (var i = 0; i < recentItems.length; i++) ...[
              _RecentUploadRow(item: recentItems[i]),
              if (i != recentItems.length - 1) const SizedBox(height: 8),
            ],
          if (compact) const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _AyahRealtimeControlPanel extends StatefulWidget {
  const _AyahRealtimeControlPanel({this.compact = false});

  final bool compact;

  @override
  State<_AyahRealtimeControlPanel> createState() =>
      _AyahRealtimeControlPanelState();
}

class _AyahRealtimeControlPanelState extends State<_AyahRealtimeControlPanel> {
  final _titleCtl = TextEditingController();
  final _imageUrlCtl = TextEditingController();
  final _arabicCtl = TextEditingController();
  final _translationCtl = TextEditingController();
  final _referenceCtl = TextEditingController();
  final _audioUrlCtl = TextEditingController();
  final _cloudNameCtl = TextEditingController();
  final _uploadPresetCtl = TextEditingController();
  final _folderCtl = TextEditingController(text: 'ayah_of_the_day');

  bool _isSaving = false;
  bool _isUploading = false;
  bool _isDeleting = false;
  bool _isHydrating = false;
  bool _isDirty = false;
  bool _isExpanded = false;
  String _lastFingerprint = '';

  DocumentReference<Map<String, dynamic>> get _docRef => FirebaseFirestore
      .instance
      .collection('home_content')
      .doc('ayah_of_the_day');

  @override
  void initState() {
    super.initState();
    for (final ctl in [
      _titleCtl,
      _imageUrlCtl,
      _arabicCtl,
      _translationCtl,
      _referenceCtl,
      _audioUrlCtl,
      _cloudNameCtl,
      _uploadPresetCtl,
      _folderCtl,
    ]) {
      ctl.addListener(_markDirty);
    }
    _refreshAyahFromServer();
  }

  Future<void> _refreshAyahFromServer() async {
    try {
      final snapshot = await _docRef.get(GetOptions(source: Source.server));
      if (!mounted || !snapshot.exists) return;
      final data = snapshot.data();
      if (data == null) return;
      final fingerprint = _fingerprint(data);
      if (fingerprint == _lastFingerprint) return;
      _lastFingerprint = fingerprint;
      _hydrateFromDoc(data);
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      // Keep the existing stream behavior; this is a best-effort server refresh.
      debugPrint('Could not refresh Ayah from server: $e');
    }
  }

  @override
  void dispose() {
    _titleCtl.dispose();
    _imageUrlCtl.dispose();
    _arabicCtl.dispose();
    _translationCtl.dispose();
    _referenceCtl.dispose();
    _audioUrlCtl.dispose();
    _cloudNameCtl.dispose();
    _uploadPresetCtl.dispose();
    _folderCtl.dispose();
    super.dispose();
  }

  void _markDirty() {
    if (_isHydrating || _isDirty) return;
    setState(() => _isDirty = true);
  }

  String _fingerprint(Map<String, dynamic> data) {
    return [
      data['title'] ?? '',
      data['imageUrl'] ?? '',
      data['arabic'] ?? '',
      data['translation'] ?? '',
      data['reference'] ?? '',
      data['audioUrl'] ?? '',
      data['cloudinaryCloudName'] ?? '',
      data['cloudinaryUploadPreset'] ?? '',
      data['cloudinaryFolder'] ?? '',
    ].join('||');
  }

  void _hydrateFromDoc(Map<String, dynamic> data) {
    _isHydrating = true;
    _titleCtl.text = (data['title'] as String?) ?? 'Ayah of the Day';
    _imageUrlCtl.text = (data['imageUrl'] as String?) ?? '';
    _arabicCtl.text = (data['arabic'] as String?) ?? '';
    _translationCtl.text = (data['translation'] as String?) ?? '';
    _referenceCtl.text = (data['reference'] as String?) ?? '';
    _audioUrlCtl.text = (data['audioUrl'] as String?) ?? '';
    _cloudNameCtl.text = (data['cloudinaryCloudName'] as String?) ?? '';
    _uploadPresetCtl.text = (data['cloudinaryUploadPreset'] as String?) ?? '';
    _folderCtl.text =
        (data['cloudinaryFolder'] as String?) ?? 'ayah_of_the_day';
    _isHydrating = false;
    _isDirty = false;
  }

  Future<void> _seedDefaultAyah() async {
    setState(() => _isSaving = true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_admin';
      await _docRef.set({
        'title': 'Ayah of the Day',
        'imageUrl':
            'https://deih43ym53wif.cloudfront.net/blue-mosque-glorius-sunset-istanbul-sultan-ahmed-turkey-shutterstock_174067919.jpg_1404e76369.jpg',
        'arabic': 'وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ',
        'translation': 'Indeed, I am near.',
        'reference': 'Surah Al-Baqarah 2:186',
        'audioUrl':
            'https://everyayah.com/data/English/Sahih_Intnl_Ibrahim_Walk_192kbps/002009.mp3',
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': uid,
      }, SetOptions(merge: true));
      if (!mounted) return;
      setState(() => _isDirty = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Default Ayah content synced to the live app.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not seed default Ayah: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _saveAyah() async {
    setState(() => _isSaving = true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_admin';
      final title = _titleCtl.text.trim();
      final imageUrl = _imageUrlCtl.text.trim();
      final arabic = _arabicCtl.text.trim();
      final translation = _translationCtl.text.trim();
      final reference = _referenceCtl.text.trim();
      final audioUrl = _audioUrlCtl.text.trim();
      final folder = _folderCtl.text.trim();

      await _docRef.set({
        'title': title.isEmpty ? 'Ayah of the Day' : title,
        'imageUrl': imageUrl.isEmpty ? FieldValue.delete() : imageUrl,
        'arabic': arabic.isEmpty ? FieldValue.delete() : arabic,
        'translation': translation.isEmpty ? FieldValue.delete() : translation,
        'reference': reference.isEmpty ? FieldValue.delete() : reference,
        'audioUrl': audioUrl.isEmpty ? FieldValue.delete() : audioUrl,
        'cloudinaryCloudName': _cloudNameCtl.text.trim(),
        'cloudinaryUploadPreset': _uploadPresetCtl.text.trim(),
        'cloudinaryFolder': folder.isEmpty ? 'ayah_of_the_day' : folder,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': uid,
      }, SetOptions(merge: true));

      if (!mounted) return;
      setState(() => _isDirty = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ayah title, Arabic, translation, image, and audio are now live.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save Ayah content: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _uploadAssetToCloudinary({
    required FileType fileType,
    required String targetField,
    required String publicIdField,
    required String assetLabel,
  }) async {
    final cloudName = _cloudNameCtl.text.trim();
    final uploadPreset = _uploadPresetCtl.text.trim();
    if (cloudName.isEmpty || uploadPreset.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter Cloudinary cloud name and upload preset first.'),
        ),
      );
      return;
    }

    setState(() => _isUploading = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: fileType,
        withData: true,
        allowMultiple: false,
      );
      if (!mounted) return;
      if (result == null || result.files.isEmpty) return;

      final file = result.files.single;
      final bytes = file.bytes;
      if (bytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not read selected $assetLabel file.')),
        );
        return;
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/auto/upload'),
      )..fields['upload_preset'] = uploadPreset;

      final folder = _folderCtl.text.trim();
      if (folder.isNotEmpty) {
        request.fields['folder'] = folder;
      }

      request.files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: file.name),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Cloudinary upload failed: $responseBody');
      }

      final decoded = jsonDecode(responseBody);
      if (decoded is! Map<String, dynamic>) {
        throw Exception('Unexpected Cloudinary response: $responseBody');
      }

      final secureUrl = decoded['secure_url'] as String?;
      final publicId = decoded['public_id'] as String?;
      if (secureUrl == null || secureUrl.isEmpty) {
        throw Exception('Cloudinary did not return a secure URL.');
      }

      if (targetField == 'imageUrl') {
        _imageUrlCtl.text = secureUrl;
      } else if (targetField == 'audioUrl') {
        _audioUrlCtl.text = secureUrl;
      }

      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_admin';
      await _docRef.set({
        targetField: secureUrl,
        publicIdField: publicId,
        'cloudinaryCloudName': cloudName,
        'cloudinaryUploadPreset': uploadPreset,
        'cloudinaryFolder': folder.isEmpty ? 'ayah_of_the_day' : folder,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': uid,
      }, SetOptions(merge: true));

      if (!mounted) return;
      setState(() => _isDirty = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$assetLabel uploaded and applied live.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_readableCloudinaryUploadMessage(e)),
          duration: const Duration(seconds: 8),
        ),
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _removeField({
    required String fieldName,
    required TextEditingController controller,
    required String successMessage,
    String? publicIdField,
  }) async {
    setState(() => _isDeleting = true);
    try {
      controller.clear();
      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_admin';
      await _docRef.set({
        fieldName: FieldValue.delete(),
        if (publicIdField != null && publicIdField.isNotEmpty)
          publicIdField: FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': uid,
      }, SetOptions(merge: true));
      if (!mounted) return;
      setState(() => _isDirty = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(successMessage)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not update Ayah field: $e')),
      );
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  InputDecoration _inputDecoration(String label, {String? helperText}) {
    return InputDecoration(
      labelText: label,
      helperText: helperText,
      labelStyle: const TextStyle(color: AppColors.muted),
      helperStyle: const TextStyle(color: AppColors.muted, fontSize: 11),
      filled: true,
      fillColor: const Color(0xFF0F3427),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.stroke),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.stroke),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.strokeBright),
      ),
    );
  }

  Widget _statusChip(String label, {Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3427),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor ?? AppColors.green,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _docRef.snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() ?? <String, dynamic>{};
        final fingerprint = _fingerprint(data);
        if (!_isDirty && fingerprint != _lastFingerprint) {
          _lastFingerprint = fingerprint;
          _hydrateFromDoc(data);
        }

        final updatedAt = (data['updatedAt'] as Timestamp?)?.toDate();
        final updatedBy = (data['updatedBy'] as String?) ?? 'Unknown admin';
        final previewImage = _imageUrlCtl.text.trim();

        return Container(
          padding: EdgeInsets.all(widget.compact ? 14 : 16),
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
                  Icon(Icons.tune_rounded, color: AppColors.green, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ayah Realtime Control',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Control the live Ayah image, Arabic text, translation, reference, and audio URL from this panel.',
                style: TextStyle(color: AppColors.muted, height: 1.4),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.tune_rounded,
                    size: 18,
                  ),
                  label: Text(
                    _isExpanded
                        ? 'Hide Realtime Controls'
                        : 'Open Realtime Controls',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.green,
                    side: const BorderSide(color: AppColors.strokeBright),
                  ),
                ),
              ),
              if (_isExpanded) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _statusChip(
                      snapshot.hasError
                          ? 'Connection issue'
                          : snapshot.data?.exists == true
                          ? 'Live connected'
                          : 'Ready to create',
                      textColor: snapshot.hasError
                          ? const Color(0xFFFFB4B4)
                          : AppColors.green,
                    ),
                    if (updatedAt != null)
                      _statusChip('Updated ${_relativeTime(updatedAt)}'),
                    _statusChip(
                      updatedBy.length > 18
                          ? '${updatedBy.substring(0, 18)}…'
                          : updatedBy,
                      textColor: AppColors.white,
                    ),
                  ],
                ),
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) ...[
                  const SizedBox(height: 12),
                  const LinearProgressIndicator(),
                ],
                if (snapshot.hasError) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Realtime load failed: ${snapshot.error}',
                    style: const TextStyle(color: Color(0xFFFFB4B4)),
                  ),
                ],
                const SizedBox(height: 12),
                TextFormField(
                  controller: _titleCtl,
                  style: const TextStyle(color: AppColors.white),
                  cursorColor: AppColors.green,
                  decoration: _inputDecoration(
                    'Title',
                    helperText: 'Displayed on the live home card',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _referenceCtl,
                  style: const TextStyle(color: AppColors.white),
                  cursorColor: AppColors.green,
                  decoration: _inputDecoration(
                    'Reference',
                    helperText: 'Example: Surah Al-Baqarah 2:186',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _arabicCtl,
                  maxLines: 3,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(color: AppColors.white, height: 1.6),
                  cursorColor: AppColors.green,
                  decoration: _inputDecoration(
                    'Arabic Ayah',
                    helperText: 'This text updates in realtime in the app',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _translationCtl,
                  maxLines: 3,
                  style: const TextStyle(color: AppColors.white, height: 1.5),
                  cursorColor: AppColors.green,
                  decoration: _inputDecoration(
                    'Translation',
                    helperText: 'Control the live translation text',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _imageUrlCtl,
                  style: const TextStyle(color: AppColors.white),
                  cursorColor: AppColors.green,
                  decoration: _inputDecoration(
                    'Image URL',
                    helperText: 'Paste a direct image link or upload below',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _audioUrlCtl,
                  style: const TextStyle(color: AppColors.white),
                  cursorColor: AppColors.green,
                  decoration: _inputDecoration(
                    'Audio URL',
                    helperText: 'Paste a direct audio link or upload below',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _cloudNameCtl,
                  style: const TextStyle(color: AppColors.white),
                  cursorColor: AppColors.green,
                  decoration: _inputDecoration('Cloudinary Cloud Name'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _uploadPresetCtl,
                  style: const TextStyle(color: AppColors.white),
                  cursorColor: AppColors.green,
                  decoration: _inputDecoration(
                    'Cloudinary Upload Preset',
                    helperText: 'Use your unsigned preset for uploads',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _folderCtl,
                  style: const TextStyle(color: AppColors.white),
                  cursorColor: AppColors.green,
                  decoration: _inputDecoration('Cloudinary Folder'),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F3427),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.stroke),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Live Preview',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (previewImage.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            previewImage,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: 80,
                                  alignment: Alignment.center,
                                  color: const Color(0x12000000),
                                  child: const Text(
                                    'Preview unavailable',
                                    style: TextStyle(color: AppColors.muted),
                                  ),
                                ),
                          ),
                        )
                      else
                        Container(
                          height: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0x110B6B46),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'No image selected yet',
                            style: TextStyle(color: AppColors.muted),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Text(
                        _titleCtl.text.trim().isEmpty
                            ? 'Ayah of the Day'
                            : _titleCtl.text.trim(),
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _arabicCtl.text.trim().isEmpty
                            ? 'Arabic ayah preview will appear here.'
                            : _arabicCtl.text.trim(),
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 17,
                          height: 1.6,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _translationCtl.text.trim().isEmpty
                            ? 'Translation preview will appear here.'
                            : _translationCtl.text.trim(),
                        style: const TextStyle(
                          color: AppColors.muted,
                          height: 1.4,
                        ),
                      ),
                      if (_referenceCtl.text.trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          _referenceCtl.text.trim(),
                          style: const TextStyle(
                            color: AppColors.green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        _audioUrlCtl.text.trim().isEmpty
                            ? 'No audio URL linked yet'
                            : 'Audio URL is connected and will play in realtime',
                        style: const TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      onPressed: _isSaving ? null : _saveAyah,
                      icon: const Icon(Icons.save_outlined, size: 18),
                      label: Text(
                        _isSaving ? 'Saving...' : 'Save Live Changes',
                      ),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: _refreshAyahFromServer,
                      icon: const Icon(Icons.refresh_outlined, size: 18),
                      label: const Text('Refresh from Server'),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: _isUploading
                          ? null
                          : () => _uploadAssetToCloudinary(
                              fileType: FileType.image,
                              targetField: 'imageUrl',
                              publicIdField: 'imagePublicId',
                              assetLabel: 'Image',
                            ),
                      icon: const Icon(Icons.image_outlined, size: 18),
                      label: Text(
                        _isUploading ? 'Uploading...' : 'Upload Image',
                      ),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: _isUploading
                          ? null
                          : () => _uploadAssetToCloudinary(
                              fileType: FileType.audio,
                              targetField: 'audioUrl',
                              publicIdField: 'audioPublicId',
                              assetLabel: 'Audio',
                            ),
                      icon: const Icon(Icons.audiotrack, size: 18),
                      label: const Text('Upload Audio'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _isDeleting
                          ? null
                          : () => _removeField(
                              fieldName: 'imageUrl',
                              controller: _imageUrlCtl,
                              publicIdField: 'imagePublicId',
                              successMessage:
                                  'Image removed from live Ayah card.',
                            ),
                      icon: const Icon(
                        Icons.image_not_supported_outlined,
                        size: 18,
                      ),
                      label: const Text('Remove Image'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _isDeleting
                          ? null
                          : () => _removeField(
                              fieldName: 'audioUrl',
                              controller: _audioUrlCtl,
                              publicIdField: 'audioPublicId',
                              successMessage:
                                  'Audio removed from live Ayah card.',
                            ),
                      icon: const Icon(Icons.music_off_outlined, size: 18),
                      label: const Text('Remove Audio'),
                    ),
                    OutlinedButton.icon(
                      onPressed: (_isSaving || _isDeleting)
                          ? null
                          : _seedDefaultAyah,
                      icon: const Icon(Icons.auto_fix_high_outlined, size: 18),
                      label: const Text('Seed Default'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _isDirty ? 'Unsaved local edits' : 'Synced with Firestore',
                  style: TextStyle(
                    color: _isDirty ? const Color(0xFFFFB4B4) : AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        );
      },
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
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentUploadRow extends StatelessWidget {
  const _RecentUploadRow({required this.item});

  final _MediaLibraryItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: item.thumbColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(item.icon, color: AppColors.green, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Uploaded by ${item.uploadedBy} • ${item.timeLabel}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MediaFeedbackCard extends StatelessWidget {
  const _MediaFeedbackCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF12392A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Text(
        message,
        style: const TextStyle(color: AppColors.white, height: 1.45),
      ),
    );
  }
}

class _MediaLibraryItem {
  const _MediaLibraryItem({
    required this.id,
    required this.title,
    required this.category,
    required this.url,
    required this.publicId,
    required this.sizeBytes,
    required this.uploadedBy,
    required this.uploadedAt,
    required this.format,
  });

  factory _MediaLibraryItem.fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    final resourceType = (data['resourceType'] as String?) ?? '';
    final rawCategory = (data['category'] as String?) ?? resourceType;
    return _MediaLibraryItem(
      id: doc.id,
      title: (data['title'] as String?) ?? 'Untitled media',
      category: _normalizeCategory(rawCategory),
      url: (data['url'] as String?) ?? '',
      publicId: (data['publicId'] as String?) ?? '',
      sizeBytes: (data['sizeBytes'] as num?)?.round() ?? 0,
      uploadedBy: (data['uploadedBy'] as String?) ?? 'Unknown admin',
      uploadedAt: (data['uploadedAt'] as Timestamp?)?.toDate(),
      format: ((data['format'] as String?) ?? '').trim(),
    );
  }

  final String id;
  final String title;
  final String category;
  final String url;
  final String publicId;
  final int sizeBytes;
  final String uploadedBy;
  final DateTime? uploadedAt;
  final String format;

  bool get isImage => category == 'Images';
  bool get isAudio => category == 'Audio';

  IconData get icon {
    switch (category) {
      case 'Audio':
        return Icons.volume_up_rounded;
      case 'Video':
        return Icons.play_circle_fill_rounded;
      case 'Images':
        return Icons.image_outlined;
      case 'Documents':
        return format.toLowerCase() == 'pdf'
            ? Icons.picture_as_pdf_rounded
            : Icons.insert_drive_file_rounded;
      default:
        return Icons.perm_media_rounded;
    }
  }

  Color get thumbColor {
    switch (category) {
      case 'Audio':
        return const Color(0xFF0F2D42);
      case 'Video':
        return const Color(0xFF354949);
      case 'Images':
        return const Color(0xFF304E43);
      case 'Documents':
        return const Color(0xFF3A3E30);
      default:
        return const Color(0xFF213D44);
    }
  }

  String get metaLine => '${_formatBytes(sizeBytes)} • ${timeLabel}';

  String get timeLabel => _relativeTime(uploadedAt);

  String get formatLabel =>
      format.isEmpty ? category.toUpperCase() : format.toUpperCase();

  static String _normalizeCategory(String raw) {
    switch (raw.toLowerCase()) {
      case 'audio':
        return 'Audio';
      case 'video':
        return 'Video';
      case 'image':
      case 'images':
        return 'Images';
      case 'document':
      case 'documents':
      case 'raw':
      default:
        return 'Documents';
    }
  }
}

class _MediaStats {
  const _MediaStats({
    required this.totalBytes,
    required this.audioBytes,
    required this.videoBytes,
    required this.imageBytes,
    required this.documentBytes,
  });

  factory _MediaStats.fromItems(List<_MediaLibraryItem> items) {
    var audio = 0;
    var video = 0;
    var image = 0;
    var document = 0;

    for (final item in items) {
      switch (item.category) {
        case 'Audio':
          audio += item.sizeBytes;
          break;
        case 'Video':
          video += item.sizeBytes;
          break;
        case 'Images':
          image += item.sizeBytes;
          break;
        case 'Documents':
          document += item.sizeBytes;
          break;
      }
    }

    return _MediaStats(
      totalBytes: audio + video + image + document,
      audioBytes: audio,
      videoBytes: video,
      imageBytes: image,
      documentBytes: document,
    );
  }

  final int totalBytes;
  final int audioBytes;
  final int videoBytes;
  final int imageBytes;
  final int documentBytes;

  double get progress {
    if (totalBytes <= 0) return 0;
    return (totalBytes / _kMediaStorageCapacityBytes).clamp(0.0, 1.0);
  }

  String get totalLabel => _formatBytes(totalBytes);
  String get audioLabel => _formatBytes(audioBytes);
  String get videoLabel => _formatBytes(videoBytes);
  String get imageLabel => _formatBytes(imageBytes);
  String get documentLabel => _formatBytes(documentBytes);
  String get progressLabel =>
      '${(progress * 100).toStringAsFixed(0)}% of 200GB';
}

String _formatBytes(int bytes) {
  if (bytes <= 0) return '0 B';
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  var value = bytes.toDouble();
  var unitIndex = 0;
  while (value >= 1024 && unitIndex < units.length - 1) {
    value /= 1024;
    unitIndex++;
  }
  final fractionDigits = value >= 100 || unitIndex == 0 ? 0 : 1;
  return '${value.toStringAsFixed(fractionDigits)} ${units[unitIndex]}';
}

String _relativeTime(DateTime? dateTime) {
  if (dateTime == null) return 'just now';
  final diff = DateTime.now().difference(dateTime);
  if (diff.inSeconds < 60) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
}
