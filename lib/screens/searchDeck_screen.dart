import 'package:flutter/material.dart';
import 'package:mobile_flutter/screens/home_screen.dart';
import 'package:mobile_flutter/screens/study_flashcards.dart';
import '../theme.dart';

class SearchForDeck extends StatefulWidget {
  const SearchForDeck({super.key});

  @override
  State<SearchForDeck> createState() => _SearchForDeckState();
}

class _SearchForDeckState extends State<SearchForDeck> {
  final TextEditingController _searchController = TextEditingController();

  late Future<List<DeckData>> _decksFuture;
  List<DeckData> _allDecks = [];
  List<DeckData> _filteredDecks = [];
  String _query = '';

  @override
  void initState() {
    super.initState();
    _decksFuture = DeckRepository.fetchDecks().then((decks) {
      _allDecks = decks;
      _filteredDecks = decks;
      return decks;
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
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _query = query;
      _filteredDecks = query.isEmpty
          ? _allDecks
          : _allDecks.where((deck) {
        return deck.title.toLowerCase().contains(query) ||
            deck.subtitle.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _clearSearch() {
    _searchController.clear();
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
    return FutureBuilder<List<DeckData>>(
      future: _decksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.yellowLink));
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Couldn't load decks.",
              style: appFont(size: 14, weight: FontWeight.w500, color: AppColors.subtitleGrey),
            ),
          );
        }

        if (_filteredDecks.isEmpty) {
          return Center(
            child: Text(
              _query.isEmpty ? "No decks yet." : 'No decks match "$_query"',
              textAlign: TextAlign.center,
              style: appFont(size: 15, weight: FontWeight.w500, color: AppColors.subtitleGrey),
            ),
          );
        }

        return ListView.separated(
          itemCount: _filteredDecks.length,
          separatorBuilder: (context, index) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final deck = _filteredDecks[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudyFlashcard(
                      deckTitle: deck.title,
                      flashcards: DeckRepository.mockCardsFor(deck),
                    ),
                  ),
                );
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
      decoration: BoxDecoration(color: AppColors.greyCard, borderRadius: BorderRadius.circular(16)),
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
          Text(data.progress, style: appFont(size: 15, weight: FontWeight.w700, color: Colors.white)),
        ],
      ),
    );
  }
}