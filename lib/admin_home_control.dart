import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminHomeControlScreen extends StatefulWidget {
  const AdminHomeControlScreen({super.key});

  @override
  State<AdminHomeControlScreen> createState() => _AdminHomeControlScreenState();
}

class _AdminHomeControlScreenState extends State<AdminHomeControlScreen> {
  final _firestore = FirebaseFirestore.instance;
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen Control Panel'),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedTab,
            onDestinationSelected: (index) {
              setState(() => _selectedTab = index);
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.access_time),
                label: Text('Prayer Card'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.book),
                label: Text('Ayah of Day'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.flag),
                label: Text('Weekly Goals'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: const [
                PrayerCardControl(),
                AyahOfDayControl(),
                WeeklyGoalsControl(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== PRAYER CARD CONTROL ====================
class PrayerCardControl extends StatefulWidget {
  const PrayerCardControl({super.key});

  @override
  State<PrayerCardControl> createState() => _PrayerCardControlState();
}

class _PrayerCardControlState extends State<PrayerCardControl> {
  final _formKey = GlobalKey<FormState>();
  final _prayerController = TextEditingController();
  final _countdownController = TextEditingController();
  final _timeController = TextEditingController();
  final _progressController = TextEditingController();

  @override
  void dispose() {
    _prayerController.dispose();
    _countdownController.dispose();
    _timeController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _updatePrayerCard() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await FirebaseFirestore.instance
          .collection('home_content')
          .doc('prayer_card')
          .set({
            'upcomingPrayerName': _prayerController.text,
            'countdown': _countdownController.text,
            'upcomingTime': _timeController.text,
            'dayProgress': double.parse(_progressController.text) / 100,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prayer card updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('home_content')
          .doc('prayer_card')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          _prayerController.text = data['upcomingPrayerName'] ?? '';
          _countdownController.text = data['countdown'] ?? '';
          _timeController.text = data['upcomingTime'] ?? '';
          _progressController.text = ((data['dayProgress'] ?? 0.0) * 100)
              .toStringAsFixed(0);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Prayer Card Settings',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _prayerController,
                  decoration: const InputDecoration(
                    labelText: 'Upcoming Prayer Name',
                    hintText: 'e.g., Maghrib',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _countdownController,
                  decoration: const InputDecoration(
                    labelText: 'Countdown',
                    hintText: 'e.g., 01:22:10',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _timeController,
                  decoration: const InputDecoration(
                    labelText: 'Upcoming Time',
                    hintText: 'e.g., 6:45 PM',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _progressController,
                  decoration: const InputDecoration(
                    labelText: 'Day Progress (%)',
                    hintText: 'e.g., 85',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v!.isEmpty) return 'Required';
                    final num = double.tryParse(v);
                    if (num == null || num < 0 || num > 100) {
                      return 'Enter 0-100';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _updatePrayerCard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                    ),
                    child: const Text('Update Prayer Card'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ==================== AYAH OF DAY CONTROL ====================
class AyahOfDayControl extends StatefulWidget {
  const AyahOfDayControl({super.key});

  @override
  State<AyahOfDayControl> createState() => _AyahOfDayControlState();
}

class _AyahOfDayControlState extends State<AyahOfDayControl> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _arabicController = TextEditingController();
  final _translationController = TextEditingController();
  final _referenceController = TextEditingController();
  final _audioUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshAyahFromServer();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    _arabicController.dispose();
    _translationController.dispose();
    _referenceController.dispose();
    _audioUrlController.dispose();
    super.dispose();
  }

  Future<void> _refreshAyahFromServer() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('home_content')
          .doc('ayah_of_the_day')
          .get(const GetOptions(source: Source.server));
      if (!mounted || !snapshot.exists) return;
      final data = snapshot.data();
      if (data == null) return;
      _titleController.text = data['title'] ?? '';
      _imageUrlController.text = data['imageUrl'] ?? '';
      _arabicController.text = data['arabic'] ?? '';
      _translationController.text = data['translation'] ?? '';
      _referenceController.text = data['reference'] ?? '';
      _audioUrlController.text = data['audioUrl'] ?? '';
    } catch (e) {
      debugPrint('Could not refresh Ayah from server: $e');
    }
  }

  Future<void> _updateAyah() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await FirebaseFirestore.instance
          .collection('home_content')
          .doc('ayah_of_the_day')
          .set({
            'title': _titleController.text,
            'imageUrl': _imageUrlController.text,
            'arabic': _arabicController.text,
            'translation': _translationController.text,
            'reference': _referenceController.text,
            'audioUrl': _audioUrlController.text,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ayah updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('home_content')
          .doc('ayah_of_the_day')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          _titleController.text = data['title'] ?? '';
          _imageUrlController.text = data['imageUrl'] ?? '';
          _arabicController.text = data['arabic'] ?? '';
          _translationController.text = data['translation'] ?? '';
          _referenceController.text = data['reference'] ?? '';
          _audioUrlController.text = data['audioUrl'] ?? '';
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ayah of the Day Settings',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _arabicController,
                  decoration: const InputDecoration(
                    labelText: 'Arabic Text',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _translationController,
                  decoration: const InputDecoration(
                    labelText: 'Translation',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _referenceController,
                  decoration: const InputDecoration(
                    labelText: 'Reference',
                    hintText: 'e.g., Surah Al-Baqarah 2:186',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _audioUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Audio URL',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _updateAyah,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                          ),
                          child: const Text('Update Ayah of the Day'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      onPressed: _refreshAyahFromServer,
                      icon: const Icon(Icons.refresh_outlined),
                      label: const Text('Refresh'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ==================== WEEKLY GOALS CONTROL ====================
class WeeklyGoalsControl extends StatelessWidget {
  const WeeklyGoalsControl({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('home_weekly_goals')
          .orderBy('order')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No goals found'));
        }

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              'Weekly Goals Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...snapshot.data!.docs.map((doc) {
              return GoalCard(
                goalId: doc.id,
                data: doc.data() as Map<String, dynamic>,
              );
            }),
          ],
        );
      },
    );
  }
}

class GoalCard extends StatefulWidget {
  final String goalId;
  final Map<String, dynamic> data;

  const GoalCard({super.key, required this.goalId, required this.data});

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  late TextEditingController _titleController;
  late TextEditingController _completedController;
  late TextEditingController _targetController;
  late TextEditingController _unitController;
  late String _selectedColor;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.data['title'] ?? '');
    _completedController = TextEditingController(
      text: (widget.data['completed'] ?? 0).toString(),
    );
    _targetController = TextEditingController(
      text: (widget.data['target'] ?? 0).toString(),
    );
    _unitController = TextEditingController(text: widget.data['unit'] ?? '');
    _selectedColor = widget.data['color'] ?? 'green';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _completedController.dispose();
    _targetController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _updateGoal() async {
    try {
      await FirebaseFirestore.instance
          .collection('home_weekly_goals')
          .doc(widget.goalId)
          .update({
            'title': _titleController.text,
            'completed': int.parse(_completedController.text),
            'target': int.parse(_targetController.text),
            'unit': _unitController.text,
            'color': _selectedColor,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Goal updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.goalId.toUpperCase(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _completedController,
                    decoration: const InputDecoration(
                      labelText: 'Completed',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _targetController,
                    decoration: const InputDecoration(
                      labelText: 'Target',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _unitController,
              decoration: const InputDecoration(
                labelText: 'Unit (optional)',
                hintText: 'e.g., p, d',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedColor,
              decoration: const InputDecoration(
                labelText: 'Color',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'green', child: Text('Green')),
                DropdownMenuItem(value: 'red', child: Text('Red')),
                DropdownMenuItem(value: 'amber', child: Text('Amber')),
              ],
              onChanged: (value) {
                setState(() => _selectedColor = value!);
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateGoal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                ),
                child: const Text('Update Goal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
