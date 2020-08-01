import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linemanflutterapp/main/index.dart';
import 'package:linemanflutterapp/models/user.dart';
import 'package:linemanflutterapp/checklists/list_screen.dart';

/// Класс, отвечающий за экран авторизации
class AuthScreen extends StatelessWidget {
  static const String nameMenuItem = '/';

  @override
  Widget build(BuildContext context){
    return Scaffold( // Основнй класс для реализации material-лейоута
      appBar: AppBar(
        title: Text('Auth form'),
      ),
      body: BlocProvider( //Основной класс для разделения логики и представления по архитектуре BloC
        create: (context) =>
          MainBloc(httpClient: http.Client())..add(MainFetch()), //Создаем класс бизнесс-логики и цеплаем к нему событие для отслеживания попытки авторизации
        child: AuthPage(), // Передаем виджет экрана Авторизации
      ),
    );
  }
}

/// Класс отвечающий за форму авторизации
class AuthPage extends StatefulWidget{ // Наследуюется от базового виджета с поддержкой состояния
  @override
  _SignUpWidgetWidgetState createState() => _SignUpWidgetWidgetState();
}

/// Класс, твечающий за состояние формы авторизации, включая все основные элементы управления
class _SignUpWidgetWidgetState extends State {
  MainBloc _mainBloc;

  String _login, _password;

  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loginController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _mainBloc = BlocProvider.of<MainBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        List<Widget> authList;
        if (state is MainError || state is MainUninitialized) {
          authList = <Widget>[
            TextFormField(
              controller: _loginController,
              decoration: InputDecoration(labelText: 'login'),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'password'),
            ),
            RaisedButton(
              child: Text('sign up'),
              onPressed: () {
                _mainBloc.add(MainFetch(login: _login, password: _password));
              }
            )
          ];
          if (state is MainError) {
            authList.add(Center(
              child: Text('Error: ${state.errorText}'),
            ));
          }
        }else if(state is MainAuthorized){
          Navigator.of(context).pushReplacementNamed(ChecklistListScreen.nameMenuItem);
          authList = <Widget>[];
        }else{
          authList = <Widget>[
            Center(
              child: Text('Unknown satet!'),
            )
          ];
        }
        return Column(
          children: authList,
        );
      }
    );
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _login = _loginController.text;
  }

  void _onPasswordChanged() {
    _password = _passwordController.text;
  }
}