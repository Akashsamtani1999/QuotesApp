


import 'package:quotes/Services/sqflite_database.dart';

final dbHelper = DatabaseHelper.instance;

insert(String QuoteId,String QuoteName,String QuoteBio,String QuoteDes) async {
    Map<String, dynamic> row = {
       DatabaseHelper.QuoteId : QuoteId,
      DatabaseHelper.QuoteName : QuoteName,
      DatabaseHelper.QuoteBio  : QuoteBio,
      DatabaseHelper.QuoteDes  : QuoteDes
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
}