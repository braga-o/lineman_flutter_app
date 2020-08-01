import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MainFetch extends MainEvent {
  String login, password;

  MainFetch({this.login, this.password});
}