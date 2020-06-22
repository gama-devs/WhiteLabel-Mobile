import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:whitelabel/src/pages/Login/login.dart';
import 'package:whitelabel/src/pages/Menu/categoryAll.dart';
import 'package:whitelabel/src/pages/Menu/menu.dart';

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => new _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Menu(),
           Login(),
            Container(
              color: Colors.blue,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        containerHeight: 75,
        itemCornerRadius: 20,
        backgroundColor: Color(0xFFFF805D),
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                   fontSize: 18
                ),
              ),
              icon: Icon(
                Icons.home,
                color: Colors.white,
                 size: 26,
              )),
          BottomNavyBarItem(
              title: Text('Sacola', style: TextStyle(
                  color: Colors.white,
                      fontSize: 18
                ),),
              icon:
               Icon(
                Icons.shopping_basket,
                color: Colors.white,
                 size: 26,
              )),
          BottomNavyBarItem(
              title: Text('Pedidos', style: TextStyle(
                  color: Colors.white,
                      fontSize: 18
                ),),
              icon: Icon(
                Icons.chat_bubble,
                color: Colors.white,
                size: 26,
              )),
          BottomNavyBarItem(
              title: Text('Item One', style: TextStyle(
                  color: Colors.white,
                     fontSize: 18
                ),),
              icon: Icon(
                Icons.settings,
                color: Colors.white,
                 size: 26,
              )),
        ],
      ),
    );
  }
}
