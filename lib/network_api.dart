import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ServerRequestCards {
  int id;
  int row;
  int seq_num;
  String text;

  ServerRequestCards(this.id, this.row, this.seq_num, this.text);
}

class ServerRequest {
  static late dynamic cards;
  static String _token = '';
  static late String _name;
  static late String _password;
  static Future<void> obtainToken() async {
    var dio = Dio();
    var res = await dio.post(
        "https://trello.backend.tests.nekidaem.ru/api/v1/users/login/",
        data: {"username": _name, "password": _password});
    print("in data obtainToken = ${res}");

    _token = res.data["token"];
  }

  static Future<void> refreshToken() async {
    var dio = Dio();

    var res = await dio.post(
        "https://trello.backend.tests.nekidaem.ru/api/v1/users/refresh_token/",
        data: {
          "token": _token,
        });
    print("in data refreshToken = ${res}");

    _token = res.data["token"];
  }

  static bufUserData({required String name, required String password}) {
    _name = name;
    _password = password;
  }

  static Future<int> fetchCardsInfo() async {
    var dio = Dio();
    try {
      await refreshToken();
      print("after refresh");
    } catch (err) {
      {
        try {
          await obtainToken();
        } on DioError catch (err) {
          print("глубокая жопа");
          return err.response!.statusCode!;
        }
      }
    } finally {
      try {
        print("in try");
        var res = await dio.get(
            "https://trello.backend.tests.nekidaem.ru/api/v1/cards/",
            options: Options(headers: {"Authorization": "JWT ${_token}"}));
        print("in data = ${res}");
        cards = res.data;
        return -1;
      } on DioError catch (onError) {
        print("err bufUserData ${onError} ");

        return onError.response!.statusCode!;
      }
    }
  }
}
