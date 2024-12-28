import 'dart:convert';
import 'dart:typed_data';
import 'package:clonephone/data/model/favourite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FavouriteGridItem extends StatelessWidget {
  const FavouriteGridItem({super.key, required this.contact});

  final Favourite contact;

  Future<Uint8List?> _fetchPhoto(String photoUri) async {
    try {
      const platform = MethodChannel('com.example.contacts');
      final base64String = await platform.invokeMethod<String>(
        'fetchContactPhoto',
        {'photoUri': photoUri},
      );
      if (base64String != null) {
        return base64Decode(base64String);
      }
    } catch (e) {
      debugPrint('Error fetching contact photo: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: contact.photoUri != null ? _fetchPhoto(contact.photoUri!) : Future.value(null),
      builder: (context, snapshot) {
        Widget? avatarChild;
        if (snapshot.connectionState == ConnectionState.waiting) {
          avatarChild = const CircularProgressIndicator();
        } else if (snapshot.hasError || snapshot.data == null) {
          avatarChild = Text(
            contact.name.isNotEmpty ? contact.name[0] : 'N',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          );
        } else {
          avatarChild = null;
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: snapshot.data != null ? MemoryImage(snapshot.data!) : null,
              child: avatarChild,
            ),
            const SizedBox(height: 5),
            // Name
            Text(
              contact.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}
