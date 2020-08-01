import 'package:equatable/equatable.dart';

abstract class ChecklistEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Fetch extends ChecklistEvent {}