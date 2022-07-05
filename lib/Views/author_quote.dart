import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quotes/Services/functions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class AuthorQuote extends StatefulWidget {
  const AuthorQuote({Key? key}) : super(key: key);

  @override
  _AuthorQuoteState createState() => _AuthorQuoteState();
}

class _AuthorQuoteState extends State<AuthorQuote> {
  var response;
  var data;

  Color favcolor = Colors.black;
  IconData favIcon = Icons.favorite_border;

  httpGet(String url)async{
    response = await http.get(Uri.parse(url));
    print(response);

    if (response.statusCode == 200) {
      setState(() {
        data = [];
        data = jsonDecode(response.body);
      });
    }
  }

  Launch(String Url) async{
    final Uri url = Uri.parse(Url);
    if(!await launchUrl(url))throw "Unable to launch Url $url";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Author Quotes"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                CupertinoSearchTextField(
                  onChanged: (value)async{
                    var val;

                    setState(() {
                      val = value;
                    });
                    httpGet("https://api.quotable.io/search/authors?query=$val");
                  },
                ),
                data!=null?Container(
                  height: MediaQuery.of(context).size.height- AppBar().preferredSize.height-80,
                  child: ListView.builder(
                    itemCount: data["results"].length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: (){
                          Launch(data["results"][index]["link"]);
                        },
                        child: Card(
                          elevation: 3,
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(data["results"][index]["name"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                favouriteIds.contains(data["results"][index]["_id"]) ? IconButton(
                                  // icon: Icon(favIcon,color: favcolor,),
                                  icon: Icon(Icons.favorite,color: Colors.pinkAccent,),
                                  onPressed: () async {
                                    setState(() {
                                      favouriteIds.remove(data["results"][index]["_id"]);
                                    });
                                    final rowsDeleted = await dbHelper.delete(data["results"][index]["_id"]);
                                    print('deleted $rowsDeleted row(s): row $data["results"][index]["_id"]');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Removed from favourites'),
                                        )
                                    );
                                  },
                                ):
                                IconButton(
                                  // icon: Icon(favIcon,color: favcolor,),
                                  icon: Icon(Icons.favorite,color: Colors.grey,),
                                  onPressed: (){
                                    setState(() {
                                      favouriteIds.add(data["results"][index]["_id"]);
                                    });
                                    insert(data["results"][index]["_id"],data["results"][index]["name"],data["results"][index]["bio"],data["results"][index]["description"]);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Added to favourite ✅'),
                                        )
                                    );
                                  },
                                ),
                              ],
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data["results"][index]["description"]),
                                SizedBox(height: 10,),
                                Text(data["results"][index]["bio"],style: TextStyle(color: Colors.black),),
                                SizedBox(height: 10,),
                              ],
                            ),
                            // trailing:
                          ),
                        ),
                      );
                    },
                  ),
                ):const Text(""),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
