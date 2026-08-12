import 'package:flutter/material.dart';
import 'package:mobile_flutter/screens/Deck_fromPDF.dart';
import 'package:mobile_flutter/screens/paste_note.dart';
import 'package:mobile_flutter/screens/study_flashcards.dart';
import '../models/user_model.dart' as widget;
import '../theme.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  final String userName = 'mai';

  final List<_DeckData> decks = const [
    _DeckData(title: 'logic', subtitle: 'Fundamentals of ...', progress: '12/30'),
    _DeckData(title: 'Hardware', subtitle: 'Fundamentals of ...', progress: '10/12'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome back,',
                        style: appFont(size: 20, weight: FontWeight.w700, color: AppColors.yellowLink)),
                    Text(userName, style: appFont(size: 26, weight: FontWeight.w800, color: Colors.white)),
                  ],
                ),
                const Icon(Icons.settings_outlined, color: Colors.white, size: 26),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "Let's get things done together ✨",
                textAlign: TextAlign.center,
                style: appFont(size: 20, weight: FontWeight.w600, color: AppColors.subtitleGrey),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: _StatCard(color: AppColors.green, value: '23', label: 'studied cards', textColor: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _StatCard(color: AppColors.greyCard, value: '17', label: 'Deck created', textColor: AppColors.navy),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => pasteScreen()),
                        );
                      },
                      child: _IconCard(color: AppColors.lightBlue, icon: Icons.edit_note_rounded)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: GestureDetector(
                      onTap: () {
                        showDeckModal(context);
                      },
                      child: _IconCard(color: AppColors.yellowCard, icon: Icons.note_add_rounded)),
                ),
              ],
            ),
            const SizedBox(height: 26),
            Text('Your Decks', style: appFont(size: 20, weight: FontWeight.w700, color: Colors.white)),
            const SizedBox(height: 14),
            ...decks.map((d) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StudyFlashcard()),
                        );
                      },
                      child: _DeckCard(data: d)),
                )),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _DeckData {
  final String title;
  final String subtitle;
  final String progress;
  const _DeckData({required this.title, required this.subtitle, required this.progress});
}

class _StatCard extends StatelessWidget {
  final Color color;
  final String value;
  final String label;
  final Color textColor;

  const _StatCard({required this.color, required this.value, required this.label, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: appFont(size: 26, weight: FontWeight.w800, color: textColor)),
          const SizedBox(height: 4),
          Text(label, style: appFont(size: 14, weight: FontWeight.w600, color: textColor)),
        ],
      ),
    );
  }
}

class _IconCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  const _IconCard({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(18)),
      alignment: Alignment.center,
      child: Icon(icon, color: AppColors.navy, size: 26),
    );
  }
}

class _DeckCard extends StatelessWidget {
  final _DeckData data;
  const _DeckCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(color: AppColors.greyCard, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.title, style: appFont(size: 17, weight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 4),
              Text(data.subtitle, style: appFont(size: 13, weight: FontWeight.w500, color: AppColors.navy)),
            ],
          ),
          Text(data.progress, style: appFont(size: 15, weight: FontWeight.w700, color: Colors.white)),
        ],
      ),
    );
  }
}
