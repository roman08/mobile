import 'dart:async';

import 'package:api_error_parser/api_error_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../app.dart';
import '../../common/models/file_info.dart';
import '../api_constants.dart';
import '../network_client.dart';

class FileProvider {
  final NetworkClient _networkClient;
  final ApiConstants apiConstants = ApiConstants();

  FileProvider(
    this._networkClient,
  );

  Future<ApiResponseEntity<FileInfo>> uploadFile({
    String path,
    String uid,
  }) async {
    print('****************** UID UID UID');
    print(path);
    print(uid);
    final result = await FlutterImageCompress.compressWithFile(
      path,
      quality: 100,
    );

    final FormData formData = FormData.fromMap({"file": MultipartFile.fromBytes(result, filename: "image.jpg")});
    print(formData.files);
    try {
      final Response response = await _networkClient.dio.post(
        apiConstants.file.privateFile(id: uid),
        data: formData,
      );
      return ApiResponseEntity<FileInfo>.fromJson(response.data as Map<String, dynamic>, FileInfo.fromJson);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<FileInfo>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponseEntity<FileInfo>> getFile({int id}) async {
    try {
      final Response response = await _networkClient.dio.get(
        apiConstants.file.file(id: id),
      );

      return ApiResponseEntity<FileInfo>.fromJson(response.data as Map<String, dynamic>, FileInfo.fromJson);
    } catch (error) {
      logger.e(error.toString());
      return Future.value(null);
    }
  }

  Future<List<int>> getBin({int id}) async {
    try {
      final Response response = await _networkClient.dio.get(
        apiConstants.file.bin(id: id),
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );

      return response.data;
    } catch (error) {
      logger.e(error.toString());
      return Future.value(null);
    }
  }

  Future<List<int>> getPublicBin({int id}) async {
    try {
      final Response response = await _networkClient.dio.get(
        apiConstants.file.publicBin(id: id),
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );

      return response.data;
    } catch (error) {
      logger.e(error.toString());
      return Future.value(null);
    }
  }

  Future<ApiResponseEntity<FileInfo>> uploadProfileImage({String path}) async { 
    final result = await FlutterImageCompress.compressWithFile(
      path,
      quality: 70,
      minWidth: 300,
      minHeight: 300,
    );

    final FormData formData = FormData.fromMap({"file": MultipartFile.fromBytes(result, filename: "image.jpg")});

    try {
      final Response response = await _networkClient.dio.post(
        apiConstants.file.profileImage,
        data: formData,
      );
      return ApiResponseEntity<FileInfo>.fromJson(response.data as Map<String, dynamic>, FileInfo.fromJson);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<FileInfo>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }

  Future<ApiResponseEntity<FileInfo>> uploadVoucher({
    String path,
    String uid,}) async { 
    final result = await FlutterImageCompress.compressWithFile(
      path,
      quality: 70,
      minWidth: 300,
      minHeight: 300,
    );

    final FormData formData = FormData.fromMap({"file": MultipartFile.fromBytes(result, filename: "image.jpg")});

    try {
      final Response response = await _networkClient.dio.post(
        apiConstants.file.voucherImage(id: uid),
        data: formData,
      );
      return ApiResponseEntity<FileInfo>.fromJson(response.data as Map<String, dynamic>, FileInfo.fromJson);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<FileInfo>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }

  // cash-out
  Future<ApiResponseEntity<FileInfo>> cashOutUpload({
    String bankName, String accountNumber, String type, String referencesAdditional, String uid, String numberRef}) async { 
    try {
      final Response response = await _networkClient.dio.post(
        apiConstants.kyc.cashOut,
        data: {
        'bankName': bankName,
        'accountNumber': accountNumber,
        'type': type,
        'referencesAdditional': referencesAdditional,
        'userUid':uid,
        'numberRef':numberRef
      }
      );
      return ApiResponseEntity<FileInfo>.fromJson(response.data as Map<String, dynamic>, FileInfo.fromJson);
    } on DioError catch (error) {
      logger.e(error.toString());
      return ApiResponseEntity<FileInfo>.fromJson(error.response.data as Map<String, dynamic>, null);
    }
  }
}
