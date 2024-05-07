import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'character_details.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';



class LocationDetails extends StatefulWidget {
  const LocationDetails({Key? key, required this.data}) : super(key: key);
  final Map<String, dynamic> data;

  @override
  State<LocationDetails> createState() => _LocationDetailsState();
}
  Map<String, List<Map<String, dynamic>>> episodesCache = {};

class _LocationDetailsState extends State <LocationDetails> { 
    List<Map<String, dynamic>> residents= [];
    bool isFetching = true;

    Future<List<Map<String, dynamic>>> fetchResidents(List<String> residentsUrl) async {
      for (var url in residentsUrl) {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          residents.add(jsonDecode(response.body));
          print(residents.length);
        } else {
          throw Exception('Failed to load episode');
        }
      }
      return residents;
    }

  @override
  void initState() { 
    super.initState();
    List<String> residentsUrl = List<String>.from(widget.data['residents']);
    if (episodesCache.containsKey(widget.data['name'])) {
      residents = episodesCache[widget.data['name']]!;
      isFetching = false;
    } else {
      fetchResidents(residentsUrl).then((value) {
        setState(() {
          residents = value;
          episodesCache[widget.data['name']] = value;
          isFetching = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 174, 197),
        title: Text(widget.data['name']),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  Text(
                    'Location:',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${widget.data['type']} - ${widget.data['name']}',
                    style:  const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      'Dimension:',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text(
                    'Dimension: ${widget.data['dimension']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      'Residents:',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              )
            ),
            isFetching ? YoutubeShimmer() : Expanded(
              key: PageStorageKey('characters'),
              // padding: EdgeInsets.all(1.0),
              child: ResponsiveGridList(
                desiredItemWidth: 150, 
                children: List.generate(residents.length, (index){
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
                                data: residents[index],
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
                                image: NetworkImage(residents[index]['image']),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible( 
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                    child: Text(
                                      residents[index]['name'],
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
                                            color: residents[index]['species'] == 'Human' ? Colors.blue[400] 
                                            : residents[index]['species'] == 'Alien' ? Colors.purple[300] 
                                            : residents[index]['species'] == 'Humanoid' ? Colors.red[400] 
                                            : residents[index]['species'] == 'Cronenberg' ? Colors.blue[400] 
                                            : residents[index]['species'] == 'Mythological Creature' ? Colors.amber[600]
                                            : residents[index]['species'] == 'Animal' ? Colors.pink[400]
                                            : residents[index]['species'] == 'Robot' ? Colors.black
                                            : residents[index]['species'] == 'Disease' ? Colors.purple[800]
                                            : residents[index]['species'] == 'unknown' ? Colors.grey[400] 
                                            : residents[index]['species'] == 'Parasite' ? Colors.green[700]
                                            : residents[index]['species'] == 'Vampire' ? Colors.red[700]
                                            : residents[index]['species'] == 'Poopybutthole' ? Colors.blue[800]
                                            : Colors.blue[400],
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                                            child: Text(
                                              residents[index]['species'] == 'Mythological Creature' ? 'Myth Creature' : residents[index]['species'],
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
                                            color: residents[index]['status'] == 'Alive' ? Colors.green
                                            : residents[index]['status'] == 'Dead' ? Colors.grey[800]
                                            : Colors.grey[400],
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                                            child: Text(
                                              residents[index]['status'] ,
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
          ]
        )
      ),
    );
  }
}