import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchQuery = '';
  late TextEditingController controller;
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Пошук блюд',
          style: TextStyle(color: Colors.black, fontSize: 25, fontFamily: 'Steppe'),
        ),
        centerTitle: true,
        backgroundColor: Colors.white70,
        elevation: 4,
      ),
      body: Stack(
        children: [
          Image.asset(
            'img/background.jpg', // Замініть 'img/background.jpg' на ваш шлях до зображення
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  onChanged: (value) {
                    _searchResults.clear();
                    // setState(() {
                    //   _searchQuery = controller.text;
                    //   _performSearch();
                    // });
                  },
                  onEditingComplete: () {
                    if (controller.text != '' && controller.text != _searchQuery) {
                      setState(() {
                        _searchQuery = controller.text;
                        _performSearch();
                      });
                    }
                  },
                  controller: controller,
                  decoration: InputDecoration(
                    suffix: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          if (controller.text != '' && controller.text != _searchQuery) {
                            setState(() {
                              _searchQuery = controller.text;
                              _performSearch();
                            });
                          }
                        }),
                    labelText: 'Пошук за ім\'ям або інгредієнтами',
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: _buildSearchResults(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text('Немає результатів пошуку'),
      );
    } else {
      return ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          return RecipeCard(
            name: _searchResults[index]['name'],
            idigo: _searchResults[index]['idigo'],
            url: _searchResults[index]['url'],
            steps: _searchResults[index]['steps'],
            compl: _searchResults[index]['compl'],
            time: _searchResults[index]['time'],
          );
        },
      );
    }
  }

  void _performSearch() {
    // Виконання пошуку в базі даних Firestore
    FirebaseFirestore.instance.collection('recipes').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((DocumentSnapshot doc) {
        // Перевірка, чи задовольняє документ умовам пошуку
        if (_matchesSearchQuery(doc)) {
          Map<String, dynamic> recipeData = {
            'name': doc['name'],
            'idigo': doc['idigo'],
            'url': doc['url'],
            'steps': doc['steps'],
            'compl': doc['compl'],
            'time': doc['time'],
          };
          if (_searchResults.contains(recipeData)) {
            return;
          } else {
            print(recipeData.entries.toString());
            _searchResults.add(recipeData);
          }
        }
      });

      // Оновлення інтерфейсу після виконання пошуку
      setState(() {});
    });
  }

  bool _matchesSearchQuery(DocumentSnapshot doc) {
    // Перевірка, чи документ відповідає умовам пошуку
    String name = doc['name'].toLowerCase();
    List<dynamic> idigo = doc['idigo'];
    String query = _searchQuery.toLowerCase();

    return name.contains(query) || idigo.any((ingr) => ingr.toLowerCase().contains(query));
  }
}

class RecipeCard extends StatelessWidget {
  final String name;
  final List<dynamic> idigo;
  final String url;
  final List<dynamic> steps;
  final int compl;
  final int time;

  RecipeCard({
    required this.name,
    required this.idigo,
    required this.url,
    required this.steps,
    required this.compl,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
          ],
        ),
      ),
    );
  }
}
