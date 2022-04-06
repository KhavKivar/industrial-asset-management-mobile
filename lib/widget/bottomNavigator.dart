import 'package:app_licman/const/Colors.dart';
import 'package:app_licman/model/state/common_var_state.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ui/tables_pages/dispatcher_device_table.dart';
import '../ui/tables_pages/top_navigator_table.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  late int _selectedIndex;
  @override
  void didChangeDependencies() {
    _selectedIndex = Provider.of<CommonState>(context).selectIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      if (_selectedIndex == index) {
        return;
      }
      if (index == 0) {
        Provider.of<CommonState>(context, listen: false).changeActaIndex(0);

        Navigator.maybePop(context);
      } else if (index == 1) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TableDispatcher()));
      }
      Provider.of<CommonState>(context, listen: false).changeIndex(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      descendantsAreFocusable: false,
      child: BottomNavigationBar(
          backgroundColor: dark,
          unselectedItemColor: Colors.white,
          selectedItemColor: yellowBackground,
          unselectedFontSize: 15,
          selectedFontSize: 17,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.content_paste),
              label: 'Actas/Movimientos',
            ),
          ]),
    );
  }
}
