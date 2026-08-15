import 'package:flutter/material.dart';
import 'package:mobile_flutter/screens/Deck_fromPDF.dart';
import 'package:mobile_flutter/screens/paste_note.dart';
import 'package:mobile_flutter/screens/searchDeck_screen.dart';
import 'package:mobile_flutter/screens/setting_screen.dart';
import 'package:mobile_flutter/screens/study_flashcards.dart';
import 'package:mobile_flutter/models/flashcard_model.dart';
import '../cubit/stats_controller.dart';
import '../theme.dart';
import 'package:google_fonts/google_fonts.dart';

class DeckRepository {
  static Future<List<DeckData>> fetchDecks() async {
    await Future.delayed(const Duration(milliseconds: 400)); // simulate network
    return const [
      DeckData(id: 1, title: 'logic', subtitle: 'Fundamentals of ...', progress: '12/30'),
      DeckData(id: 2, title: 'Hardware', subtitle: 'Fundamentals of ...', progress: '10/12'),
      DeckData(id: 2, title: 'Math3', subtitle: 'Fundamentals of ...', progress: '0/10'),
      DeckData(id: 2, title: 'physics', subtitle: 'Fundamentals of ...', progress: '0/10'),
    ];
  }

  static List<FlashcardModel> mockCardsFor(DeckData deck) {
    return List.generate(10, (i) => FlashcardModel(
        id: i,
        deckId: deck.id,
        question: 'Sample question ${i + 1} for "${deck.title}"',
        answer: 'Sample answer ${i + 1}',
        difficultyLevel: 'medium',
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final String userName = 'mai';
  late Future<List<DeckData>> _decksFuture;

  @override
  void initState() {
    super.initState();
    _decksFuture = DeckRepository.fetchDecks().then((decks) {
      StatsController.instance.setDecksCreated(decks.length);
      return decks;
    });
  }

  Future<void> _refreshDecks() async {
    setState(() {
      _decksFuture = DeckRepository.fetchDecks().then((decks) {
        StatsController.instance.setDecksCreated(decks.length);
        return decks;
      });
    });
    await _decksFuture;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        child: RefreshIndicator(
          onRefresh: _refreshDecks,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => SettingsScreen(),),);
                      },
                      child: const Icon(Icons.settings_outlined, color: Colors.white, size: 26),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    "Let's get things done\n together ✨",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 20), color: AppColors.grayOrange),
                  ),
                ),
                const SizedBox(height: 30),
                ListenableBuilder(
                  listenable: StatsController.instance,
                  builder: (context, _) {
                    return Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            color: AppColors.greyCard,
                            value: '${StatsController.instance.studiedCards}',
                            label: 'studied cards',
                            textColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SearchForDeck()),
                                );
                              },
                              child: _StatCard(
                                color: AppColors.greyCard,
                                value: '${StatsController.instance.decksCreated}',
                                label: 'Deck created',
                                textColor: AppColors.navy,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PasteScreen()),
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
                Text('Your Decks', style: GoogleFonts.poppins( color:AppColors.cream)),
                const SizedBox(height: 14),
                FutureBuilder<List<DeckData>>(
                  future: _decksFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(child: CircularProgressIndicator(color: AppColors.yellowLink)),
                      );
                    }

                    if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          "Couldn't load your decks. Pull down to try again.",
                          style: appFont(size: 14, weight: FontWeight.w500, color: AppColors.subtitleGrey),
                        ),
                      );
                    }

                    final decks = snapshot.data ?? [];

                    if (decks.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          "No decks yet — create one above to get started.",
                          style: appFont(size: 14, weight: FontWeight.w500, color: AppColors.subtitleGrey),
                        ),
                      );
                    }

                    return Column(
                      children:
                      decks.map((d) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudyFlashcard(
                                  deckTitle: d.title,
                                  flashcards: DeckRepository.mockCardsFor(d),
                                ),
                              ),
                            );
                          },
                          child: _DeckCard(data: d),
                        ),
                      ))
                          .toList(),
                    );
                  },
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeckData {
  final int id;
  final String title;
  final String subtitle;
  final String progress;
  const DeckData({required this.id, required this.title, required this.subtitle, required this.progress});
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
  final DeckData data;
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