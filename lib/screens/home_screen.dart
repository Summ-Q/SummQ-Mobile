import 'package:flutter/material.dart';
import 'package:mobile_flutter/screens/Deck_fromPDF.dart';
import 'package:mobile_flutter/screens/paste_note.dart';
import 'package:mobile_flutter/screens/searchDeck_screen.dart';
import 'package:mobile_flutter/screens/setting_screen.dart';
import 'package:mobile_flutter/screens/study_flashcards.dart';
import 'package:mobile_flutter/models/flashcard_model.dart';
import '../cubit/stats_controller.dart';
import '../providers/Auth_provider.dart';
import '../providers/Deck_provider.dart';
import '../server/Api.dart';
import '../theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DeckProvider>().fetchDecks();
    });
  }

  Future<void> _refreshDecks() async {
    await context.read<DeckProvider>().fetchDecks();

    final decksCount = context.read<DeckProvider>().decks.length;
    StatsController.instance.setDecksCreated(decksCount);
  }


  Future<void> _deleteDeck(DeckData deck) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cream,
        title: const Text('Delete Deck'),
        content: Text('Are you sure you want to delete "${deck.title}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final success = await context.read<DeckProvider>().deleteDeck(deck.id);
    if (!mounted) return;

    if (success) {
      final decksCount = context.read<DeckProvider>().decks.length;
      StatsController.instance.setDecksCreated(decksCount);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deck deleted')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete deck')),
      );
    }
  }

  Future<void> _openDeck(DeckData deck) async {
    try {
      final cards = await ApiService().getCardsForDeck(deck.id);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudyFlashcard(
            deckTitle: deck.title,
            flashcards: cards,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load cards: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final String userName = authProvider.currentUser?.name ?? 'User';
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
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const SettingsScreen(),),);
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
                      style: GoogleFonts.openSans(textStyle: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold), color: AppColors.subtitleGrey),
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
                              value: '${StatsController.instance.studiedDecksCount}',
                              label: 'studied decks',
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
                                color: AppColors.subtitleGrey,
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
                            child: const _IconCard(color: AppColors.lightBlue, icon: Icons.edit_note_rounded)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: GestureDetector(
                            onTap: () {
                              showDeckModal(context);
                            },
                            child: const _IconCard(color: AppColors.yellowCard, icon: Icons.note_add_rounded)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Text('Your Decks', style: appFont(color:AppColors.cream, size: 20, weight: FontWeight.bold)),
                  const SizedBox(height: 14),

                  Consumer<DeckProvider>(
                    builder: (context, deckProvider, child) {
                      if (deckProvider.isLoading) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Center(child: CircularProgressIndicator(color: AppColors.yellowLink)),
                        );
                      }

                      if (deckProvider.decks.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Center(child: Text("No decks yet. Create one!", style: TextStyle(color: Colors.white54))),
                        );
                      }

                      return Column(
                        children: deckProvider.decks.map((deck) {
                          final deckData = DeckData(
                            id: deck.id,
                            title: deck.title,
                            subtitle: 'Created at ${deck.createdAt.day}/${deck.createdAt.month}',
                            progress: 'Ready',
                          );
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: GestureDetector(
                              onTap: () => _openDeck(deckData),
                                child: _DeckCard(
                                  data: deckData,
                                  onDelete: () => _deleteDeck(deckData),
                                ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ));
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
  final VoidCallback? onDelete;
  const _DeckCard({required this.data, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(16)),
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
          Row(
            children: [
              //Text(data.progress, style: appFont(size: 15, weight: FontWeight.w700, color: Colors.white)),
              if (onDelete != null) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onDelete,
                  child: const Icon(Icons.delete_outline, color: Colors.white70, size: 22),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}