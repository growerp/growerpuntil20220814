import 'package:core/domains/tasks/bloc/task_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../tasks.dart';
import '../../common/common.dart';

class TaskListForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          TaskBloc(context.read<Object>())..add(TaskFetch()),
      child: TasksList(),
    );
  }
}

class TasksList extends StatefulWidget {
  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  final _scrollController = ScrollController();
  late bool search;
  late TaskBloc _taskBloc;

  @override
  void initState() {
    super.initState();
    search = false;
    _taskBloc = BlocProvider.of<TaskBloc>(context);
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        switch (state.status) {
          case TaskStatus.failure:
            return Center(
                child: Text('failed to fetch tasks: ${state.message}'));
          case TaskStatus.success:
            search = state.search;
            return Scaffold(
                floatingActionButton: FloatingActionButton(
                    key: Key("addNew"),
                    onPressed: () async {
                      await showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            return BlocProvider.value(
                                value: _taskBloc, child: TaskDialog(Task()));
                          });
                    },
                    tooltip: 'Add New',
                    child: Icon(Icons.add)),
                body: RefreshIndicator(
                    onRefresh: (() async {
                      _taskBloc.add(TaskFetch(refresh: true));
                    }),
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: state.hasReachedMax
                          ? state.tasks.length + 1
                          : state.tasks.length + 2,
                      controller: _scrollController,
                      itemBuilder: (BuildContext context, int index) {
                        if (state.tasks.isEmpty)
                          return const Center(
                              heightFactor: 20,
                              child: Text('No active tasks found',
                                  key: Key('empty'),
                                  textAlign: TextAlign.center));
                        if (index == 0)
                          return TaskListHeader(
                            search: search,
                          );
                        index--;
                        return index >= state.tasks.length
                            ? BottomLoader()
                            : TaskListItem(
                                task: state.tasks[index], index: index);
                      },
                    )));
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<TaskBloc>().add(TaskFetch());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
