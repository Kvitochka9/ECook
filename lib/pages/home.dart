import 'package:flutter/material.dart';
import 'package:my_app/pages/liked.dart';
import 'package:my_app/pages/party.dart';
import 'package:my_app/pages/listmode.dart';
import 'package:my_app/pages/search.dart';
import 'package:my_app/profile_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: SizedBox(),
        title: Text('ECook', style: TextStyle(color: Colors.black, fontSize: 34, fontFamily: 'Steppe')),
        centerTitle: true,
        backgroundColor: Colors.white70,
        actions: [
          IconButton(
            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileView()));},
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async=>false,
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage(
              'img/background.jpg',
            ),
              fit: BoxFit.fill,)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ListMode()));
                      },
                      child: Text(
                        'Список рецептів',
                        style: TextStyle(color: Colors.black, fontSize: 36, fontFamily: 'Caveat-VariableFont_wght'),
                        textAlign: TextAlign.center,
                      ),
                      style: ElevatedButton.styleFrom(fixedSize: Size(250, 100), alignment: Alignment.center,backgroundColor: Colors.redAccent.withOpacity(0.8)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.redAccent.withOpacity(0.8),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: 'Сподобались',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_search_rounded),
            label: 'Пошук',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 0) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
            } else if(index == 1){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage()));
            }
          });
        },
      ),
    );
  }
}
