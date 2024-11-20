
import 'package:call_log/call_log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecentPage extends StatefulWidget{
  final List<CallLogEntry> callLogs;

  const RecentPage({
    super.key,
    required this.callLogs
  });

  @override
  State<RecentPage> createState() =>_RecentPageState();



}

class _RecentPageState extends State<RecentPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.callLogs.length,
      itemBuilder: (context, index) {
        CallLogEntry log = widget.callLogs[index];
        return ListTile(
          title: Text(log.name ?? log.number ?? 'Unknown'),
          subtitle: Text(
              '${log.callType} | ${log.duration} seconds ${log.timestamp}'),
        );
      },
    );
  }
}