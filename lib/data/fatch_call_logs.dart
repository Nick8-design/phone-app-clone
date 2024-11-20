import 'package:call_log/call_log.dart';

Future<List<CallLogEntry>> fetchCallLogs() async {
  Iterable<CallLogEntry> callLogs = await CallLog.get();
  return callLogs.toList();
}