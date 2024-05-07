import 'package:converter/episode_details.dart';
import 'package:flutter/material.dart';


class AllEpisodes extends StatefulWidget {
  const AllEpisodes({key, required this.episodes}) : super(key: key);
  final List<Map<String, dynamic>> episodes;
  @override
  State<AllEpisodes> createState() => _AllEpisodesState();
}

class _AllEpisodesState extends State<AllEpisodes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text('All Episodes'),
        backgroundColor: const Color.fromARGB(255, 0, 174, 197),
      ),
      body: ListView.builder(
        itemCount: widget.episodes.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => EpisodeDetails(data: widget.episodes[index]))
              );
            },
            title: Text(widget.episodes[index]['name'], style: TextStyle(color: Colors.white),),
            subtitle: Text('Episode ${index + 1}', style: TextStyle(color: Colors.grey[500]),),
          );
        },
      ),
    );
  }
}