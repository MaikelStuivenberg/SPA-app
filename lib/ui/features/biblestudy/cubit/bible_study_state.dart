part of 'bible_study_cubit.dart';

class BibleStudyState {
  const BibleStudyState({
    this.isLoading = false,
    this.content = const [],
  });

  final bool isLoading;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> content;

  BibleStudyState copyWith({
    bool? isLoading,
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? content,
  }) {
    return BibleStudyState(
      isLoading: isLoading ?? this.isLoading,
      content: content ?? this.content,
    );
  }
}
