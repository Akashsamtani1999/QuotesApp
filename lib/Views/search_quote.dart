import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quotes/Services/functions.dart';

import '../main.dart';

class SearchQuote extends StatefulWidget {
  const SearchQuote({Key? key}) : super(key: key);

  @override
  _SearchQuoteState createState() => _SearchQuoteState();
}

class _SearchQuoteState extends State<SearchQuote> {
  @override

  var response;
  var data;
  var search;
  double count = 10;


  httpGet(String url)async{
    response = await http.get(Uri.parse(url));
    print(response);
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search any Quotes"),
        actions: [
          IconButton(onPressed: (){
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 200,
                  // color: Color,
                  child: Center(
                    child: Slider(
                      value: count,
                      max: 100,
                      divisions: 5,
                      label: count.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          count = value;
                        });
                      },
                    ),
                  ),
                );
              },
            );
          }, icon: Icon(Icons.settings))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Slider(
                  value: count,
                  min: 1,
                  max: 100,
                  divisions: 100,
                  label: count.round().toString(),
                  onChanged: (double value) async {
                    setState(() {
                      count = value;
                    });
                    await httpGet("https://api.quotable.io/search/quotes?query=$search&limit=$count");
                  },
                ),
                CupertinoSearchTextField(
                  onChanged: (value)async{
                    setState(() {
                      search = value;
                    });
                    await httpGet("https://api.quotable.io/search/quotes?query=$search&limit=$count");
                  },
                ),
                data!=null?Container(
                  height: MediaQuery.of(context).size.height- AppBar().preferredSize.height-80,
                  child: ListView.builder(
                    itemCount: data["results"].length,
                    itemBuilder: (BuildContext context, int index) {
                      return  index < data["results"].length != ""?Card(
                        elevation: 3,
                        child: ListTile(
                          title:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(data["results"][index]["author"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              favouriteIds.contains(data["results"][index]["_id"]) ? IconButton(
                                // icon: Icon(favIcon,color: favcolor,),
                                icon: const Icon(Icons.favorite,color: Colors.pinkAccent,),
                                onPressed: () async {
                                  setState(() {
                                    favouriteIds.remove(data["results"][index]["_id"]);
                                  });
                                  final rowsDeleted = await dbHelper.delete(data["results"][index]["_id"].toString());
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
                                  insert(data["results"][index]["_id"],data["results"][index]["author"],data["results"][index]["content"],data["results"][index]["tags"].toString());

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
                              Text(data["results"][index]["tags"].toString()),
                              SizedBox(height: 10,),
                              Text(data["results"][index]["content"].toString()),
                              SizedBox(height: 10,),
                            ],
                          ),
                        ),
                      ):SizedBox();
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
