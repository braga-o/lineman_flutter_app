import 'package:equatable/equatable.dart';

import 'package:linemanflutterapp/models/models.dart';

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [];
}

class MainUninitialized extends MainState {}

class MainError extends MainState {
  final String errorText;
  const MainError({this.errorText});
}

class MainAuthorized extends MainState {
  final User user;

  const MainAuthorized({this.user});

  MainAuthorized copyWith({User user}) {
    return MainAuthorized(user: user);
  }

  @override
  List<Object> get props => [user];

  @override
  String toString() =>
      'User: ${user.login} [${user.id}]';
}