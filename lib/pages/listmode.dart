import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/recipe_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class ListMode extends StatefulWidget {
  const ListMode({Key? key}) : super(key: key);

  @override
  _ListModeState createState() => _ListModeState();
}

class _ListModeState extends State<ListMode> {
  bool _isAdmin = false;

  @override
  void initState() {
    _loadFilmsFromFirebase();
    _checkAdminStatus();
    super.initState();
  }

  List<Map<String, dynamic>> _films = [];
  List<String> _likedFilmNames = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'ECook',
            style: TextStyle(color: Colors.black, fontSize: 25, fontFamily: 'Steppe'),
          ),
          centerTitle: true,
          backgroundColor: Colors.white70,
          elevation: 4,
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                'img/background.jpg',
                fit: BoxFit.fill,
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: _films.length,
                itemBuilder: (context, index) {
                  return RecipeCard(
                    name: _films[index]['name'],
                    idigo: _films[index]['idigo'],
                    url: _films[index]['url'],
                    steps: _films[index]['steps'],
                    compl: _films[index]['compl'],
                    time: _films[index]['time'],
                    isLiked: _likedFilmNames.contains(_films[index]['name']),
                    onLike: () {
                      _toggleLikeStatus(_films[index]['name']);
                    },
                    onDelete: () {
                      _deleteFilm(_films[index]['name']);
                    },
                    isAdmin: _isAdmin,
                  );
                },
              ),
            ),
          ],
        ));
  }

  void _loadFilmsFromFirebase() {
    FirebaseFirestore.instance.collection('recipes').get().then((QuerySnapshot querySnapshot) {
      _films.clear();
      querySnapshot.docs.forEach((DocumentSnapshot doc) {
        Map<String, dynamic> filmData = {
          'name': doc['name'],
          'idigo': doc['idigo'],
          'url': doc['url'],
          'steps': doc['steps'],
          'compl': doc['compl'],
          'time': doc['time'],
        };
        _films.add(filmData);
      });
      setState(() {});
    });
    _loadLikedFilmsFromLocalStorage();
  }

  void _loadLikedFilmsFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> likedFilmNames = prefs.getStringList('likedFilmNames') ?? [];
    setState(() {
      _likedFilmNames = likedFilmNames;
    });
  }

  void _saveLikedFilmsToLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('likedFilmNames', _likedFilmNames);
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
        break;
      default:
        break;
    }
  }

  void _toggleLikeStatus(String filmName) {
    setState(() {
      if (_likedFilmNames.contains(filmName)) {
        _likedFilmNames.remove(filmName);
      } else {
        _likedFilmNames.add(filmName);
      }
      _saveLikedFilmsToLocalStorage();
    });
  }

  void _deleteFilm(String filmName) {
    FirebaseFirestore.instance
        .collection('recipes')
        .where('name', isEqualTo: filmName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
        _deleteFilmFromLiked(filmName);
      });
      _loadFilmsFromFirebase();
    });
  }

  void _deleteFilmFromLiked(String filmName) {
    setState(() {
      if (_likedFilmNames.contains(filmName)) {
        _likedFilmNames.remove(filmName);
        _saveLikedFilmsToLocalStorage();
      }
    });
  }

  void _checkAdminStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot adminSnapshot =
      await FirebaseFirestore.instance.collection('admins').doc('admins').get();
      if (adminSnapshot.exists && adminSnapshot['email'] == user.email) {
        setState(() {
          _isAdmin = true;
        });
      }
    }
  }
}

class RecipeCard extends StatelessWidget {
  final String name;
  final List<dynamic> idigo;
  final String url;
  final List<dynamic> steps;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onDelete;
  final bool isAdmin;
  final int compl;
  final int time;

  RecipeCard({
    required this.name,
    required this.idigo,
    required this.url,
    required this.steps,
    required this.isLiked,
    required this.onLike,
    required this.onDelete,
    required this.isAdmin,
    required this.compl,
    required this.time,

  });

  @override
  Widget build(BuildContext context) {
    return InkWell( onTap:(){Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeScreen(name: name,idigo: idigo,url: url,steps: steps,isLiked: isLiked,compl: compl,time: time)));},
      child: Card(
        margin: EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 250,child: Image.network(url,width: double.infinity, fit: BoxFit.contain)),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$name',
                    style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, fontFamily: 'Caveat-VariableFont_wght'),
                  ),

                  Row(
                    children: [
                      Icon(Icons.star,color: compl>0? Colors.yellow.shade900:Colors.grey.withOpacity(0.6)),
                      Icon(Icons.star,color: compl>1? Colors.yellow.shade900:Colors.grey.withOpacity(0.6)),
                      Icon(Icons.star,color: compl>2? Colors.yellow.shade900:Colors.grey.withOpacity(0.6)),
                      Icon(Icons.star,color: compl>3? Colors.yellow.shade900:Colors.grey.withOpacity(0.6)),
                      Icon(Icons.star,color: compl>4? Colors.yellow.shade900:Colors.grey.withOpacity(0.6)),
                    ],
                  )
                ],
              ),
              Container(color:Colors.black, height: 1, width: double.infinity,),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                    color: isLiked ? Colors.red : null,
                    onPressed: onLike,
                  ),
                  // Додано умову для відображення кнопки видалення
                  if (isAdmin)
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: onDelete,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}