import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('Testing BsptokenCall to 51.20.210.26...');
  try {
    final resp = await http.post(
      Uri.parse('http://51.20.210.26/sp/Dial/waas/api/v1/authenticate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": "streetpay",
        "password": "vLYQNa6fUNIlkJT7BB5GJAGmPwD8txv08c9mw7nukHq3CzMcFl",
        "clientId": "waas",
        "clientSecret": "vU92FQrUPGr9Z8djZu76f0l1uJQlohAv"
      }),
    ).timeout(const Duration(seconds: 5));
    print('BsptokenCall status: ${resp.statusCode}');
    print('BsptokenCall body: ${resp.body}');
  } catch (e) {
    print('BsptokenCall error: $e');
  }

  print('\nTesting StreetauthCall to AuthSP...');
  try {
    final resp2 = await http.post(
      Uri.parse('https://api.mypingapi.com/sp/AuthSP'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': 'Paysp1010\$i.i',
        'secretKey': '\$2a\$10\$3JK3bVeSVXW0xrVzqmvUmu/tX.XLoUqbwPxTYqZdDz1QHMB2jhDxm',
      }),
    ).timeout(const Duration(seconds: 5));
    print('StreetauthCall status: ${resp2.statusCode}');
    print('StreetauthCall body: ${resp2.body}');
  } catch (e) {
    print('StreetauthCall error: $e');
  }
}
