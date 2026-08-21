import 'package:flutter/material.dart';
import 'package:mobile_flutter/screens/study_flashcards.dart';
import 'package:provider/provider.dart';
import '../providers/Deck_provider.dart';
import '../server/Api.dart';
import '../theme.dart';
import 'home_screen.dart';

class SearchForDeck extends StatefulWidget {
  const SearchForDeck({super.key});

  @override
  State<SearchForDeck> createState() => _SearchForDeckState();
}

class _SearchForDeckState extends State<SearchForDeck> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DeckProvider>().fetchDecks();
    });

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _query = _searchController.text.trim().toLowerCase();
    });
  }

  void _clearSearch() {
    _searchController.clear();
  }

  List<DeckData> _toDeckData(List decks) {
    return decks
        .map((deck) => DeckData(
      id: deck.id,
      title: deck.title,
      subtitle: 'Created ${deck.createdAt.day}/${deck.createdAt.month}',
      progress: 'Ready',
    ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Search Decks",
          style: appFont(size: 20, weight: FontWeight.w700, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBox(),
              const SizedBox(height: 20),
              Expanded(child: _buildDeckList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.greyCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _searchController,
        style: appFont(size: 15, weight: FontWeight.w500, color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search decks...',
          hintStyle: appFont(size: 15, weight: FontWeight.w500, color: AppColors.subtitleGrey),
          prefixIcon: const Icon(Icons.search, color: AppColors.subtitleGrey),
          suffixIcon: _searchController.text.isEmpty
              ? null
              : IconButton(
            icon: const Icon(Icons.close, color: AppColors.subtitleGrey),
            onPressed: _clearSearch,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildDeckList() {
    return Consumer<DeckProvider>(
      builder: (context, deckProvider, child) {
        if (deckProvider.isLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.yellowLink));
        }

        final allDecks = _toDeckData(deckProvider.decks);
        final filteredDecks = _query.isEmpty
            ? allDecks
            : allDecks
            .where((deck) =>
        deck.title.toLowerCase().contains(_query) ||
            deck.subtitle.toLowerCase().contains(_query))
            .toList();

        if (filteredDecks.isEmpty) {
          return Center(
            child: Text(
              _query.isEmpty ? "No decks yet." : 'No decks match "$_query"',
              textAlign: TextAlign.center,
              style: appFont(size: 15, weight: FontWeight.w500, color: AppColors.subtitleGrey),
            ),
          );
        }

        return ListView.separated(
          itemCount: filteredDecks.length,
          separatorBuilder: (context, index) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final deck = filteredDecks[index];
            return GestureDetector(
              onTap: () async {
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
              },
              child: _SearchDeckCard(data: deck),
            );
          },
        );
      },
    );
  }
}

class _SearchDeckCard extends StatelessWidget {
  final DeckData data;
  const _SearchDeckCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.title, style: appFont(size: 17, weight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 4),
                Text(data.subtitle, style: appFont(size: 13, weight: FontWeight.w500, color: AppColors.navy)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          //Text(data.progress, style: appFont(size: 15, weight: FontWeight.w700, color: Colors.white)),
        ],
      ),
    );
  }
}