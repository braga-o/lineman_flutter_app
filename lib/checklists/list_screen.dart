import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linemanflutterapp/checklists/index.dart';
import 'package:linemanflutterapp/models/checklist.dart';

class ChecklistListScreen extends StatelessWidget {
  static const String nameMenuItem = '/checklists';

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Checklists'),
      ),
      body: BlocProvider(
        create: (context) =>
        ChecklistBloc(httpClient: http.Client())..add(Fetch()),
        child: ChecklistListPage(),
      ),
    );
  }
}

class ChecklistListPage extends StatefulWidget{
  @override
  _ChecklistListState createState() => _ChecklistListState();
}

class _ChecklistListState extends State<ChecklistListPage> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  ChecklistBloc _checklistBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _checklistBloc = BlocProvider.of<ChecklistBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChecklistBloc, ChecklistState>(
      builder: (context, state) {
        if (state is ChecklistError) {
          return Center(
            child: Text('failed to fetch chacklists'),
          );
        }
        if (state is ChecklistLoaded) {
          if (state.checklists.isEmpty) {
            return Center(
              child: Text('no checklists'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.checklists.length
                  ? BottomLoader()
                  : ChecklistWidget(checklist: state.checklists[index], idx: index + 1);
            },
            itemCount: state.hasReachedMax
                ? state.checklists.length
                : state.checklists.length + 1,
            controller: _scrollController,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _checklistBloc.add(Fetch());
    }
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}

class ChecklistWidget extends StatelessWidget {
  final Checklist checklist;
  final int idx;

  const ChecklistWidget({Key key, @required this.checklist, this.idx}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        '${idx}',
        style: TextStyle(fontSize: 10.0),
      ),
      title: Text('${checklist.name} [${checklist.id}]'),
      isThreeLine: true,
      subtitle: Text('Описание: ${checklist.description} [${checklist.sort}]'),
      dense: true,
    );
  }
}