import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

// Эти библиотеки подключаются, что бы использовать архитектуру BLOC
// для разделения представления и логики
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:linemanflutterapp/main/index.dart';
import 'package:linemanflutterapp/splash/index.dart';
import 'package:linemanflutterapp/auth_screen.dart';
import 'package:linemanflutterapp/checklists/list_screen.dart';

/// Основная точка входа приложения
void main(){
  BlocSupervisor.delegate = LinemanBlocDelegate();
  runApp(MyApp());
}

/// Основной класс приложения
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp( // Класс отвечающий за использование material-виджетов для дизайна приложения
      title: 'Lineman checklists',
      routes: { // Параметр отвечающий за переключение экранов
        '/': (context) => AuthScreen(), // Экран авторизации
        ChecklistListScreen.nameMenuItem: (context) => ChecklistListScreen(), // Экран списка обхдных листов
      },
    );
  }
}
