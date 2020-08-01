import 'dart:developer' as developer;
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linemanflutterapp/main/index.dart';
import 'package:linemanflutterapp/models/user.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final http.Client httpClient;
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  int _user_id;
  String _user_login;
  String _user_token;

  MainBloc({@required this.httpClient}){
    prefs.then((val) {
      if (val.get('user_id') != null) {
        _user_id = val.getInt('user_id') ?? 0;
      }
      _user_login = val.get("user_login");
      _user_token = val.get("user_token");
    });
  }

  @override
  Stream<Transition<MainEvent,  MainState>> transformEvents(
      Stream< MainEvent> events,
      TransitionFunction< MainEvent,  MainState> transitionFn,
      ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  get initialState => MainUninitialized();

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    final currentState = state;
    developer.log('AUTH: start');
    if (event is MainFetch && !_isAuthorized(currentState)) {
      developer.log('AUTH: !${event.login}!, !${event.password}!');
      try {
        if (currentState is MainUninitialized) {
          if(event.login != null && event.password != null) {
            final user = await _fetchUser(event.login, event.password);
            yield MainAuthorized(user: user);
          }else{
            yield currentState;
          }
          return;
        }
        if (currentState is MainAuthorized) {
          yield currentState;
        }
      } catch (_) {
        yield MainError(errorText: _.toString());
      }
    }
  }

  bool _isAuthorized(MainState state) =>
      state is MainAuthorized;

  Future<User> _fetchUser(login, pwd) async {
    final response = await httpClient.post(
        'https://jango.headpoint.ru/rest/login/',
        body: {
          'username': login.trim(),
          'password': pwd.trim()
        }
    );
    developer.log('AUTH code: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes)) as Map;
      developer.log('AUTH data: ${data}');
      return User(
        id: data['id'],
        login: data['login'],
        token: data['token'],
      );
    } else {
      developer.log('AUTH result: ${response.body}');
      throw Exception('error fetching user');
    }
  }
}