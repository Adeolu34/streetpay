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

  // Test Case A: lowercase: accountNumber, bvn, nin
  var rA = http.MultipartRequest('POST', Uri.parse('https://api.mypingapi.com/sp/myhandler'));
  rA.headers['Authorization'] = 'Bearer $token';
  rA.fields['theKey'] = '11000';
  rA.fields['accountNumber'] = '1100767497';
  rA.fields['bvn'] = '22534258964';
  rA.fields['nin'] = '12345678901';
  rA.files.add(http.MultipartFile.fromBytes('proofOfAddressVerification', imgBytes, filename: 'proof.jpg'));
  print('Case A (accountNumber, bvn, nin): ${(await http.Response.fromStream(await rA.send())).body}');

  // Test Case B: AccountNumber, BVN, NIN
  var rB = http.MultipartRequest('POST', Uri.parse('https://api.mypingapi.com/sp/myhandler'));
  rB.headers['Authorization'] = 'Bearer $token';
  rB.fields['theKey'] = '11000';
  rB.fields['AccountNumber'] = '1100767497';
  rB.fields['BVN'] = '22534258964';
  rB.fields['NIN'] = '12345678901';
  rB.files.add(http.MultipartFile.fromBytes('proofOfAddressVerification', imgBytes, filename: 'proof.jpg'));
  print('Case B (AccountNumber, BVN, NIN): ${(await http.Response.fromStream(await rB.send())).body}');

  // Test Case C: What if an empty string or null is passed for accountNumber?
  var rC = http.MultipartRequest('POST', Uri.parse('https://api.mypingapi.com/sp/myhandler'));
  rC.headers['Authorization'] = 'Bearer $token';
  rC.fields['theKey'] = '11000';
  rC.fields['accountNumber'] = '';
  rC.fields['bvn'] = '22534258964';
  rC.fields['nin'] = '12345678901';
  rC.files.add(http.MultipartFile.fromBytes('proofOfAddressVerification', imgBytes, filename: 'proof.jpg'));
  print('Case C (empty accountNumber): ${(await http.Response.fromStream(await rC.send())).body}');

  // Test Case D: What if bvn is invalid?
  var rD = http.MultipartRequest('POST', Uri.parse('https://api.mypingapi.com/sp/myhandler'));
  rD.headers['Authorization'] = 'Bearer $token';
  rD.fields['theKey'] = '11000';
  rD.fields['accountNumber'] = '1100767497';
  rD.fields['bvn'] = '11111111111';
  rD.fields['nin'] = '12345678901';
  rD.files.add(http.MultipartFile.fromBytes('proofOfAddressVerification', imgBytes, filename: 'proof.jpg'));
  print('Case D (invalid BVN): ${(await http.Response.fromStream(await rD.send())).body}');

  // Test Case E: What if tier: '3' is included?
  var rE = http.MultipartRequest('POST', Uri.parse('https://api.mypingapi.com/sp/myhandler'));
  rE.headers['Authorization'] = 'Bearer $token';
  rE.fields['theKey'] = '11000';
  rE.fields['tier'] = '3';
  rE.fields['accountNumber'] = '1100767497';
  rE.fields['bvn'] = '22534258964';
  rE.fields['nin'] = '12345678901';
  rE.files.add(http.MultipartFile.fromBytes('proofOfAddressVerification', imgBytes, filename: 'proof.jpg'));
  print('Case E (with tier: 3): ${(await http.Response.fromStream(await rE.send())).body}');

  // Test Case F: What if account number doesn't exist?
  var rF = http.MultipartRequest('POST', Uri.parse('https://api.mypingapi.com/sp/myhandler'));
  rF.headers['Authorization'] = 'Bearer $token';
  rF.fields['theKey'] = '11000';
  rF.fields['accountNumber'] = '9999999999';
  rF.fields['bvn'] = '22534258964';
  rF.fields['nin'] = '12345678901';
  rF.files.add(http.MultipartFile.fromBytes('proofOfAddressVerification', imgBytes, filename: 'proof.jpg'));
  print('Case F (non-existent account): ${(await http.Response.fromStream(await rF.send())).body}');
}
