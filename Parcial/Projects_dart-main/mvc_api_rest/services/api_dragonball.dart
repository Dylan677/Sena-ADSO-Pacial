// import 'package:http/http.dart' as http;
// import 'dart:convert';

// Future<void> fetchData() async {
//   final response = await http.get(
//     //Uri.parse('https://dragonball-api.com/api/characters'),
//     Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=100'),
//   );
//   if (response.statusCode == 200) {
//     print(jsonDecode(response.body));
//   } else {
//     throw Exception('Error al cargar datos');
//   }
// }

// /**
//  * 1. POST Request
// Used to create a new resource. 
//  */
// Future<http.Response> getDataApi(String token) async {
//   final Uri uri = Uri.parse('http://localhost:3000/api_v1/role');
//   final http.Response response = await http.get(
//     uri,
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': 'Bearer $token', // Add your token here
//     },
//   );
//   if (response.statusCode == 200) {
//     //print('Response body: ${response.body}');
//   } else if (response.statusCode == 401) {
//     print('Unauthorized: Check token.');
//   } else {
//     throw Exception('Failed to perform operation.');
//   }
//   return response;
// }

// Future<http.Response> login(String user, String password) async {
//   final Uri uri = Uri.parse('http://localhost:3000/api_v1/apiUserLogin');
//   final http.Response response = await http.post(
//     uri,
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8', // Add your token here
//     },
//     body: jsonEncode(<String, String>{
//       'api_user': user,
//       'api_password': password,
//     }),
//   );
//   return jsonDecode(response.body);
// }

// /**
//  * 1. POST Request
// Used to create a new resource. 
//  * Future<http.Response> createPost(String title, String token) async {
//   final Uri uri = Uri.parse('https://api.example.com/posts');
//   final http.Response response = await http.post(
//     uri,
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': 'Bearer $token', // Add your token here
//     },
//     body: jsonEncode(<String, String>{
//       'title': title,
//     }),
//   );
//   return response;
// }
// 2. PUT Request
// Used to replace an existing resource with a new version. 
// Future<http.Response> updatePost(int id, String newTitle, String token) async {
//   final Uri uri = Uri.parse('https://api.example.com/posts/$id');
//   final http.Response response = await http.put(
//     uri,
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': 'Bearer $token',
//     },
//     body: jsonEncode(<String, String>{
//       'title': newTitle,
//     }),
//   );
//   return response;
// }
// 3. DELETE Request
// Used to remove a resource. 
// Future<http.Response> deletePost(int id, String token) async {
//   final Uri uri = Uri.parse('https://api.example.com/posts/$id');
//   final http.Response response = await http.delete(
//     uri,
//     headers: <String, String>{
//       'Authorization': 'Bearer $token',
//     },
//   );
//   return response;
// }
// 4. PATCH Request
// Used to apply partial modifications to a resource. 
// Future<http.Response> patchPost(int id, String partialUpdate, String token) async {
//   final Uri uri = Uri.parse('https://api.example.com/posts/$id');
//   final http.Response response = await http.patch(
//     uri,
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': 'Bearer $token',
//     },
//     body: jsonEncode(<String, String>{
//       'status': partialUpdate,
//     }),
//   );
//   return response;
// }
// Response Handling
// After making the request, always check the statusCode of the response to ensure success. For example: 

// if (response.statusCode == 200 || response.statusCode == 201) {
//   // Request successful, handle the response body
//   print('Response body: ${response.body}');
// } else if (response.statusCode == 401) {
//   // Handle unauthorized access (e.g., token expired)
//   print('Unauthorized: Check token.');
// } else {
//   // Request failed, throw an exception or handle the error
//   throw Exception('Failed to perform operation.');
// }

//  * 
// */
// void main() {
//   fetchData();
// }
