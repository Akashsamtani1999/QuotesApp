import 'package:flutter/material.dart';
import 'package:quotes/Views/author_quote.dart';
import 'package:quotes/Views/favourite_quote.dart';
import 'package:quotes/Views/search_quote.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text("Quotes",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: Colors.white),),
          actions: [
            IconButton(
              icon: Icon(Icons.favorite),
              color: Colors.pinkAccent,
              onPressed: () {
                //Navigate to favourite screen

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavouriteQuote()),
                );
              },
            ),
          ]
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal:50,vertical: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: const Text(
                  '    Author Quote    ',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AuthorQuote()),
                  );
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: const Text(
                  'Search any Quote',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchQuote()),
                  );
                },
              ),
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
