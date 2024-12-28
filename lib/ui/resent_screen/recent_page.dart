import 'package:call_log/call_log.dart';
import 'package:clonephone/ui/resent_screen/recent_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../data/fatch_call_logs.dart';
import '../contacts_screen/contact_list_shimmer.dart';

class RecentPage extends StatefulWidget{
  const RecentPage({super.key,});
  @override
  State<RecentPage> createState() =>_RecentPageState();

}



class _RecentPageState extends  State<RecentPage> {
  static const double largeScreenPercentage = 0.9;
  static const double maxWidth = 2000;
  static const desktopThreshold = 700;
  final ScrollController _scrollController = ScrollController();
  int? expandedIndex;
  List<CallLogEntry> _displayedContacts = [];
  List<CallLogEntry> _allContacts = [];
  bool _isLoadingMore = false;
  bool _hasMoreContacts = true;
  int _currentPage = 0;
  final int _pageSize = 20;

  late List<bool> tapedStates;

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
    tapedStates = [];
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  Future<void> _loadInitialContacts() async {
    setState(() {
      _isLoadingMore = true;
    });
    try {
      final recent = await fetchCallLogs();
      setState(() {
        _allContacts = recent;
        _displayedContacts = _paginateContacts();
        tapedStates = List<bool>.filled(_displayedContacts.length, false); // Ensure it's properly initialized
        _hasMoreContacts = _displayedContacts.length < _allContacts.length;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });

      Fluttertoast.showToast(
        msg: "Error loading Call logs: $e",
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  List<CallLogEntry> _paginateContacts() {
    final startIndex = _currentPage * _pageSize;
    final endIndex = startIndex + _pageSize;
    _currentPage++;
    return _allContacts.sublist(
        startIndex,
        endIndex > _allContacts.length ? _allContacts.length : endIndex);
  }


  Future<void> _loadMoreContacts() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final newContacts = _paginateContacts();
    setState(() {
      _displayedContacts.addAll(newContacts);
      tapedStates.addAll(List<bool>.filled(newContacts.length, false)); // Ensure it matches the newly added contacts
      _hasMoreContacts = _displayedContacts.length < _allContacts.length;
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoadingInitial = _displayedContacts.isEmpty && _isLoadingMore;
    return Center(
      child: SizedBox(
        width: _calculateConstrainedWidth(MediaQuery.of(context).size.width),
        child: isLoadingInitial
            ? buildShimmerPlaceholders()
            :  /*ListView.builder(
          itemCount: _displayedContacts.length,
          itemBuilder: (context, index) {
            CallLogEntry log = _displayedContacts[index];
            return RecentItem( resent: log,);
          },
        ),*/


        CustomScrollView(
          controller: _scrollController,
          slivers: [
            ..._buildGroupedSlivers(_groupCallLogs(_displayedContacts)),

            if (_isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator(),

                  ),
                ),
              )
            ,
          ],
        ),





      ),

    );

  }




Map<String, List<CallLogEntry>> _groupCallLogs(List<CallLogEntry> callLogs) {
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);
  final yesterdayStart = todayStart.subtract(const Duration(days: 1));

  final Map<String, List<CallLogEntry>> grouped = {
    'Today': [],
    'Yesterday': [],
    'Older': [],
  };

  for (var entry in callLogs) {
    final callTime = DateTime.fromMillisecondsSinceEpoch(entry.timestamp!);

if(callTime.isAfter(todayStart)){
  grouped['Today']!.add(entry);
}else if (callTime.isAfter(yesterdayStart)) {
  grouped['Yesterday']!.add(entry);
} else {
  grouped['Older']!.add(entry);
}
  }

  return grouped;
}








    List<Widget> _buildGroupedSlivers(Map<String, List<CallLogEntry>> groupedContacts) {
    final List<Widget> slivers = [];

    for (var entry in groupedContacts.entries) {
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              entry.key,
              style: const TextStyle(
                fontSize: 16.0,
              //  fontWeight: FontWeight.bold,
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


  SliverToBoxAdapter _buildGridViewSection(List<CallLogEntry> contacts) {
    final columns = calculateColumnCount(MediaQuery.of(context).size.width);
    return SliverToBoxAdapter(
      child: Container(
        child: _buildGridView(contacts, columns),
      ),
    );
  }



  Column _buildGridView(List<CallLogEntry> contacts, int columns) {
    return Column(
      children: List.generate(
        (contacts.length / columns).ceil(),
            (rowIndex) {
          int start = rowIndex * columns;
          int end = (rowIndex + 1) * columns > contacts.length
              ? contacts.length
              : (rowIndex + 1) * columns;

          // Create rows
          return Row(
            children: [
              for (int i = start; i < end; i++)
                Expanded(
                  child: _buildGridItem(contacts[i], i),
                ),
            ],
          );
        },
      ),
    );
  }




/*
  GridView _buildGridView(List<CallLogEntry> contacts, int columns) {
    return GridView.builder(
        padding: const EdgeInsets.all(0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
         childAspectRatio:3.3 ,
          crossAxisCount: columns,
        ),
      itemBuilder: (context, index) => _buildGridItem(contacts[index],index),
      itemCount: contacts.length,
      shrinkWrap: true,
      //controller: ScrollController(),
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
    );
  }
*/

  Widget _buildGridItem(CallLogEntry contact, int index) {
    if (index < tapedStates.length) {
      return InkWell(
        onTap: () {
     //     expandedIndex==index;
          setState(() {

            tapedStates[index] = !tapedStates[index];

          });
        },

        child: RecentItem(resent: contact, onTap: tapedStates[index],
         /* onExpand: () {
            setState(() {
              if (expandedIndex == index) {
                expandedIndex = null; // Collapse if it's already expanded
              } else {
                expandedIndex = index; // Expand the tapped item
              }
            });
          },*/

        ),
      );
    }else{
    return  Container();
    }
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


