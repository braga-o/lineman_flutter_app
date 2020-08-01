import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String login;
  final String token;

  User({this.id, this.login, this.token});

  @override
  List<Object> get props => [id, login, token];

  @override
  String toString() => 'User { id: $id }';
}