/*
 * This software is in the public domain under CC0 1.0 Universal plus a
 * Grant of Patent License.
 * 
 * To the extent possible under law, the author(s) have dedicated all
 * copyright and related and neighboring rights to this software to the
 * public domain worldwide. This software is distributed without any
 * warranty.
 * 
 * You should have received a copy of the CC0 Public Domain Dedication
 * along with this software (see the LICENSE.md file). If not, see
 * <http://creativecommons.org/publicdomain/zero/1.0/>.
 */

import 'package:core/domains/domains.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class TimeEntryListItem extends StatelessWidget {
  const TimeEntryListItem({
    Key? key,
    required this.taskId,
    required this.timeEntry,
    required this.index,
  }) : super(key: key);

  final String taskId;
  final TimeEntry timeEntry;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
              child: Text("${timeEntry.date!.toLocal()}".split(' ')[0],
                  key: Key('date$index'))),
          Container(child: Text("${timeEntry.hours}", key: Key('hours$index'))),
          if (!ResponsiveWrapper.of(context).isSmallerThan(TABLET))
            Expanded(
                child: Text("${timeEntry.partyId}",
                    key: Key('partyId$index'), textAlign: TextAlign.center)),
          if (!ResponsiveWrapper.of(context).isSmallerThan(TABLET))
            Expanded(
                child: Text("${timeEntry.comments}",
                    key: Key('comments$index'), textAlign: TextAlign.center)),
        ],
      ),
      onTap: () async {
        await showDialog(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return BlocProvider.value(
                  value: context.read<TaskBloc>(),
                  child: TimeEntryDialog(timeEntry));
            });
      },
      trailing: IconButton(
        key: Key('delete$index'),
        icon: Icon(Icons.delete_forever),
        onPressed: () {
          context.read<TaskBloc>().add(TaskTimeEntryDelete(timeEntry));
        },
      ),
    ));
  }
}
