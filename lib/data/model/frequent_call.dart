import 'package:flutter/services.dart';

class CallLogHelper {
  static const MethodChannel _channel = MethodChannel('com.example.contacts');

  static Future<List<Map<String, String>>> getFrequentlyCalledContacts() async {
    try {
      final List<dynamic> result = await _channel.invokeMethod('getFrequentlyCalledContacts');
      return result.map((contact) => Map<String, String>.from(contact)).toList();
    } catch (e) {
      print('Error fetching frequently called contacts: $e');
      return [];
    }
  }
}

//
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class CallLogHelper {
//   static Future<List<Map<String, dynamic>>> getFrequentlyCalledContacts() async {
//     try {
//       // Replace with the actual logic for fetching call logs
//       // For example, platform.invokeMethod if calling native code
//       const platform = MethodChannel('com.example.contacts');
//       final List<dynamic> callLog = await platform.invokeMethod('getCallLogs');
//
//       print('Native call log response: $callLog');
//
//       return callLog.map((log) {
//         return {
//           'name': log['name'] ?? 'Unknown',
//           'phone': log['phone'] ?? 'Unknown',
//           'duration': log['duration'] ?? '0',
//         };
//       }).toList();
//     } catch (e) {
//       print('Error fetching call logs: $e');
//       Fluttertoast.showToast(
//         msg: 'Error fetching call logs: $e',
//         toastLength: Toast.LENGTH_LONG,
//       );
//       return [];
//     }
//   }
// }
