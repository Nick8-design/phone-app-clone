import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/sizebox.dart';
import '../../data/model/favourite.dart';
import '../../data/model/frequent_call.dart';
import '../../data/model/frequent_mod.dart';
import '../favourite_screen/favourite_grid_item.dart';
import '../favourite_screen/freq_item.dart';


class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Favourite> favoriteContacts = [];
  List<Map<String, String>> frequentlyCalledContacts = [];

  List<Map<String, String>> frequntcons = [];
  List<frecon> frequntcon = [];


  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFavoriteContacts();
    _fetchFrequentlyCalledContacts();
  }

  Future<void> _fetchFavoriteContacts() async {
    if (await Permission.contacts.request().isGranted) {
      const platform = MethodChannel('com.example.contacts');
      try {
        // Fetch favorite contacts from the native side
        final List<dynamic> result = await platform.invokeMethod('getFavoriteContacts');
        setState(() {
          favoriteContacts = result.map((contact) {
            return Favourite(
              name: contact['name'] ?? 'Unknown',
              phone: contact['phone'] ?? 'No number',
              photoUri: contact['photoUri'],
            );
          }).toList();

          isLoading = false;
        });
        Fluttertoast.showToast(
          msg: 'Found ${favoriteContacts.length} contacts',
          toastLength: Toast.LENGTH_LONG,
        );
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Error fetching contacts: $e',
          toastLength: Toast.LENGTH_LONG,
        );
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Permission denied',
        toastLength: Toast.LENGTH_LONG,
      );
      setState(() {
        isLoading = false;
      });
    }
  }


  // const platform = MethodChannel('com.example.contacts');
  //
  // Future<void> fetchFrequentlyCalledContacts() async {
  //   try {
  //     final result = await platform.invokeMethod('getFrequentlyCalledContacts');
  //     print('Fetched contacts: $result');
  //   } on PlatformException catch (e) {
  //     print('Error fetching frequently called contacts: ${e.message}');
  //   }
  // }lass CallLogHelper {
  //   static const MethodChannel _channel = MethodChannel('com.example.contacts');
  //
  //   static Future<List<Map<String, String>>> getFrequentlyCalledContacts() async {
  //     try {
  //       final List<dynamic> result = await _channel.invokeMethod('getFrequentlyCalledContacts');
  //       return result.map((contact) => Map<String, String>.from(contact)).toList();
  //     } catch (e) {
  //       print('Error fetching frequently called contacts: $e');
  //       return [];
  //     }
  //   }
  // }




  Future<void> _fetchFrequentlyCalledContacts() async {
    if (await Permission.phone.request().isGranted) {
      const platform = MethodChannel('com.example.contacts');
      try {
        final List<dynamic>  result = await platform.invokeMethod('getFrequentlyCalledContacts');
        Fluttertoast.showToast(
          msg: 'Found $result contacts',
          toastLength: Toast.LENGTH_LONG,
        );
        setState(() {

          frequntcon = result.map((contact) {
            return frecon(
              displayName: contact['name'] ?? 'Unknown',
              phoneNumber: contact['phone'] ?? 'Unknown',
              duration: contact['duration'] ?? '0',
            );
          }).toList();
          isLoading=false;
        });

        Fluttertoast.showToast(
          msg: 'Found ${frequntcon.length} contacts',
          toastLength: Toast.LENGTH_LONG,
        );

      }catch (e){
        Fluttertoast.showToast(
          msg: 'E $e',
          toastLength: Toast.LENGTH_LONG,
        );
        setState(() {
          isLoading = false;
        });
      }


    }else {
      Fluttertoast.showToast(
        msg: 'Permission denied',
        toastLength: Toast.LENGTH_LONG,
      );
      setState(() {
        isLoading = false;
      });
    }
  }


  //
  //   final contacts = await CallLogHelper.getFrequentlyCalledContacts();
  //   Fluttertoast.showToast(
  //     msg: 'Found $contacts contacts',
  //     toastLength: Toast.LENGTH_LONG,
  //   );
  //   setState(() {
  //    // frequentlyCalledContacts = contacts;
  //
  //     frequntcon = contacts.map((contact) {
  //       return frecon(
  //         displayName: contact['name'] ?? 'Unknown',
  //         phoneNumber: contact['phone'] ?? 'Unknown',
  //         duration: contact['duration'] ?? '0',
  //       );
  //     }).toList();
  //
  //
  //   });
  //   Fluttertoast.showToast(
  //     msg: 'Found ${frequntcon.length} contacts',
  //     toastLength: Toast.LENGTH_LONG,
  //   );
  //
  // }

  SliverGrid buildFavoritesGrid(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenWidth < 700 ? 3 : 5,
        crossAxisSpacing: 7.0,
        mainAxisSpacing: 7.0,
        childAspectRatio: 0.7,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, index) => FavouriteGridItem(contact: favoriteContacts[index]),
        childCount: favoriteContacts.length,
      ),
    );
  }

  // List<frecon> testData = [
  //   frecon(displayName: 'John Doe', phoneNumber: '123456789', duration: '5 min'),
  //   frecon(displayName: 'Jane Smith', phoneNumber: '987654321', duration: '3 min'),
  // ];
  //
  // SliverList buildFrequentContactsList() {
  //   return SliverList(
  //     delegate: SliverChildBuilderDelegate(
  //           (context, index) => FreqItem(resent: testData[index]),
  //       childCount: testData.length,
  //     ),
  //   );
  // }



  SliverList buildFrequentContactsList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) => FreqItem(resent: frequntcon[index]),
        childCount: frequntcon.length,
      ),
    );
  }

  SliverToBoxAdapter buildFavoritesTitle() {
    return const SliverToBoxAdapter(
      child: ListTile(
        leading: Text('Favorites'),
        trailing: Icon(Icons.add),
      ),
    );
  }

  SliverToBoxAdapter buildFrequentContactsTitle() {
    return const SliverToBoxAdapter(
      child: ListTile(
        leading: Text('Frequents'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : CustomScrollView(
      slivers: [
        buildFavoritesTitle(),
        buildFavoritesGrid(context),
        buildFrequentContactsTitle(),
        buildFrequentContactsList(),
      ],
    );
  }
}