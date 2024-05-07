import 'dart:convert';
import 'package:converter/all_locations.dart';
import 'package:converter/all_episodes.dart';
import 'package:converter/character_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_grid/responsive_grid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> data = [];
  fetchData() async {
    for (var i = 1; i <= 42; i++) {
      try {
        final response = await http.get(Uri.parse('https://rickandmortyapi.com/api/character/?page=$i'));
        if (response.statusCode == 200) {
          setState(() {
            data.addAll((json.decode(response.body)['results'] as List)
                .map((item) => item as Map<String, dynamic>)
                .toList());
          });
        } else {
          throw Exception('Failed to load characters');
        }
      } catch (e) {
        print('Error fetching data: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

 @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[800],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(widget.title),
          backgroundColor: const Color.fromARGB(255, 0, 174, 197),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.face)),
              Tab(icon: Icon(Icons.place)),
              Tab(icon: Icon(Icons.smart_display)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              key: PageStorageKey('characters'),
              padding: EdgeInsets.all(1.0),
              child: ResponsiveGridList(
                desiredItemWidth: 150, 
                children: List.generate(data.length, (index){
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Card(
                      elevation: 4.0,
                      color: Colors.grey[700],
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                data: data[index],
                              ),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                              child:
                              FadeInImage(
                                placeholder: const AssetImage('assets/images/placeholder.png'),
                                image: NetworkImage(data[index]['image']),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible( 
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                    child: Text(
                                      data[index]['name'],
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),  
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget> [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 10.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: data[index]['species'] == 'Human' ? Colors.blue[400] 
                                            : data[index]['species'] == 'Alien' ? Colors.purple[300] 
                                            :  data[index]['species'] == 'Humanoid' ? Colors.red[400] 
                                            : data[index]['species'] == 'Cronenberg' ? Colors.blue[400] 
                                            : data[index]['species'] == 'Mythological Creature' ? Colors.amber[600]
                                            : data[index]['species'] == 'Animal' ? Colors.pink[400]
                                            : data[index]['species'] == 'Robot' ? Colors.black
                                            : data[index]['species'] == 'Disease' ? Colors.purple[800]
                                            : data[index]['species'] == 'unknown' ? Colors.grey[400] 
                                            : data[index]['species'] == 'Parasite' ? Colors.green[700]
                                            : data[index]['species'] == 'Vampire' ? Colors.red[700]
                                            : data[index]['species'] == 'Poopybutthole' ? Colors.blue[800]
                                            : Colors.blue[400],
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                                            child: Text(
                                              data[index]['species'] == 'Mythological Creature' ? 'Myth Creature' : data[index]['species'],
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 10.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: data[index]['status'] == 'Alive' ? Colors.green
                                            : data[index]['status'] == 'Dead' ? Colors.grey[800]
                                            : Colors.grey[400],
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                                            child: Text(
                                              data[index]['status'] ,
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ]),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
            ),
            ),
            AllLocations(title: 'Locations'),  
            AllEpisodes(title: 'Episodes'),          
          ],
        ),
      )
    );
  }
}