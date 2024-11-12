import 'package:dio/dio.dart';
import '../models/app_config.dart';
import 'package:get_it/get_it.dart';

class HTTPService {
  final Dio dio = Dio();
  AppConfiguration? _appConfig;
  String? _base_url;
  HTTPService() {
    _appConfig = GetIt.instance.get<AppConfiguration>();
    _base_url = _appConfig!.COIN_API_BASE_URL;
    print(_base_url);
  }

  Future<Response?> get(String path) async {
    try {
      String url = '$_base_url$path';
      Response response = await dio.get(url);
      return (response);
    } catch (e) {
      print('HTTPservice: Unable to perform get request');
      print(e);
    }
    return null;
  }
}
