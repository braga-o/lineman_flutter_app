import 'package:equatable/equatable.dart';

class Checklist extends Equatable {
  final int id;
  final int sort;
  final String name;
  final String description;

  Checklist({this.id, this.sort, this.name, this.description});

  @override
  List<Object> get props => [id, sort, name, description];

  @override
  String toString() => 'Checklist { id: $id }';
}