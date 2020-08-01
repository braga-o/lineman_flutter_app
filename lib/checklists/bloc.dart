import 'dart:developer' as developer;
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:linemanflutterapp/checklists/index.dart';
import 'package:linemanflutterapp/models/checklist.dart';

class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {
  final http.Client httpClient;
  final String strToken = "005b9ba52490059f19716cafaaf995a96ad90147";

  ChecklistBloc({@required this.httpClient});

  @override
  Stream<Transition< ChecklistEvent,  ChecklistState>> transformEvents(
      Stream< ChecklistEvent> events,
      TransitionFunction< ChecklistEvent,  ChecklistState> transitionFn,
      ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  get initialState => ChecklistUninitialized();

  @override
  Stream<ChecklistState> mapEventToState(ChecklistEvent event) async* {
    final currentState = state;
    final int numPerPage = 10;
    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is ChecklistUninitialized) {
          final checklists = await _fetchChecklists(0, numPerPage);
          developer.log('lenght1: ${checklists.length}');
          yield ChecklistLoaded(checklists: checklists, hasReachedMax: (checklists.length < numPerPage));
          return;
        }
        if (currentState is ChecklistLoaded) {
          final checklists = await _fetchChecklists(currentState.checklists.length, numPerPage);
          developer.log('lenght2: ${checklists.length}');
          yield checklists.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : ChecklistLoaded(
            checklists: currentState.checklists + checklists,
            hasReachedMax: (checklists.length < numPerPage),
          );
        }
      } catch (_) {
        yield ChecklistError();
      }
    }
  }

  bool _hasReachedMax(ChecklistState state) =>
      state is ChecklistLoaded && state.hasReachedMax;

  Future<List<Checklist>> _fetchChecklists(int startIndex, int limit) async {
    final response = await httpClient.get(
        'https://jango.headpoint.ru/rest/checklists/?format=json&offset=$startIndex&limit=$limit',
        headers: {'token': strToken}
    );
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes)) as Map;
      final dataList = data['results'] as List;
//      developer.log(dataList.toString());
//      developer.log('Got Data!!!');
      return dataList.map((rawChecklist) {
        return Checklist(
          id: rawChecklist['id'],
          sort: rawChecklist['sort'],
          name: rawChecklist['name'],
          description: rawChecklist['description'],
        );
      }).toList();
    } else {
      throw Exception('error fetching cehcklists');
    }
  }
}