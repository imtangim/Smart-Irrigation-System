import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_details/screens/landingpage.dart';
import 'package:flutter_details/screens/statistic.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class Bottombar extends ConsumerStatefulWidget {
  final String name;
  const Bottombar(this.name, {super.key});

  @override
  ConsumerState<Bottombar> createState() => _BottombarState();
}

class _BottombarState extends ConsumerState<Bottombar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
       LandingPage(widget.name),
      const Statistic(),
    ];

    return Scaffold(
      // extendBody: true,
      // extendBodyBehindAppBar: true,
      // backgroundColor: Colors.white,
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, //to stop movement of the icon
        currentIndex:
            _selectedIndex, //telling the flutter on which index we should have been right now
        onTap: _onItemTapped, //what would happen on tap
        elevation: 10,
        showSelectedLabels: false, //hiding text
        showUnselectedLabels: false, //hiding text
        selectedItemColor:
            Colors.blueGrey, //what would be the color of selectedItem
        unselectedItemColor:
            const Color(0xFF526480), //what would be the color of unselectedItem
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
            activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
          ),
          BottomNavigationBarItem(
            label: "History",
            icon: Icon(FluentSystemIcons.ic_fluent_history_filled),
            activeIcon: Icon(FluentSystemIcons.ic_fluent_history_filled),
          ),
        ],
      ),
    );
  }
}
