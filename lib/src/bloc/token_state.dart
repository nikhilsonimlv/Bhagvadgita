import 'package:meta/meta.dart';

abstract class TokenState {}

class TokenUnInitializedState extends TokenState {}

class TokenFetchingState extends TokenState {}

class TokenFetchedState extends TokenState {
  final String token;

  TokenFetchedState({@required this.token});
}

class TokenErrorState extends TokenState {}

class TokenEmptyState extends TokenState {}
