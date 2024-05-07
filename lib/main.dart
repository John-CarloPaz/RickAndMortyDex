import 'package:flutter/material.dart';
import 'homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Main(title: 'Homepage',),
    );
  }
}

class Main extends StatefulWidget {
  const Main({key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Main> createState() => _FirstRouteState();
}

class _FirstRouteState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Home',)),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 100, 0, 100),
                  padding: const EdgeInsets.fromLTRB(0, 100, 0, 100),
                  child: Image.asset(
                    'assets/randm.webp',
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}