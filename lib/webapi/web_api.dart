import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pet/bloc/auth_bloc.dart';
import 'package:pet/helper/constant.dart';
import 'package:pet/helper/utils.dart';
import 'package:pet/injection/dependency_injection.dart';
import 'package:pet/model/base_response.dart';
import 'package:pet/model/err_response.dart';
import 'package:pet/model/refresh.dart';

class WebApi {
  static const baseUrl = "https://pbh-app.herokuapp.com/";

  static String rqLogin = "api/token/";
  static String rqRegister = "api/jwtauth/register/";
  static String rqRefreshToken = "api/token/refresh/";
  static String rqGetEvents = "pets/api/v2/pet_events/";
  static String addPet = "pets/api/v2/pets/";
  static String getPet = "pets/api/v2/pets/";
  static String addEvent = "pets/api/v2/pet_events/";
  static String rqBusinessPhoto = "/business/photo";
  static String rqBusiness = "/business";
  static String rqBusinessMe = "/business/me";
  static String rqProduct = "/product";
  static String rqCategory = "/category";
  static String rqDeleteImage = "/product/photo/";
  static String rqProductUpdate = "/product/update";
  static String terms = "/terms";
  static String privacy = "/privacy/policy";
  static String rating = "/business/ratings";
  static String reviews = "/business/reviews?page=";
  static String reviewReplay = "/business/reply/";
  static String guidelines = "/guidelines";
  static String sendOtp = "/send/otp";
  static String verifyOtp = "/verify/otp";
  static String analytics = "​/analytics";
  static String userProfile = "/user/profile";

  static getRequest(String req, String data) {
    return {'apiRequest': req, 'data': data};
  }

  Dio dio = Dio();

  initDio(String apiReq, int type) {
    var headers;
    String acceptHeader;
    String contentTypeHeader;
    String authorizationHeader =
        Injector.accessToken != null ? 'Bearer ' + Injector.accessToken : null;

//    print("accessToken " + authorizationHeader??"");

    if (type == Const.get) {
      acceptHeader = 'application/json';
    } else if (type == Const.delete) {
      acceptHeader = 'application/json';
    } else if (type == Const.put) {
      acceptHeader = 'application/json';
      contentTypeHeader = 'application/json';
    } else if (type == Const.postWithForm) {
      acceptHeader = 'application/json';
//      contentTypeHeader = 'multipart/form-data';
    } else if (type == Const.getReqNotToken) {
      acceptHeader = 'application/json';
    } else if (type == Const.post || type == Const.postRefreshToken) {
      acceptHeader = 'application/json';
      contentTypeHeader = 'application/json';
//      authorizationHeader = "";
    }

    headers = {
      HttpHeaders.acceptHeader: acceptHeader,
      HttpHeaders.contentTypeHeader: contentTypeHeader,
      HttpHeaders.authorizationHeader: authorizationHeader
    };

    BaseOptions options = new BaseOptions(
        baseUrl: baseUrl + apiReq,
        connectTimeout: 20000,
        receiveTimeout: 3000,
        headers: headers);

    dio.options = options;

    return dio;
  }

  Future<dynamic> callAPI(
    int requestMethod,
    String apiReq,
    Map<String, dynamic> jsonMap,
  ) async {
    initDio(apiReq, requestMethod);
    print("request_" + apiReq);
    print("request_map_  " + jsonMap.toString());
    try {
      var baseResponse;

      if (requestMethod == Const.get || requestMethod == Const.getReqNotToken) {
        await dio.get("").then((response) {
          baseResponse = response.data;
        }).catchError((e) {
          handleException(e, requestMethod, apiReq, jsonMap);
        });
      } else if (requestMethod == Const.delete) {
        await dio.delete("").then((response) {
          baseResponse = response.data;
        }).catchError((e) {
          handleException(e, requestMethod, apiReq, jsonMap);
        });
      } else if (requestMethod == Const.put) {
        await dio.put("", data: jsonMap).then((response) {
          baseResponse = response.data;
        }).catchError((e) async {
          handleException(e, requestMethod, apiReq, jsonMap);
        });
      } else {
        await dio.post("", data: json.encode(jsonMap)).then((response) {
          baseResponse = response.data;
        }).catchError((e) {
          handleException(e, requestMethod, apiReq, jsonMap);
        });
      }

      print(apiReq + "_" + baseResponse.toString());

      return baseResponse;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<RefreshTokenResponse> refreshToken(
      int requestMethod, String apiReq, Map<String, dynamic> jsonMap) async {
    initDio(apiReq, requestMethod);
    RefreshTokenResponse refreshTokenResponse;
    await dio.post("", data: json.encode(jsonMap)).then((response) async {
      if (response.statusCode == HttpStatus.ok) {
        refreshTokenResponse = RefreshTokenResponse.fromJson(response.data);

        await Injector.updateAuthData(refreshTokenResponse.access);

        callAPI(requestMethod, apiReq, jsonMap);
      } else {
        Utils.showToast(response.statusMessage);
      }
    }).catchError((e) {
      ErrorResponse errorResponse = ErrorResponse.fromJson(e.response.data);
      Utils.showToast(errorResponse.detail);
      return null;
    });
    return refreshTokenResponse;
  }

  initDioImg(String apiReq) {
    String acceptHeader = 'application/json';
    String authorizationHeader = 'Bearer ' + Injector.accessToken;
    String contentTypeHeader = 'multipart/form-data';
    print("contentTypeHeader " + acceptHeader);
    print("accessToken " + authorizationHeader);
    var headers = {
      HttpHeaders.acceptHeader: acceptHeader,
      HttpHeaders.authorizationHeader: authorizationHeader,
      HttpHeaders.contentTypeHeader: contentTypeHeader,
    };
    BaseOptions options = new BaseOptions(
        baseUrl: baseUrl + apiReq,
        connectTimeout: 20000,
        receiveTimeout: 3000,
        headers: headers);
    dio.options = options;
    return dio;
  }

  Future<FormData> uploadImage(File file, String name) async {
    FormData formData = new FormData();

    String fileName = file.path.split('/').last;
    formData = FormData.fromMap({
      "name": name,
      "species": 1,
      "pet_image": await MultipartFile.fromFile(file.path, filename: fileName),
    });
    return formData;
  }

  Future<FormData> uploadEvent(File file, String comment) async {
    FormData formData = new FormData();

    String fileName = file.path.split('/').last;
    formData = FormData.fromMap({
      "event_type": 2,
      "comment": comment,
      "pet": Injector.petData.id,
      "event_image":
          await MultipartFile.fromFile(file.path, filename: fileName),
    });
    return formData;
  }

  Future<dynamic> addPetData(String apiReq, File images, String name) async {
    initDioImg(apiReq);
    try {
      var response;

      await uploadImage(images, name).then((formData) async {
        response = await dio.post("", data: formData).catchError((e) {
          Utils.showToast(apiReq + "_" + e.toString());
          return null;
        });
      });

      print(apiReq + "_" + response?.data.toString());
      if (response.statusCode == HttpStatus.created) {
        return response.data;
      } else {
        Utils.showToast(response.message);
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> addEventData(String apiReq, File images, String name) async {
    initDioImg(apiReq);
    try {
      var response;

      await uploadEvent(images, name).then((formData) async {
        response = await dio.post("", data: formData).catchError((e) {
          Utils.showToast(apiReq + "_" + e.toString());
          return null;
        });
      });

      if (response != null) {
        print(apiReq + "_" + response?.data.toString());
        if (response.statusCode == HttpStatus.created) {
          return response.data;
        } else {
          Utils.showToast(response.message);
        }
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  getFiles(List<File> files) async {
    return files.forEach((file) async {
      String fileName = file.path.split('/').last;
      await MultipartFile.fromFile(file.path, filename: fileName);
    });
  }

  Future<BaseResponse> handleException(
      e, int requestMethod, String apiReq, Map<String, dynamic> jsonMap) async {
    BaseResponse baseResponse = BaseResponse.fromJson(e.response.data);

    if (e.response.statusCode == HttpStatus.unauthorized) {
      if (apiReq == WebApi.rqRegister || apiReq == WebApi.rqLogin)
        Utils.showToast(e.response.data['detail']);
      else {
        RefreshTokenRequest rq = RefreshTokenRequest();
        rq.refresh = Injector.signInResponse.refresh;
        var baseResponse =
            await refreshToken(Const.post, WebApi.rqRefreshToken, rq.toJson());
        if (baseResponse != null) {
          initDio(apiReq, requestMethod);
          callAPI(requestMethod, apiReq, jsonMap);
        } else {
          Utils.showToast("Something went wrong");
        }
      }
    } else if (e.response.statusCode == HttpStatus.badRequest) {
      print(e.response.data);

      if (apiReq == WebApi.rqRegister && e.response.data['username'] != null)
        Utils.showToast(e.response.data['username'][0]);
      else if (apiReq == WebApi.rqRegister && e.response.data['email'] != null)
        Utils.showToast(e.response.data['email']);
      else {
        Utils.showToast("Something went wrong");
      }
    } else if (e.response.statusCode == HttpStatus.unauthorized) {
      print(e.response.data);

      Utils.showToast(e.response.data['detail']);
    }

    return baseResponse;
  }
}
