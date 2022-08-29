import 'package:food_delivery/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient extends GetConnect implements GetxService {
  late String token;
  final String appBaseUrl;
  late Map<String, String> _mainHeaders;
  late SharedPreferences sharedPreferences;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    baseUrl = appBaseUrl;
    timeout = const Duration(seconds: 30);
    if (sharedPreferences.containsKey(AppConstants.TOKEN)) {
      token = sharedPreferences.getString(AppConstants.TOKEN)!;
    } else {
      token = '';
    }

    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  void updateHeader(String token) {
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Response> getData(String uri, {Map<String, String>? header}) async {
    print( header.toString() );
    print( _mainHeaders.toString() );
    print(uri);
    try {
      Response response = await get(uri, headers: header ?? _mainHeaders);
      print(response.body.toString());
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postData(String uri, dynamic body) async {
    print( _mainHeaders.toString() );
    print(body.toString());
    print(uri);
    try {
      Response response = await post(uri, body, headers: _mainHeaders);
      print(response.body.toString());
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
}
