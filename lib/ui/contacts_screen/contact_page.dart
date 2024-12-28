import 'dart:convert';

import 'package:call_log/call_log.dart';
import 'package:clonephone/data/displayed_contacts.dart';
import 'package:clonephone/ui/components/contact_item.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/color_changing_loader.dart';
import '../../common/providers.dart';
import '../../data/fetch_contacts.dart';
import '../../permissions.dart';
import 'contact_info.dart';
import 'contact_list_shimmer.dart';


class ContactPage extends ConsumerStatefulWidget{
  const ContactPage({super.key, required this.onFavorite});
  final Function(Contact) onFavorite;
  @override
  ConsumerState<ContactPage> createState() => _ContactPageState();
}


class _ContactPageState extends ConsumerState<ContactPage>{
  static const double largeScreenPercentage = 0.9;
  static const double maxWidth = 2000;
  static const desktopThreshold = 700;
  final ScrollController _scrollController = ScrollController();
  //late Future<List<Contact>> _contactFuture;

//loading per screen
  List<Contact> _displayedContacts = [];
  List<Contact> _allContacts = [];
  bool _isLoadingMore = false;
  bool _hasMoreContacts = true;
  int _currentPage = 0;
  final int _pageSize = 20;

  ContactManager contactManager= ContactManager();


  @override
  void initState() {
    super.initState();
    _loadInitialContacts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent &&
          !_isLoadingMore &&
          _hasMoreContacts) {
        _loadMoreContacts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialContacts() async {
    setState(() {
      _isLoadingMore = true; // Set loading state
    });
    try {




     final contacts = await fetchContacts();




      setState(() {
        _allContacts = contacts;
        _displayedContacts = _paginateContacts();
        dis_contact=_displayedContacts;
        _hasMoreContacts = _displayedContacts.length < _allContacts.length;
        _isLoadingMore = false;

      });
  }catch (e) {
      setState(() {
        _isLoadingMore = false; // Stop loading on error
      });



      Fluttertoast.showToast(
        msg: "Error loading contacts: $e",
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        fontSize: 16.0,
      );


    }
  }

  Future<void> _loadMoreContacts() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    // await Future.delayed(const Duration(seconds: 1));

    setState(() {
      final newContacts = _paginateContacts();
      _displayedContacts.addAll(newContacts);
      dis_contact=_displayedContacts;
      _hasMoreContacts = _displayedContacts.length < _allContacts.length;
      _isLoadingMore = false;
    });
  }
  List<Contact> _paginateContacts() {
    final startIndex = _currentPage * _pageSize;
    final endIndex = startIndex + _pageSize;
    _currentPage++;
    return _allContacts.sublist(
        startIndex, endIndex > _allContacts.length ? _allContacts.length : endIndex);
  }


@override
  Widget build(BuildContext context) {
  final isLoadingInitial = _displayedContacts.isEmpty && _isLoadingMore;


  return Center(
    child: SizedBox(
      width: _calculateConstrainedWidth(MediaQuery
          .of(context)
          .size
          .width),
      child: isLoadingInitial
          ? buildShimmerPlaceholders()
          : CustomScrollView(
        controller: _scrollController,
        slivers: [
          ..._buildGroupedSlivers(_groupContacts(_displayedContacts)),

          if (_isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child:CircularProgressIndicator()

                ),
              ),
            ),
        ],
      ),
    ),
  );
}




/*
  return FutureBuilder<List<Contact>>(
    future: _contactFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Show a loading indicator while permissions are being checked
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      else if (snapshot.hasError) {
        // Handle errors during permission request
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:  Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(fontSize: 16),
            ),
          ),

        );
      }
      else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        // Permissions granted, proceed with contact display
        return const Center(
          child: Text(
            'No Contacts on this device',
            style: TextStyle(fontSize: 18.0),
          ),

        );
      } else{
        final contacts = snapshot.data!;
        final groupedContacts = _groupContacts(contacts);
           return Center(
          child: SizedBox(
            width: _calculateConstrainedWidth(MediaQuery.of(context).size.width),
            child:CustomScrollView(
              slivers:
                _buildGroupedSlivers(groupedContacts),

            )
          ),
        );
      }
    },
  );
}
*/

  Map<String, List<Contact>> _groupContacts(List<Contact> contacts) {

    contacts.sort((a, b) {
      final nameA = (a.displayName ?? '').toLowerCase();
      final nameB = (b.displayName ?? '').toLowerCase();
      return nameA.compareTo(nameB);
    });

    final Map<String, List<Contact>> grouped = {};

    for (var contact in contacts) {
      final key = (contact.displayName ?? 'Unknown')[0].toUpperCase();
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(contact);
    }
    return grouped;
  }



  List<Widget> _buildGroupedSlivers(Map<String, List<Contact>> groupedContacts) {
    final List<Widget> slivers = [contactadd()];



    for (var entry in groupedContacts.entries) {
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 64.0 ,top: 16,bottom: 2),
            child: Text(
              entry.key, // Alphabetical group label
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      );

      slivers.add(_buildGridViewSection(entry.value));
    }

    return slivers;
  }


  /// Builds a grid view for a specific group of contacts
  SliverToBoxAdapter _buildGridViewSection(List<Contact> contacts) {
    final columns = calculateColumnCount(MediaQuery.of(context).size.width);
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _buildGridView(contacts, columns),
      ),
    );
  }



  /// Builds the grid view itself
  GridView _buildGridView(List<Contact> contacts, int columns) {
    return GridView.builder(
        padding: const EdgeInsets.only(left: 32),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 2,
          crossAxisSpacing: 8,
          childAspectRatio: 5.5,
          crossAxisCount: columns,
        ),
      itemBuilder: (context, index) => _buildGridItem(contacts[index]),
      itemCount: contacts.length,
      shrinkWrap: true,
      controller: ScrollController(),
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
    );
  }

  /// Builds each grid item (individual contact)
  Widget _buildGridItem(Contact contact) {
    return InkWell(
      onTap: ()
    {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context)=>
                ContactInfo(contact: contact)
        )
    );

      widget.onFavorite(contact);
      
    },

      child: ContactItem(contact: contact),
    );
  }


  /// Calculates constrained width for large screens
  double _calculateConstrainedWidth(double screenWidth) {
    return (screenWidth > desktopThreshold
        ? screenWidth * largeScreenPercentage
        : screenWidth)
        .clamp(0.0, maxWidth);
  }

  /// Calculates the number of columns based on screen width
  int calculateColumnCount(double screenWidth) {
    return screenWidth > desktopThreshold ? 2 : 1;
  }
}

  /*

  Widget _buildGridItem(Contact contact) {
    return InkWell(
      onTap: () => widget.onFavorite(contact),
      child: ContactItem(contact: contact),
    );
  }

  GridView _buildGridView(List<Contact> contacts, int columns) {
  return GridView.builder(
    padding: const EdgeInsets.all(0),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      mainAxisSpacing: 2,
      crossAxisSpacing: 8,
      childAspectRatio: 5.5,
      crossAxisCount: columns,
    ),
    itemBuilder: (context, index) => _buildGridItem(contacts[index]),
    itemCount: contacts.length,
    shrinkWrap: true,
    controller: ScrollController(),
    physics: const NeverScrollableScrollPhysics(),
  );
}


  SliverToBoxAdapter _buildGridViewSection(List<Contact> contacts) {
  final columns = calculateColumnCount(MediaQuery.of(context).size.width);
  return SliverToBoxAdapter(
    child: Container(
      padding: const EdgeInsets.only(left: 16,right: 16),
      child: _buildGridView(contacts, columns),
    ),
  );
}



  CustomScrollView _buildCustomScrollView(List<Contact> contacts) {
    return CustomScrollView(
      slivers: [
        _buildGridViewSection(contacts),
      ],
    );
  }







double _calculateConstrainedWidth(double screenWidth) {
  return (screenWidth > desktopThreshold
      ? screenWidth * largeScreenPercentage
      : screenWidth)
      .clamp(0.0, maxWidth);
}

int calculateColumnCount(double screenWidth) {
  return screenWidth > desktopThreshold ? 2 : 1;
}





}
*/