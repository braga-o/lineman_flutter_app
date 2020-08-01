import 'package:equatable/equatable.dart';

import 'package:linemanflutterapp/models/models.dart';

abstract class ChecklistState extends Equatable {
  const ChecklistState();

  @override
  List<Object> get props => [];
}

class ChecklistUninitialized extends ChecklistState {}

class ChecklistError extends ChecklistState {}

class ChecklistLoaded extends ChecklistState {
  final List<Checklist> checklists;
  final bool hasReachedMax;

  const ChecklistLoaded({
    this.checklists,
    this.hasReachedMax,
  });

  ChecklistLoaded copyWith({
    List<Checklist> Checklists,
    bool hasReachedMax,
  }) {
    return ChecklistLoaded(
      checklists: Checklists ?? this.checklists,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [checklists, hasReachedMax];

  @override
  String toString() =>
      'ChecklistLoaded { Checklists: ${checklists.length}, hasReachedMax: $hasReachedMax }';
}