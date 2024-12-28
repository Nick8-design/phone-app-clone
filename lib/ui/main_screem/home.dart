
import 'package:call_log/call_log.dart';
import 'package:clonephone/common/providers.dart';
import 'package:clonephone/ui/favourite_screen/favourite_page.dart';
import 'package:clonephone/ui/resent_screen/recent_page.dart';
import 'package:contacts_service/contacts_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

import '../../common/custom_dropdown.dart';
import '../../common/floatingactionbutton.dart';
import '../../common/sizebox.dart';
import '../../common/utils.dart';
import '../../data/fatch_call_logs.dart';
import '../../data/fetch_contacts.dart';
import '../../permissions.dart';
import '../contacts_screen/contact_page.dart';


class Home extends ConsumerStatefulWidget{

  const Home({
    super.key,
    // required this.tab
  });
  // final int tab;


  @override
  ConsumerState<Home> createState() =>_HomeState();
}

class _HomeState extends ConsumerState<Home>{
  List<Contact> contacts = [];
  List<CallLogEntry> callLogs = [];
  List<Contact> favoriteContacts = [];

  late TextEditingController searchTextController;
  List<Widget> pageList = <Widget>[];
  static const String prefSelectedIndexKey = 'selectedIndex';
  late double screenWidth;
  bool undoreturn=false;
  final FocusNode textFieldFocusNode = FocusNode();
  bool typyping = false;

  @override
  void initState(){
    super.initState();
   // fetchData();
    searchTextController = TextEditingController(text: '');
    pageList.add( const FavoritesPage());
    pageList.add( const RecentPage());
    pageList.add( ContactPage(onFavorite:  (contact) {
      setState(() {
        if (!favoriteContacts.contains(contact)) {
          favoriteContacts.add(contact);
        }
      });
    }),);
    Future.microtask(() async {
      getCurrentIndex();
    });
    textfieldFocus();


  }

  // Future<void> fetchData() async {
  //   // Request permissions
  //   await requestPermissions();
  //   List<Contact> fetchedContacts = await fetchContacts();
  //   List<CallLogEntry> fetchedCallLogs = await fetchCallLogs();
  //
  //   setState(() {
  //     contacts = fetchedContacts;
  //     callLogs = fetchedCallLogs;
  //   });
  // }

  @override
  void dispose() {
    searchTextController.dispose();
    // _scrollController.dispose();
    textFieldFocusNode.dispose();
    super.dispose();
  }

  void textfieldFocus()async{
    textFieldFocusNode.addListener(() {
      if (textFieldFocusNode.hasFocus) {
        setState(() {
          undoreturn = true;
        });
      }else{
        setState(() {
          undoreturn = false;
        });
      }
    });
  }



  void saveCurrentIndex()async{
    final prefs = ref.read(sharedPrefProvider);
    final bottomNavigation = ref.read(bottomNavigationProvider);
    prefs.setInt(prefSelectedIndexKey, bottomNavigation.selectedIndex);
  }

  void getCurrentIndex() async {
    final prefs = ref.read(sharedPrefProvider);
    if(prefs.containsKey(prefSelectedIndexKey)){
      final index=prefs.getInt(prefSelectedIndexKey);
      if(index!=null){
        ref.read(bottomNavigationProvider.notifier)
            .updateSelectedIndex(index);
      }
    }
  }

  void _onItemTapped(int index) {
    ref.read(bottomNavigationProvider.notifier)
        .updateSelectedIndex(index);

    saveCurrentIndex();
  }

  @override
  Widget build(BuildContext context) {
    if (isDesktop() || isWeb()) {
      return largeLayout();
    } else {
      return mobileLayout();
    }
  }

  Widget largeLayout() {
    final isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;
    final selectedColor =
    isDarkMode ? Colors.brown[400] : Colors.brown[50];

    return AdaptiveLayout(
      topNavigation: SlotLayout(
        config: <Breakpoint, SlotLayoutConfig>{
          Breakpoints.standard:SlotLayout.from(
              key: const Key('TopNavigation'),
              builder: (_){
                return Padding(
                  padding: topPadding16,
                  child:  Container(
                    color: selectedColor ,
                    height: 90,
                    child: _buildSearchCard(),
                  ),
                );


              }
          )
        },
      ),
      primaryNavigation: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig>{
            Breakpoints.mediumAndUp: SlotLayout.from(
                key: const Key('PrimaryNavigation'),
                builder: (_) {
                  return Container(
                    decoration: BoxDecoration(color: selectedColor),
                    child: AdaptiveScaffold.standardNavigationRail(
                      destinations: getRailNavigations(),
                      onDestinationSelected: (int index) {
                        _onItemTapped(index);
                      },
                      labelType: NavigationRailLabelType.all,
                      selectedIndex: ref
                          .watch(bottomNavigationProvider)
                          .selectedIndex,
                      backgroundColor: selectedColor,
                      selectedIconTheme: IconTheme.of(context)
                          .copyWith(color: Colors.brown),
                      unselectedIconTheme:
                      IconTheme.of(context).copyWith(color: Colors.black),
                    ),

                  );
                }
            )
          }
      ),
      body: SlotLayout(
        config: <Breakpoint, SlotLayoutConfig?>{
          Breakpoints.standard: SlotLayout.from(
            key: const Key('body'),
            builder: (_) {
              return Stack(
                children: [
                  Container(
                    color: Colors.white,
                    child: IndexedStack(
                      index: ref
                          .watch(bottomNavigationProvider)
                          .selectedIndex,
                      children: pageList,
                    ),
                  ),
                  Positioned(
                    bottom: 22,
                    right: 22,
                    child: buildFloatingActionButton(context),

                  ),

                ],
              );

            },
          ),
        },
      ),
      bottomNavigation: SlotLayout(
        config: <Breakpoint, SlotLayoutConfig?>{
          Breakpoints.small: SlotLayout.from(
              key: const Key('bottomNavigation'),
              builder: (_) => createBottomNavigationBar())
        },
      ),
    );
  }


  Widget searchWidgets() {
    double screenWidth = MediaQuery.of(context).size.width; // Ensure screenWidth is defined

    if (undoreturn  && screenWidth <= 500 && typyping) {
      return Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                searchTextController.text = '';
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.mic_none_rounded),
            onPressed: () {
              setState(() {
                searchTextController.text = 'Yet to be implemented ';
              });
            },
          ),
        ],
      );
    }

    else if (undoreturn && screenWidth <= 500) {
      return  Row(
        children: [
          IconButton(
            icon: const Icon(Icons.mic_none_rounded),
            onPressed: () {
              setState(() {
                searchTextController.text = 'Yet to be implemented ';
              });
            },
          ),
        ],
      );
    } else if (undoreturn && screenWidth > 500 && typyping) {
      return Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                searchTextController.text = '';
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.mic_none_rounded),
            onPressed: () {
              setState(() {
                searchTextController.text = 'Yet to be implemented ';
              });
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onSelected: (String value) {
              // Add logic for menu selection
            },
            itemBuilder: (BuildContext context) {
              List<String> callMenu = ["Call history", "Setting", "Help and Feedback"];
              return callMenu.map((String value) {
                return PopupMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList();
            },
          ),
        ],
      );
    } else {
      return Row(
        children: [
          IconButton(
            icon: const Icon(Icons.mic_none_rounded),
            onPressed: () {
              setState(() {
                searchTextController.text = 'Yet to be implemented ';
              });
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onSelected: (String value) {
              // Add logic for menu selection
            },
            itemBuilder: (BuildContext context) {
              List<String> callMenu = ["Call history", "Setting", "Help and Feedback"];
              return callMenu.map((String value) {
                return PopupMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList();
            },
          ),
        ],
      );
    }
  }



  List<NavigationRailDestination> getRailNavigations() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final selectedColor =    isDarkMode ? Colors.deepOrangeAccent : Colors.orange;
    return [
      const NavigationRailDestination(
        icon: Icon(Icons.star_border_outlined),
        label: Text('Favourites',
            style: TextStyle(fontSize: 10)),
        selectedIcon: Icon(Icons.star),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.watch_later_outlined),
        label: Text('Recent',
            style: TextStyle(fontSize: 10)),
        selectedIcon: Icon(Icons.watch_later),
      ),

      const NavigationRailDestination(
        icon: Icon(Icons.supervisor_account_outlined),
        label: Text('Contacts',
            style: TextStyle(fontSize: 10)),
        selectedIcon: Icon(Icons.supervisor_account_sharp),
      ),

    ];

  }
  Widget _buildSearchCard() {
    screenWidth=MediaQuery.of(context).size.width;
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                //    startSearch(searchTextController.text);
                final currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
            ),
            sizedW16,
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search Contacts',
                        ),
                        autofocus: false,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) {
                          //     startSearch(searchTextController.text);
                        },
                        controller: searchTextController,

                        focusNode: textFieldFocusNode,
                        onChanged: (value){
                          if(value.isEmpty) {
                            setState(() {
                              typyping=false;

                            });
                          }else{
                            setState(() {
                              typyping=true;
                            });
                          }
                        },





                      )
                  ),

                  searchWidgets(),




                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mobileLayout(){
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final selectedColor =
    isDarkMode ? Colors.brown[400] : Colors.brown[50];

    return Scaffold(
      appBar: AppBar(
        elevation: 8.0,

        backgroundColor: selectedColor,
        toolbarHeight: 80.0,
        title: Padding(
          padding: topPadding8,
          child:  SizedBox(
            height: 60,
            child: _buildSearchCard(),
          ),
        ),

      ),
      floatingActionButton: buildFloatingActionButton(context),
      bottomNavigationBar: createBottomNavigationBar(),
      body: SafeArea(
        child: IndexedStack(

          index: ref.watch(bottomNavigationProvider).selectedIndex,
          children: pageList,

        ),
      ),
    );
  }


  NavigationBar createBottomNavigationBar() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = isDarkMode ? Colors.white : Colors.black;
    final unSelectedItemColor = isDarkMode ? Colors.white : Colors.grey[350];


    List<NavigationDestination> appBarDestinations =  [

      NavigationDestination(
        icon: Icon(Icons.star_border_outlined,
          color: unSelectedItemColor,
        ),
        label: 'Favourites',

        selectedIcon: Icon(Icons.star,
          color: selectedColor,
        ),
      ),
      NavigationDestination(
        icon: Icon(Icons.watch_later_outlined
          ,
          color: unSelectedItemColor,


        ),
        label: 'Recent',

        selectedIcon: Icon(Icons.watch_later
          ,
          color: selectedColor,),
      ),

      NavigationDestination(
        icon: Icon(Icons.supervisor_account_outlined,
          color: unSelectedItemColor,),
        label: 'Contacts',

        selectedIcon: Icon(Icons.supervisor_account_sharp,
          color: selectedColor,),
      ),
    ];

    final backgroundColor =
    isDarkMode ? Colors.brown[400] : Colors.brown[50];

    final bottomNavigationIndex=
        ref.watch(bottomNavigationProvider).selectedIndex;






    return NavigationBar(
      selectedIndex:bottomNavigationIndex,
      onDestinationSelected: (index) {
        _onItemTapped(index);

      },
      destinations: appBarDestinations,
      backgroundColor: backgroundColor,

    );






  }



}