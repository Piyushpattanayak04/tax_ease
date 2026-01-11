import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/network/ui_error.dart';

class FilesApi {
  FilesApi._();

  static Dio _dio() => Dio(
        BaseOptions(
          baseUrl: ApiEndpoints.BASE_URL,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            // Required for ngrok tunnels
            'ngrok-skip-browser-warning': 'true',
            if (ThemeController.authToken != null)
              'Authorization': 'Bearer ${ThemeController.authToken}',
          },
        ),
      );

  /// Upload a file using multipart/form-data to POST /documents/upload
  /// Returns the decoded response map on success (201)
  ///
  /// For mobile/desktop, pass a [filePath]. For web, pass [bytes] and an optional [fileName].
  ///
  /// [filingId] is required by the backend to associate the document with a filing.
  /// [category] is an optional string tag for the document type/section.
  static Future<Map<String, dynamic>> uploadFile({
    String? filePath,
    List<int>? bytes,
    String fieldName = 'file',
    String? fileName,
    String? filingId,
    String? category,
  }) async {
    if (filePath == null && bytes == null) {
      throw ArgumentError('Either filePath or bytes must be provided');
    }

    MultipartFile multipartFile;

    if (kIsWeb) {
      if (bytes == null) {
        throw ArgumentError('bytes must be provided when running on the web');
      }
      final resolvedName = fileName ?? (filePath ?? 'upload.bin');
      multipartFile = MultipartFile.fromBytes(
        bytes,
        filename: resolvedName,
      );
    } else {
      if (filePath == null) {
        throw ArgumentError('filePath must be provided on mobile/desktop');
      }
      // Derive a filename from the path if not explicitly provided.
      final resolvedName = fileName ?? filePath.split(RegExp(r'[\\/]')).last;
      multipartFile = await MultipartFile.fromFile(
        filePath,
        filename: resolvedName,
      );
    }

    final formData = FormData.fromMap({
      fieldName: multipartFile,
      if (filingId != null && filingId.isNotEmpty) 'filing_id': filingId,
      if (category != null && category.isNotEmpty) 'category': category,
    });

    try {
      final res = await _dio().post(
        ApiEndpoints.FILES_UPLOAD,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      final data = res.data;
      if (data is Map<String, dynamic>) return data;
      if (data is Map) return Map<String, dynamic>.from(data);
      return {'raw': data};
    } on DioException catch (e) {
      final msg = _extractErrorMessage(e);
      throw Exception(msg);
    }
  }

  /// Centralised mapping from DioException to a user-friendly upload error message.
  static String _extractErrorMessage(DioException e) {
    final uiError = mapDioErrorToUIError(e);
    // Customise the default message slightly for the upload context.
    if (uiError.type == UIErrorType.network || uiError.type == UIErrorType.timeout) {
      return 'Upload failed. ${uiError.message}';
    }
    return uiError.message.isNotEmpty ? uiError.message : 'Upload failed. Please try again.';
  }
}
