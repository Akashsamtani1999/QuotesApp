import 'package:flutter/material.dart';
import 'package:quotes/Services/sqflite_database.dart';
import 'package:quotes/main.dart';

class FavouriteQuote extends StatefulWidget {
  const FavouriteQuote({Key? key}) : super(key: key);

  @override
  _FavouriteQuoteState createState() => _FavouriteQuoteState();
}

class _FavouriteQuoteState extends State<FavouriteQuote> {

  final dbHelper = DatabaseHelper.instance;
  var allRows;
  void _query() async {
    var Rows = await dbHelper.queryAllRows();
    setState(() {
      allRows = Rows;
    });
  }

  @override
  void initState() {
   _query();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourite Quotes"),
      ),
      body: ListView.builder(
           itemCount: allRows.length,
           itemBuilder: (BuildContext context, int index) {
             return Card(
                 elevation: 3,
                 child: ListTile(
                   title: Row(
                     children: [
                       Text(allRows[index]["name"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

                       IconButton(
                         // icon: Icon(favIcon,color: favcolor,),
                         icon: Icon(Icons.delete,color: Colors.red,),
                         onPressed: () async {
                           setState(() {
                             favouriteIds.remove(allRows[index]["Quoteid"]);
                           });
                           final rowsDeleted = await dbHelper.delete(allRows[index]["Quoteid"].toString());
                          var updatedrows=[];

                         for(int i=0;i<allRows.length;i++){
                           if(i!=index){
                               updatedrows.add(allRows[i]);
                           }
                         }
                         allRows = [];

                         setState(() {
                           allRows = updatedrows;
                         });
                           ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBar(
                                 content: Text('Removed from favourites'),
                               )
                           );
                         },
                       )
                     ],
                   ),
                   subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(allRows[index]["description"]),
                     Text(allRows[index]["bio"]),

                     ],
                  ),

               ),
             );
           }
        ),

    );
  }
}


