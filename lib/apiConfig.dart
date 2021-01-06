import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model.dart';

class TodoUtils {

  static final String _baseUrl = "https://parseapi.back4app.com/classes/";

  //Create
  static Future addTodo(TodoAdd todo) async{
    String apiUrl = _baseUrl + "Todo";
    var response = await http.post(apiUrl, headers: {
        'X-Parse-Application-Id' : 'Your Application Id',
        'X-Parse-REST-API-Key' : 'Your Api Key',
        'Content-Type' : 'application/json'
      }, body: json.encode(todo.toJson()),);
      return response;
  }

  //Read
  static Future fetchTodo() async { 
  String apiUrl = _baseUrl + "Todo";
  var response = await http.get(apiUrl, headers: {
        'X-Parse-Application-Id' : 'Your Application Id',
          'X-Parse-REST-API-Key' : 'Your Api Key'
      }); 
      if(response.statusCode == 200) {
          var jsonString = json.decode(response.body);
          final results =  jsonString["results"];
          return results;
       } else {
         
       }
} 

  //Update
  static Future updateTodo(Todo todo) async {
     String apiUrl = _baseUrl + "Todo/${todo.objectId}";
     var response = await http.put(apiUrl, headers: {
        'X-Parse-Application-Id' : 'Your Application Id',
        'X-Parse-REST-API-Key' : 'Your Api Key',
        'Content-Type' : 'application/json'
      }, body: json.encode(todo.toJson()),);
      return response;
  }


  //Delete
  static Future deleteTodo(String objectId) async {
    String apiUrl = _baseUrl + "Todo/$objectId";
     var response = await http.delete(apiUrl, headers: {
        'X-Parse-Application-Id' : 'Your Application Id',
        'X-Parse-REST-API-Key' : 'Your Api Key'
      });
      return response;
  }


}