import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'episode_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllEpisodes extends StatefulWidget {
  const AllEpisodes({key, required this.title}) : super(key: key);
  final String title;

  @override
  State<AllEpisodes> createState() => _AllEpisodesState();
}

class _AllEpisodesState extends State <AllEpisodes> { 
  List<Map<String, dynamic>> data = [];
    fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? episodes = prefs.getString('allEpisodes');
    if (episodes != null) {
      setState(() {
        data = List<Map<String, dynamic>>.from(json.decode(episodes));
      });
      return;
    }
    for (var i = 1; i <= 3; i++) {
      try {
        final response = await http.get(Uri.parse('https://rickandmortyapi.com/api/episode/?page=$i'));
        if (response.statusCode == 200) {
          setState(() {
            data.addAll((json.decode(response.body)['results'] as List)
                .map((item) => item as Map<String, dynamic>)
                .toList());
          });
          prefs.setString('AllEpisodes', json.encode(data)); // save data to cache
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
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.grey[850],
              child: ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EpisodeDetails(data: data[index]),
                  ),
                ),
                title: Text(
                  data[index]['name'], 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                ),
                subtitle: Text(
                  data[index]['episode'], 
                  style: TextStyle(color: Colors.grey[500])
                ),
                trailing: Text(
                  data[index]['air_date'], 
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}