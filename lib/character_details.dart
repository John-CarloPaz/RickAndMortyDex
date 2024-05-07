import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:converter/all_episodes_per_char.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({key, required this.data}) : super(key: key);
  final Map<String, dynamic> data;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}
  Map<String, List<Map<String, dynamic>>> episodesCache = {};

class _DetailScreenState extends State<DetailScreen> {
  List<Map<String, dynamic>> episodes = [];
  bool isFetching = true;

  Future<List<Map<String, dynamic>>> fetchAllEpisodes(List<String> episodeUrls) async {
    for (var url in episodeUrls) {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        episodes.add(jsonDecode(response.body));
        print(episodes.toString());
      } else {
        throw Exception('Failed to load episode');
      }
    }

    return episodes;
  }

@override
void initState() {
  super.initState();
  List<String> episodeUrls = List<String>.from(widget.data['episode']);

  if (episodesCache.containsKey(widget.data['name'])) {
    episodes = episodesCache[widget.data['name']]!;
    isFetching = false;
  } else {
    fetchAllEpisodes(episodeUrls).then((value) {
      setState(() {
        episodes = value;
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.network(
              widget.data['image'],
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(8.0, 5.0, 0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Character Name:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${widget.data['name']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0 ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  'Status & Species:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[500],
                                    fontSize: 14,
                                  ),
                              ),  
                              Row(
                                children: <Widget>[
                                  Icon(Icons.circle, size: 10.0, color: widget.data['status'] == 'Alive' ?  Colors.green[500] : Colors.red[500] ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 5.0),
                                    child: Text(
                                      '${widget.data['status']} - ${widget.data['species']}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (widget.data['type'] != '') Container(
                            margin: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Type:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[500],
                                    fontSize: 14,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.circle, size: 10.0, color: widget.data['status'] == 'Alive' ?  Colors.green[500] : Colors.red[500] ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        '${widget.data['type']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )                         
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Gender:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            ),  
                            Text(
                              '${widget.data['gender']} - ${widget.data['species']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),      
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Origin:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.circle, size: 10.0, color: widget.data['status'] == 'Alive' ?  Colors.green[500] : Colors.red[500] ),
                                Container(
                                  margin: const EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    '${widget.data['origin']['name']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )                         
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Episode Appearance:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
            ),
            isFetching ? const YoutubeShimmer() : SizedBox(
              height: 400,
              child: 
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: episodes.length > 7 ? 7 : episodes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      textColor: Colors.white,
                      title: Text(
                        episodes[index]['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )
                      ),
                      subtitle: Text(
                        episodes[index]['episode'],
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        )
                      ),
                    );
                  },
                ),
            ),
            if (episodes.length > 4)
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllEpisodes(episodes: episodes)),
                      );
                    },
                  child:  Text('View all episodes', style: TextStyle(color: Colors.cyan[800])),
                  ), 
            )
          ],
        ),
      ),
    );
  }
}