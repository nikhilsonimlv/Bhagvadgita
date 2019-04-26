import 'dart:async';

import 'package:bhagavadgita/src/resources/repository/common_repository.dart';
import 'package:bhagavadgita/src/util/util.dart';
import 'package:bloc/bloc.dart';
import 'package:bhagavadgita/src/bloc/token_event.dart';
import 'package:bhagavadgita/src/bloc/token_state.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState> {
  final CommonRepository commonRepository;

  TokenBloc({this.commonRepository}) : assert(commonRepository != null);

  @override
  // TODO: implement initialState
  TokenState get initialState => TokenUnInitializedState();

  @override
  Stream<TokenState> mapEventToState(TokenEvent event) async* {
    String myToken;
    // TODO: implement mapEventToState
    print("***** Execution is underbloc *****");
    if (event is TestTokenEvent) {
      yield TokenFetchingState();
      try {

        bool checkToken = await Util.checkToken();
        if(checkToken){
          myToken = await commonRepository.fetchTokenFromDb();
          print("Token into bloc from DB = " + myToken);
          if (myToken.length == 0) {
            yield TokenEmptyState();
          } else {
            yield TokenFetchedState(token: myToken);
          }
        }else{
          myToken = await commonRepository.fetchToken();
          print("Token into bloc from API = " + myToken);
          if (myToken.length == 0) {
            yield TokenEmptyState();
          } else {
            yield TokenFetchedState(token: myToken);
          }
        }


      } catch (e, s) {
        print("Exception is $e");
        print("Stack Trace is \n  $s");
        yield TokenErrorState();
      }
    }
  }
}
