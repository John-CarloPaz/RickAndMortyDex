import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'location_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllLocations extends StatefulWidget {
  const AllLocations({key, required this.title}) : super(key: key);
  final String title;
  @override
  State<AllLocations> createState() => _AllLocationsState();
}

class _AllLocationsState extends State <AllLocations> { 
  List<Map<String, dynamic>> data = [];
  fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locations = prefs.getString('allLocations');
    if (locations != null) {
      setState(() {
        data = List<Map<String, dynamic>>.from(json.decode(locations));
      });
      return;
    }
    for (var i = 1; i <= 7; i++) {
      try {
        final response = await http.get(Uri.parse('https://rickandmortyapi.com/api/location/?page=$i'));
        if (response.statusCode == 200) {
          setState(() {
            data.addAll((json.decode(response.body)['results'] as List)
                .map((item) => item as Map<String, dynamic>)
                .toList());
          });
            prefs.setString('allLocations', json.encode(data));

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
                    builder: (context) => LocationDetails(data: data[index]),
                  ),
                ),
                title: Text(
                  data[index]['name'], 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                ),
                subtitle: Text(
                  data[index]['type'], 
                  style: TextStyle(color: Colors.grey[500])
                ),
                trailing: Text(
                  data[index]['dimension'], 
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