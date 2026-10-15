import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  final authResp = await http.post(
    Uri.parse('https://api.mypingapi.com/sp/AuthSP'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'userId': 'Paysp1010\$i.i',
      'secretKey': '\$2a\$10\$3JK3bVeSVXW0xrVzqmvUmu/tX.XLoUqbwPxTYqZdDz1QHMB2jhDxm',
    }),
  );
  final token = jsonDecode(authResp.body)['token'];
  final imgBytes = File('build/test_output.jpg').readAsBytesSync();

  print('=== PROBE 1: Missing all fields ===');
  var resp = await http.post(
    Uri.parse('https://api.mypingapi.com/sp/myhandler'),
    headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/x-www-form-urlencoded'},
    body: {'theKey': '11000'},
  );
  print('Probe 1: ${resp.body}');

  print('\n=== PROBE 2: Form-urlencoded with 4 fields (proof as base64) ===');
  resp = await http.post(
    Uri.parse('https://api.mypingapi.com/sp/myhandler'),
    headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/x-www-form-urlencoded'},
    body: {
      'theKey': '11000',
      'accountNumber': '1100767497',
      'bvn': '22534258964',
      'nin': '12345678901',
      'proofOfAddressVerification': base64Encode(imgBytes),
    },
  );
  print('Probe 2 (base64 in form): ${resp.body}');

  print('\n=== PROBE 3: JSON body with 4 fields ===');
  resp = await http.post(
    Uri.parse('https://api.mypingapi.com/sp/myhandler'),
    headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
    body: jsonEncode({
      'theKey': '11000',
      'accountNumber': '1100767497',
      'bvn': '22534258964',
      'nin': '12345678901',
      'proofOfAddressVerification': base64Encode(imgBytes),
    }),
  );
  print('Probe 3 (JSON): ${resp.body}');

  print('\n=== PROBE 4: Multipart with theKey, accountNumber, bvn, nin (without proof) ===');
  var mReq = http.MultipartRequest('POST', Uri.parse('https://api.mypingapi.com/sp/myhandler'));
  mReq.headers['Authorization'] = 'Bearer $token';
  mReq.fields['theKey'] = '11000';
  mReq.fields['accountNumber'] = '1100767497';
  mReq.fields['bvn'] = '22534258964';
  mReq.fields['nin'] = '12345678901';
  var mStream = await mReq.send();
  print('Probe 4 (Multipart without proof): ${(await http.Response.fromStream(mStream)).body}');

  print('\n=== PROBE 5: Multipart with field names case-insensitivity ===');
  mReq = http.MultipartRequest('POST', Uri.parse('https://api.mypingapi.com/sp/myhandler'));
  mReq.headers['Authorization'] = 'Bearer $token';
  mReq.fields['theKey'] = '11000';
  mReq.fields['AccountNumber'] = '1100767497';
  mReq.fields['BVN'] = '22534258964';
  mReq.fields['NIN'] = '12345678901';
  mReq.files.add(http.MultipartFile.fromBytes('proofOfAddressVerification', imgBytes, filename: 'proof.jpg'));
  mStream = await mReq.send();
  print('Probe 5 (Capitalized fields): ${(await http.Response.fromStream(mStream)).body}');

  print('\n=== PROBE 6: What if user phone / token user is needed? ===');
  mReq = http.MultipartRequest('POST', Uri.parse('https://api.mypingapi.com/sp/myhandler'));
  mReq.headers['Authorization'] = 'Bearer $token';
  mReq.fields['theKey'] = '11000';
  mReq.fields['accountNumber'] = '1100767497';
  mReq.fields['phone'] = '2349024706049';
  mReq.fields['bvn'] = '22534258964';
  mReq.fields['nin'] = '12345678901';
  mReq.files.add(http.MultipartFile.fromBytes('proofOfAddressVerification', imgBytes, filename: 'proof.jpg'));
  mStream = await mReq.send();
  print('Probe 6 (with phone): ${(await http.Response.fromStream(mStream)).body}');
}
