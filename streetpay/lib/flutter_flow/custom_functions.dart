import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/auth/custom_auth/auth_util.dart';

String stripSlash(String? value) {
  if (value == null || value.isEmpty) {
    return "";
  }

  var parts = value.split("/");
  return parts.length > 1 ? parts[1] : "";
}

String removeLastChar(String value) {
  return value.length > 1 ? value.substring(0, value.length - 1) : "";
}

String appendPinCodeDigit(
  String pinCode,
  String digit,
  int limit,
) {
  return pinCode.length < limit ? "${pinCode}${digit}" : pinCode;
}

double stringtodouble(String? stringinput) {
  // convert stringinput to double
  if (stringinput == null) {
    return 0.0;
  }
  return double.tryParse(stringinput) ?? 0.0;
}

String? removecode(String stringInput) {
  // extract the first 10 digit using negative indeing and then add 234 to the front
  if (stringInput.length < 10) {
    return null;
  }

  String firstTenDigits = stringInput.substring(stringInput.length - 10);
  String result = '234$firstTenDigits';

  return result;
}

String? addcode(String? inputstring) {
  // extract the first 10 digit using negative indexing and then add 234 to the beginning
  if (inputstring == null || inputstring.length < 10) {
    return null;
  }

  String firstTenDigits = inputstring.substring(inputstring.length - 10);
  String result = '0$firstTenDigits';

  return result;
}

double sumalltran(List<String> translist) {
  double sum = 0.0;
  for (String amount in translist) {
    if (amount.isNotEmpty && amount != 'null') {
      final clean = amount.replaceAll(',', '').trim();
      final val = double.tryParse(clean);
      if (val != null) {
        sum += val;
      }
    }
  }
  return double.parse(sum.toStringAsFixed(2));
}


DateTime? addtodate(DateTime? inputdate) {
  // add 7 days to the inputdate
  if (inputdate != null) {
    return inputdate.subtract(Duration(days: 2));
  }
  return null;
}

/// Returns a date [days] before today, formatted as 'yyyy-MM-dd'.
/// Used to compute the from-date for the 30-day recent activity window.
String subtractDaysFromToday(int days) {
  final result = DateTime.now().subtract(Duration(days: days));
  return DateFormat('yyyy-MM-dd').format(result);
}

String? datetostring(DateTime? dateinput) {
  // convert dateinput to string
  if (dateinput != null) {
    return DateFormat('yyyy-MM-dd').format(dateinput);
  } else {
    return null;
  }
}

String? accountstrip(String? accountno) {
  // get the first 4 character and last 2 character of the string and replace the rest by ****
  if (accountno == null || accountno.length < 6) {
    return accountno;
  }

  String firstFour = accountno.substring(0, 4);
  String lastTwo = accountno.substring(accountno.length - 2);
  String masked = '*' * (accountno.length - 6);

  return '$firstFour$masked$lastTwo';
}

LatlangStruct latlangsplit(LatLng? locationinput) {
  // the values will be splited into two, the lat separately and the lang separatly so that i can assign them to the data type independently
  if (locationinput != null) {
    return LatlangStruct(
      lat: locationinput.latitude,
      lang: locationinput.longitude,
    );
  } else {
    return LatlangStruct(lat: 0.0, lang: 0.0);
  }
}

String getlat(LatLng? locationinput) {
  // get the lat of the locationinput
  if (locationinput != null) {
    return locationinput.latitude.toString();
  } else {
    return '';
  }
}

String getBankCode(
  dynamic apiResponse,
  String bankName,
) {
  if (bankName.trim().isEmpty) return "";
  final trimmedBankName = bankName.trim().toLowerCase();

  if (trimmedBankName.contains('streetpay') ||
      trimmedBankName.contains('street pay') ||
      trimmedBankName == '9psb') {
    return '120001';
  }

  List<dynamic>? bankList;
  if (apiResponse is Map) {
    if (apiResponse.containsKey('bankList') && apiResponse['bankList'] is List) {
      bankList = apiResponse['bankList'] as List<dynamic>;
    } else if (apiResponse.containsKey('data') && apiResponse['data'] is Map) {
      final dataMap = apiResponse['data'] as Map;
      if (dataMap.containsKey('bankList') && dataMap['bankList'] is List) {
        bankList = dataMap['bankList'] as List<dynamic>;
      }
    }
  } else if (apiResponse is List) {
    bankList = apiResponse;
  }

  if (bankList != null) {
    String? partialMatchCode;
    // Single pass to check both exact and partial matches instead of redundant multiple-loop passes
    for (var bank in bankList) {
      if (bank is Map && bank['bankName'] != null && bank['bankCode'] != null) {
        final currentName = bank['bankName'].toString().trim().toLowerCase();
        if (currentName == trimmedBankName) {
          return bank['bankCode'].toString();
        }
        if (partialMatchCode == null &&
            (currentName.contains(trimmedBankName) || trimmedBankName.contains(currentName))) {
          partialMatchCode = bank['bankCode'].toString();
        }
      }
    }
    if (partialMatchCode != null) {
      return partialMatchCode;
    }
  }

  // 3. Fallback well-known NIBSS codes for top Nigerian institutions
  const knownCodes = {
    'streetpay': '120001',
    'street pay': '120001',
    '9psb': '120001',
    '9 payment service bank': '120001',
    'opay': '100004',
    'paycom': '100004',
    'paycom(opay)': '100004',
    'palmpay': '100033',
    'moniepoint': '090405',
    'moniepoint mfb': '090405',
    'kuda': '090267',
    'kuda bank': '090267',
    'access bank': '044',
    'gtbank': '058',
    'guaranty trust bank': '058',
    'zenith bank': '057',
    'united bank for africa': '033',
    'uba': '033',
    'first bank': '011',
    'first bank of nigeria': '011',
    'fidelity bank': '070',
    'union bank': '032',
    'sterling bank': '232',
    'wema bank': '035',
    'alat by wema': '035',
    'fcmb': '214',
    'first city monument bank': '214',
    'providus bank': '101',
    'stanbic ibtc': '221',
  };

  if (knownCodes.containsKey(trimmedBankName)) {
    return knownCodes[trimmedBankName]!;
  }

  for (final entry in knownCodes.entries) {
    if (trimmedBankName.contains(entry.key) || entry.key.contains(trimmedBankName)) {
      return entry.value;
    }
  }

  return "";
}

String formatNgnPhone(String? phone) {
  if (phone == null || phone.isEmpty) return '';
  final digits = phone.replaceAll(RegExp(r'\D'), '');
  if (digits.length >= 10) {
    return '0${digits.substring(digits.length - 10)}';
  }
  return phone;
}

String? getlang(LatLng? locationinput) {
  // get the longitude from the locationinput
  if (locationinput != null) {
    return locationinput.longitude.toString();
  } else {
    return null;
  }
}

bool areItemsPresent(dynamic apiResponse) {
  // Check if the API response is valid and contains a "data" key
  if (apiResponse != null &&
      apiResponse is Map &&
      apiResponse.containsKey('data')) {
    var data = apiResponse['data'];

    // Ensure "data" is a list
    if (data is List) {
      for (var entry in data) {
        // Check if an entry contains the "items" key with a non-empty list
        if (entry is Map &&
            entry.containsKey('items') &&
            entry['items'] is List &&
            entry['items'].isNotEmpty) {
          return true; // Items are present
        }
      }
    }
  }
  return false; // Items not found
}

List<String> extractItemNames(dynamic apiResponse) {
  if (apiResponse is Map && apiResponse['data'] is List) {
    return [
      for (final entry in (apiResponse['data'] as List))
        if (entry is Map && entry['items'] is List)
          for (final item in (entry['items'] as List))
            if (item is Map && item['itemName'] != null)
              item['itemName'].toString()
    ];
  }
  return [];
}

double extractAmount(String itemName) {
  // Regular expression:
  // Match numbers formatted with commas (e.g., 9,690) or standalone numbers (e.g., 9690)
  final RegExp numericPattern = RegExp(r'\d{1,3}(,\d{3})*|\d+');

  // Find all matches in the input string
  final matches = numericPattern.allMatches(itemName);

  if (matches.isNotEmpty) {
    // Extract all matched numeric strings, remove commas, and parse them as doubles
    final amounts = matches.map((match) {
      String numericString =
          match.group(0)!.replaceAll(',', ''); // Remove commas
      return double.tryParse(numericString) ?? 0.0; // Convert to double
    }).toList();

    // Return the largest numeric value
    return amounts.isNotEmpty ? amounts.reduce(math.max) : 0.0;
  }

  // Return 0.0 if no valid number is found
  return 0.0;
}

String getItemIdByItemName(
  dynamic apiResponse,
  String selectedItemName,
) {
  if (apiResponse is Map && apiResponse['data'] is List) {
    for (final entry in (apiResponse['data'] as List)) {
      if (entry is Map && entry['items'] is List) {
        for (final item in (entry['items'] as List)) {
          if (item is Map && item['itemName'] == selectedItemName) {
            return item['itemId']?.toString() ?? '';
          }
        }
      }
    }
  }
  return '';
}

String getIdByName(
  dynamic apiResponse,
  String selectedName,
) {
  // Validate apiResponse structure
  if (apiResponse is Map && apiResponse.containsKey('data')) {
    var data = apiResponse['data'];

    // Ensure 'data' is a list
    if (data is List) {
      for (var entry in data) {
        // Check if entry is a Map and has the matching 'name'
        if (entry is Map && entry['name'] == selectedName) {
          return entry['id'] ?? ''; // Return the id if found
        }
      }
    }
  }

  return ''; // Return empty string if no match is found
}

List<dynamic> filterDataPlansByValidity(
  List<dynamic> response,
  String validity,
) {
  // Initialize an empty list to store filtered data plans
  List<Map<String, String>> filteredDataPlans = [];

  try {
    // Check if response is a List and iterate over it
    for (var item in response) {
      // Parse each item if it's a JSON string
      Map<String, dynamic> plan = item is String ? jsonDecode(item) : item;

      // Validate 'validity' and required keys
      if (plan is Map<String, dynamic> &&
          plan['validity'] == validity &&
          plan.containsKey('dataBundle') &&
          plan.containsKey('productId') &&
          plan.containsKey('amount')) {
        // Add the filtered plan to the list with key details
        filteredDataPlans.add({
          'dataBundle': plan['dataBundle'],
          'amount': plan['amount'],
          'productId': plan['productId'],
          'validity': plan['validity'],
        });
      }
    }
  } catch (e) {
    // Handle any potential errors during parsing or iteration
    print('Error parsing or filtering data: $e');
    return [];
  }

  return filteredDataPlans;
}

String? geterror(String inputstring) {
  // Extract the error message from a JSON string with dynamic keys
  try {
    if (inputstring.isEmpty) {
      throw Exception('Input string is empty');
    }

    // Decode the input string into a Map
    Map<String, dynamic> errorMap = json.decode(inputstring);

    // Check if the map is not empty and return the first value (error message)
    if (errorMap.isNotEmpty) {
      return errorMap.values.first;
    }

    // If the map is empty, return null
    return null;
  } catch (e) {
    print('Error: $e');
    return null; // Return null if parsing fails
  }
}

String changetosentencecase(String inputstring) {
  // I want to convert letters like this EXAM & RESULT to Exam & Result
  return inputstring.toLowerCase().split(' ').map((word) {
    if (word.isNotEmpty) {
      return word[0].toUpperCase() + word.substring(1);
    } else {
      return '';
    }
  }).join(' ');
}

String? doublestrike(String inputstrike) {
  // okay can you return naira sign
  return '₦ $inputstrike';
}

String getbankname(
  dynamic banklist,
  String selectedbank,
) {
  // TypeError: null: type 'JSNull' is not a subtype of type 'Iterable<dynamic>'
  if (banklist == null || selectedbank.isEmpty) {
    return '';
  }

  if (banklist is Iterable<dynamic>) {
    for (var bank in banklist) {
      if (bank['bankName'] == selectedbank) {
        return bank['bankName'];
      }
    }
  }

  return '';
}

String? gettransactionref(String? inputjson) {
  // {   "phoneNumber": "09024706049",   "network": "MTN",   "amount": "100",   "debitAccount": "1100039029",   "transactionReference": "JNJIJIOJIJIOKISDFJI" } extract the transactionReference value from the inputjson
  if (inputjson != null) {
    Map<String, dynamic> jsonMap = json.decode(inputjson);
    return jsonMap['transactionReference'];
  }
  return null;
}

String? stripnarration(String? narration) {
  // "narration":"STREETPAY/BILLSPAYMENT/BP-ABUJA/1234567890/STP-REF56YAKJBZJL9VQPW/BP-ABUJA/1100039029" i want to strip this string and get this string "BILLSPAYMENT" i think we should use positional stripping
  if (narration == null) {
    return null;
  }

  final parts = narration.split('/');
  if (parts.length < 2) {
    return null;
  }

  return parts[1];
}

int? subtractdates(
  DateTime? firstdate,
  DateTime? seconddate,
) {
  // subtract second date from first date and give me the number of days in between
  if (firstdate == null || seconddate == null) {
    return null;
  }

  Duration difference = seconddate.difference(firstdate);
  int days = difference.inDays;

  return days;
}

List<String> stringtolist(String inputstring) {
// convert string like this "P1, Y9, C7, M4, J0, B6, D3, X8, T2, Q5" to list of strings using , as the delimiter
  List<String> parts = inputstring.split(',').map((s) => s.trim()).toList();

  return parts; // Return the list of strings
}

String? getwin(List<dynamic> stringlist) {
  int winCount = 0;

  for (var item in stringlist) {
    // Check if WinStatus is exactly "WIN"
    if (item['WinStatus'] == 'WIN') {
      winCount++;
    }
  }

  return winCount > 0 ? winCount.toString() : '0'; // Return as String
}

dynamic stringtojson(String? inputstring) {
  // convert string to json
  if (inputstring == null || inputstring.isEmpty) {
    return null; // Return null for empty or null strings
  }

  inputstring = inputstring.trim(); // Trim whitespace from the input string

  // Create a JSON object from the input string
  return {"message": inputstring}; // Return as a JSON object
}

int? sumguess(List<int> guesses) {
  if (guesses.isEmpty) {
    return 0; // Return null if the list is empty
  }
  return guesses.fold<int>(
      0, (sum, element) => sum + element); // Sum all elements starting from 0
}

DateTime? stringtotimstamp(String? input) {
  if (input == null || input.isEmpty) {
    return null; // Handle null or empty input
  }

  try {
    int millisecondsSinceEpoch = int.parse(input); // Convert string to integer
    return DateTime.fromMillisecondsSinceEpoch(
        millisecondsSinceEpoch); // Convert to DateTime
  } catch (e) {
    return null; // Return null if conversion fails
  }
}

String? getfirstletter(String input) {
  if (input.isEmpty) {
    return null; // Return null if the input string is empty
  }
  return input[0].toUpperCase(); // Get the first letter and conv
}

int? stringtoint(String? input) {
  // convert string to integer
  if (input == null) {
    return null; // Return null if input is null
  }
  return int.tryParse(input); // Convert string to integer
}

FFUploadedFile? base64ToImage(String? base64Image) {
  if (base64Image == null || base64Image.trim().isEmpty) {
    return null;
  }
  var clean = base64Image.trim();
  if (clean.contains(',')) {
    clean = clean.split(',').last;
  }
  clean = clean.replaceAll(RegExp(r'\s+'), '');
  try {
    final bytes = base64.decode(clean);
    if (bytes.isEmpty) return null;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    return FFUploadedFile(bytes: bytes, name: fileName);
  } catch (_) {
    return null;
  }
}

String? stringtovideopath(String? videourl) {
  if (videourl == null) return null;
  Uri uri = Uri.parse(videourl);
  String? videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;

  // Return the original URL if the videoId is not null
  return videoId != null ? videourl : null;
}

String? extract4lastdigit(String? textinput) {
  // i want to extract the last 4 digit from a textinput
  if (textinput != null && textinput.length >= 4) {
    return textinput.substring(textinput.length - 4);
  }
  return null;
}

String formatdate(String date) {
  // i want to convert date in this format yyyy-MM-dd e.g 1985-02-05 to dd/MM/yyyy 05/02/1985
  if (date.isEmpty) return '';
  try {
    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  } catch (e) {
    return '';
  }
}

String processTransactionNarration(String narration) {
  if (narration.isEmpty) return narration;

  String processedNarration = narration.trim();

  // Transfer transactions
  if (processedNarration.startsWith('Transfer out to')) {
    final parts = processedNarration.split('/');
    if (parts.length >= 2) {
      final accountNumber = parts[0].replaceAll('Transfer out to ', '').trim();
      processedNarration = 'Transfer to Account $accountNumber';
    }
  }
  // STP transactions
  else if (processedNarration.startsWith('STP/')) {
    final parts = processedNarration.split('/');
    if (parts.length >= 3) {
      final serviceType = parts[1].trim();
      final provider = parts[2].trim();

      switch (serviceType) {
        case 'AIRTIME':
          if (parts.length >= 5) {
            final phoneNumber = parts[4].trim();
            processedNarration = 'Airtime Purchase - $provider ($phoneNumber)';
          } else {
            processedNarration = 'Airtime Purchase - $provider';
          }
          break;
        case 'DATA':
          if (parts.length >= 5) {
            final phoneNumber = parts[4].trim();
            processedNarration = 'Data Purchase - $provider ($phoneNumber)';
          } else {
            processedNarration = 'Data Purchase - $provider';
          }
          break;
        case 'BILLSPAYMENT':
          if (parts.length >= 4) {
            final biller = parts[3].trim();
            processedNarration = 'Bill Payment - $biller';
          } else {
            processedNarration = 'Bill Payment';
          }
          break;
        default:
          processedNarration = 'StreetPay Service - $serviceType';
      }
    }
  }
  // Moneycode transactions
  else if (processedNarration.startsWith('Moneycode/')) {
    processedNarration = 'Moneycode Transaction';
  }
  // Coupon transactions
  else if (processedNarration.startsWith('coupon_create_')) {
    final parts = processedNarration.split('_');
    if (parts.length >= 3) {
      final amount = parts[2].split('/')[0].trim();
      processedNarration = 'Coupon Creation - ₦$amount';
    } else {
      processedNarration = 'Coupon Creation';
    }
  }
  // EMTL Fee transactions
  else if (processedNarration == 'EMTL Fee') {
    processedNarration = 'Transaction Fee';
  }
  // Reversal transactions
  else if (processedNarration.startsWith('Reversal of')) {
    processedNarration = 'Transaction Reversal';
  }
  // Bank transfers with account numbers
  else if (processedNarration.contains('/') &&
      processedNarration.contains('1100742371')) {
    final parts = processedNarration.split('/');
    if (parts.length >= 2) {
      final senderName = parts[1].trim();
      processedNarration = 'Transfer from $senderName';
    }
  }
  // Generic account number patterns
  else if (RegExp(r'^\d{10}$').hasMatch(processedNarration)) {
    processedNarration = 'Transfer to Account $processedNarration';
  }

  // Smart cleanup - remove dates, integers, and technical references
  processedNarration = processedNarration
      // Remove technical references
      .replaceAll(RegExp(r'STP-REF[A-Z0-9]+'), '')
      .replaceAll(RegExp(r'DCBREF[A-Z0-9]+'), '')
      .replaceAll(RegExp(r'BP-[A-Z]+'), '')
      .replaceAll(RegExp(r'STP_REF[A-Z0-9]+'), '')
      .replaceAll(RegExp(r'RA\d+'), '')

      // Remove dates (various formats)
      .replaceAll(RegExp(r'\d{4}-\d{2}-\d{2}'), '') // YYYY-MM-DD
      .replaceAll(RegExp(r'\d{2}/\d{2}/\d{4}'), '') // DD/MM/YYYY
      .replaceAll(RegExp(r'\d{2}-\d{2}-\d{4}'), '') // DD-MM-YYYY
      .replaceAll(RegExp(r'\d{8}'), '') // YYYYMMDD
      .replaceAll(RegExp(r'\d{6}'), '') // YYMMDD

      // Remove long numeric sequences (likely reference numbers)
      .replaceAll(RegExp(r'\d{10,}'), '')

      // Remove account numbers and short numeric patterns
      .replaceAll(RegExp(r'/\d{10}'), '')
      .replaceAll(RegExp(r'/\d{6}'), '')
      .replaceAll(RegExp(r'/\d{3}'), '')
      .replaceAll(RegExp(r'\d{3,6}'), '')

      // Remove standalone numbers (amounts, fees, etc.)
      .replaceAll(RegExp(r'\b\d+\.?\d*\b'), '')

      // Clean up separators and formatting
      .replaceAll(RegExp(r'//+'), '/')
      .replaceAll(RegExp(r'^/'), '')
      .replaceAll(RegExp(r'/$'), '')
      .replaceAll(RegExp(r'^[-_\s]+'), '') // Remove leading separators
      .replaceAll(RegExp(r'[-_\s]+$'), '') // Remove trailing separators
      .replaceAll(RegExp(r'[-_\s]{2,}'),
          ' ') // Replace multiple separators with single space
      .trim();

  // Extract meaningful words and clean up
  final words = processedNarration
      .split(' ')
      .where((word) =>
              word.isNotEmpty &&
              word.length > 2 &&
              !RegExp(r'^\d+$').hasMatch(word) && // Not just numbers
              !RegExp(r'^[A-Z0-9]{8,}$')
                  .hasMatch(word) // Not long alphanumeric codes
          )
      .toList();

  processedNarration = words.join(' ').trim();

  // Final cleanup - remove multiple spaces
  processedNarration =
      processedNarration.replaceAll(RegExp(r'\s+'), ' ').trim();

  // If the processed narration is empty or too short, return a generic description
  if (processedNarration.isEmpty || processedNarration.length < 3) {
    return 'Transaction';
  }

  return processedNarration;
}

String? changeuserstatus(String? userstatus) {
  // get userstatus if userstatus is 0 change to 1 and if it is 1 change to 0
  if (userstatus == '0') {
    return '1';
  } else if (userstatus == '1') {
    return '0';
  }
  return userstatus; // Return the original status if it's neither 0 nor 1
}

bool? getuser(String? usertype) {
  // if usertype is User return false else return true
  return usertype != 'User';
}

bool? newCustomFunction(String? phone) {
  // write a function to validate if a number is a correct Nigeria number
  if (phone == null || phone.isEmpty) return false;
  final RegExp regex = RegExp(
      r'^(?:\+234|0)?(702|701|700|703|704|705|706|707|708|709|70[0-9]|71[0-9]|72[0-9]|73[0-9]|74[0-9]|75[0-9]|76[0-9]|77[0-9]|78[0-9]|79[0-9]|80[0-9]|81[0-9]|82[0-9]|83[0-9]|84[0-9]|85[0-9]|86[0-9]|87[0-9]|88[0-9]|89[0-9]|90[0-9]|91[0-9]|92[0-9]|93[0-9]|94[0-9]|95[0-9]|96[0-9]|97[0-9]|98[0-9]|99[0-9])[0-9]{7}$');
  return regex.hasMatch(phone);
}

String? formatdob(dynamic date) {
  try {
    // If the argument is a JSON string, decode it
    if (date is String && date.trim().startsWith('{')) {
      final decoded = jsonDecode(date);
      date = decoded['data']?['dateOfBirth'];
    } else if (date is Map) {
      // If it's already a map
      date = date['data']?['dateOfBirth'];
    }

    if (date == null || date.toString().isEmpty) return null;

    // Parse and format
    final parsed = DateTime.parse(date.toString());
    return DateFormat('dd/MM/yyyy').format(parsed);
  } catch (e) {
    debugPrint('Error formatting DOB: $e');
    return null;
  }
}

List<String>? getyears() {
  // get the list of 60 years before the current year
  List<String> years = [];
  int currentYear = DateTime.now().year;
  for (int i = 18; i < 100; i++) {
    years.add((currentYear - i).toString());
  }
  return years;
}

String? textformat(String? input) {
  // Remove unnecessary spaces at the start and end
  if (input == null) return null;
  return input.trim();
}

DateTime? formatdbdate(String? date) {
  if (date == null || date.isEmpty) return null;

  try {
    // Convert formats like "2025-11-21 22:47:00" → "2025-11-21T22:47:00"
    final normalized = date.contains('T') ? date : date.replaceFirst(' ', 'T');

    return DateTime.parse(normalized);
  } catch (e) {
    debugPrint('Error formatting DOB: $e');
    return null;
  }
}

bool? iseven(int? number) {
  // check if number is even return true else return false
  if (number == null) return null; // Return null if the input is null
  return number % 2 == 0; // Return true if even, false if odd
}

String getBankFullName(String code) {
  // modify this function: String getBankFullName(String code) {   const bankMap = {     'GTB': 'GTBank Plc',     'UBA': 'United Bank for Africa',     'Moniepoint': 'Moniepoint Microfinance Bank',     'Firstbank': 'First Bank of Nigeria',     'Palmpay': 'Palmpay',     'OPAY': 'Paycom(opay)',     'Access': 'Access Bank',     'Zenith': 'Zenith Bank',     'Streetpay': '9 payment service Bank',   };    // Return mapped value or original code if not found   return bankMap[code] ?? code; }
  const bankMap = {
    'GTB': 'GTBank Plc',
    'UBA': 'United Bank for Africa',
    'Moniepoint': 'Moniepoint Microfinance Bank',
    'Firstbank': 'First Bank of Nigeria',
    'Palmpay': 'Palmpay',
    'OPAY': 'Paycom(opay)',
    'Access': 'Access Bank',
    'Zenith': 'Zenith Bank',
    'Streetpay': '9 payment service Bank',
  };

  // Return mapped value or original code if not found
  return bankMap[code] ?? code;
}

bool? passwordconfirm(int? input) {
  // check if a number is a valid 5 digit number, it must not be less or more
  if (input == null) return null; // Check if input is null
  return input >= 10000 &&
      input <= 99999; // Check if input is a valid 5 digit number
}

String replaceBvnAndNin(
  String input,
  String replacement,
) {
  // Bvn Validation Not successful (Phone number supplied not matching NIN phone number replace Bvn and NIN in this message with replacement
  return input.replaceAll('Bvn', replacement).replaceAll('NIN', replacement);
}

int? listtoint(List<String>? input) {
  // just convert the strings to interger not summing, there is no need to sum an number just convert it from list of string to interger  the integer is not a list it is just a regular integer, not the first but all so let us say we have a list of string ["1", "2", "3"], to 123
  if (input == null || input.isEmpty)
    return null; // Check for null or empty list
  return int.tryParse(
      input.join('')); // Convert list of strings to a single integer
}

FFUploadedFile? urltoupload(String? imageurl) {
  if (imageurl == null || imageurl.isEmpty) {
    return null;
  }

  return FFUploadedFile(
    name: imageurl.split('/').last,
    bytes: null,
    height: null,
    width: null,
    blurHash: null,
  );
}
