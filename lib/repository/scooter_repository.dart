import 'package:scooter_app/model/scooter_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScooterRepository {
  final String baseUrl;

  ScooterRepository({required this.baseUrl});

  // create
  Future<void> saveScooter(ScooterModel scooter) async {
    final response = await http.post(
      Uri.parse('$baseUrl/save'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(scooter.toJson()..remove('id')),
    );   

    if (response.statusCode != 200) {
      handleError(response);
    }
  }

  // read
  Future<List<ScooterModel>> getScooters() async {
    final response = await http.get(Uri.parse('$baseUrl/get'));

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body)['scooters'];
      final List<ScooterModel> scooters = json.map((e) => ScooterModel.fromJson(e)).toList();
      return scooters;
    } else {
      handleError(response);
      return [];
    }
  }

  // update
  Future<void> updateScooter(ScooterModel scooter) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(scooter.toJson()),
    );

    if (response.statusCode != 200) { 
      handleError(response);
    }
  }

  // delete
  Future<void> deleteScooter(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));

    if (response.statusCode != 200) {
      handleError(response);
    }
  }
}

void handleError(http.Response response) {
  if (response.statusCode == 400) {
    throw Exception('Scooter already exists');
  } else if (response.statusCode == 404) {
    throw Exception('Scooter not found');
  } else {
    throw Exception('Failed to save scooter');
  }
}