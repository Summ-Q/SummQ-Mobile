import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/decks_model.dart';
import '../server/Api.dart';

class StudyScreen extends StatelessWidget {
  final int deckId;

  const StudyScreen({super.key, required this.deckId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudyCubit()..fetchStudyItems(deckId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Daily revision')),
        body: BlocBuilder<StudyCubit, StudyState>(
          builder: (context, state) {
            if (state is StudyLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StudyError) {
              return Center(child: Text(state.message));
            } else if (state is StudyLoaded) {
              return ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(state.items[index].title),
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

abstract class StudyState {}
class StudyInitial extends StudyState {}
class StudyLoading extends StudyState {}
class StudyLoaded extends StudyState {
  final List<DeckModel> items;
  StudyLoaded(this.items);
}
class StudyError extends StudyState {
  final String message;
  StudyError(this.message);
}

class StudyCubit extends Cubit<StudyState> {
  final ApiService apiService = ApiService();

  StudyCubit() : super(StudyInitial());

  void fetchStudyItems(int deckId) async {
    emit(StudyLoading());
    try {
      final items = await apiService.getStudyDecks(deckId);
      emit(StudyLoaded(items));
    } catch (e) {
      emit(StudyError(e.toString()));
    }
  }
}