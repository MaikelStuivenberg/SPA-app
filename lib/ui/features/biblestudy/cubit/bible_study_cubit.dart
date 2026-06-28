import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_app/domain/repositories/bible_study_repository.dart';

part 'bible_study_state.dart';

class BibleStudyCubit extends Cubit<BibleStudyState> {
  BibleStudyCubit({required BibleStudyRepository bibleStudyRepository})
      : _bibleStudyRepository = bibleStudyRepository,
        super(const BibleStudyState());

  final BibleStudyRepository _bibleStudyRepository;

  Future<void> loadContent() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));

    try {
      final snapshot = await _bibleStudyRepository.getContent();
      emit(
        state.copyWith(
          isLoading: false,
          content: snapshot.docs,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
