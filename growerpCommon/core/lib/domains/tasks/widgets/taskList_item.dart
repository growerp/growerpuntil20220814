import 'package:core/domains/tasks/bloc/task_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../tasks.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem({Key? key, required this.task, required this.index})
      : super(key: key);

  final Task task;
  final int index;

  @override
  Widget build(BuildContext context) {
    final taskBloc = BlocProvider.of<TaskBloc>(context);
    return Material(
        child: ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.green,
                child: Text("${task.taskName![0]}")),
            title: Row(
              children: <Widget>[
                Expanded(
                    child: Text("${task.taskName}", key: Key('name$index'))),
                Expanded(
                    child: Text("${task.status}", key: Key('status$index'))),
                Container(
                    child: Text("${task.unInvoicedHours!.toString()}",
                        key: Key('unInvoicedHours$index'))),
                if (!ResponsiveWrapper.of(context).isSmallerThan(TABLET))
                  Expanded(
                      child: Text("${task.description}",
                          key: Key('description$index'),
                          textAlign: TextAlign.center)),
                if (!ResponsiveWrapper.of(context).isSmallerThan(TABLET))
                  Expanded(
                      child: Text("${task.rate}",
                          key: Key('rate$index'), textAlign: TextAlign.center)),
              ],
            ),
            onTap: () async {
              await showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (BuildContext context) {
                    return BlocProvider.value(
                        value: taskBloc, child: TaskDialog(task));
                  });
            },
            trailing: IconButton(
                key: Key('delete$index'),
                icon: Icon(Icons.delete_forever),
                onPressed: () {
                  taskBloc.add(TaskUpdate(task.copyWith(status: 'Closed')));
                })));
  }
}
