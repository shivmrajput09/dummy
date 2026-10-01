import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiServices {

Future<List<UserModel>> getUsers() async { 
   final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users'),
  );
  print(response.statusCode);

 final data = jsonDecode(response.body);

return(data as List)
.map((json) => UserModel.fromJson(json))
.toList();


 }

}

