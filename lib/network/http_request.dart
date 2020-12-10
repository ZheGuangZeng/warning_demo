import 'package:dio/dio.dart';

class HttpRequest {
  //创建一个dio
  static BaseOptions baseOptions =
      BaseOptions(baseUrl: 'http://106.14.248.81:3000', connectTimeout: 5000);
  static final dio = Dio(baseOptions);
  static Future request(String url,
      {String method = 'get', Map<String, dynamic> params}) async {
    //发送请求
    Options options = Options(method: method);
    try {
      final result =
          await dio.request(url, queryParameters: params, options: options);
      return result;
    } on DioError catch (err) {
      throw err;
    }
  }
}
