import 'dart:async';
import 'package:bhagavadgita/src/resources/model/all_chapters_model.dart';
import 'package:bhagavadgita/src/resources/repository/common_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bhagavadgita/src/bloc/all_chapters_event.dart';
import 'package:bhagavadgita/src/bloc/all_chapters_state.dart';

class AllChaptersBloc extends Bloc<AllChaptersEvent, AllChaptersState> {
  CommonRepository commonRepository;
  AllChaptersBloc({this.commonRepository});

  @override
  // TODO: implement initialState
  AllChaptersState get initialState => AllChaptersUnInitializedState();

  @override
  Stream<AllChaptersState> mapEventToState(AllChaptersEvent event) async* {
    AllChaptersModel allChaptersModel;

    if (event is AllChaptersTestEvent) {
      yield AllChaptersFetchingState();
      try {
        allChaptersModel = await commonRepository.fetchAllChapters();
        print("name is "+allChaptersModel.chapterList[0].name);

        if (allChaptersModel.chapterList.length == 0) {
          yield AllChaptersEmptyState();
        } else {
          print("AllChaptersFetchedState");

          yield AllChaptersFetchedState(allChaptersModel: allChaptersModel);
        }
      } catch (e,s) {
        print("Exception is $e");
        print("Stack Trace is \n  $s");
        yield AllChaptersErrorState();

      }
    }
  }
}
