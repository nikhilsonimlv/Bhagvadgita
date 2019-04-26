import 'package:bhagavadgita/src/resources/model/all_chapters_model.dart';

abstract class AllChaptersState{}

class AllChaptersUnInitializedState extends AllChaptersState {}

class AllChaptersFetchingState extends AllChaptersState {}

class AllChaptersFetchedState extends AllChaptersState {
  final AllChaptersModel allChaptersModel;

  AllChaptersFetchedState({this.allChaptersModel});

}

class AllChaptersErrorState extends AllChaptersState {}

class AllChaptersEmptyState extends AllChaptersState {}
