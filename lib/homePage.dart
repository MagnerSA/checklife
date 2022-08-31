import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.red,
                    height: 25,
                    width: 350,
                    child: Center(child: Text("Teste de elemento $index")),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
