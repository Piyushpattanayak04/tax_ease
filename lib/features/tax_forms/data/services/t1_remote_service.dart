import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/ui_error.dart';
import '../../../../core/theme/theme_controller.dart';
import '../models/t1_form_models_simple.dart';

class T1RemoteService {
  T1RemoteService._();

  static T1RemoteService? _instance;
  static T1RemoteService get instance => _instance ??= T1RemoteService._();

  Dio _dio() => Dio(
        BaseOptions(
          baseUrl: ApiEndpoints.BASE_URL,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 20),
          headers: {
            'Content-Type': 'application/json',
            'ngrok-skip-browser-warning': 'true',
            if (ThemeController.authToken != null)
              'Authorization': 'Bearer ${ThemeController.authToken}',
          },
        ),
      );

  /// Create a new filing and return its ID.
  /// POST /filings { "filing_year": <year> }
  Future<String> createFiling({required int filingYear}) async {
    try {
      final res = await _dio().post(
        ApiEndpoints.FILINGS,
        data: {
          'filing_year': filingYear,
        },
      );
      final data = res.data;
      if (data is Map) {
        final map = Map<String, dynamic>.from(data as Map);
        // Try common id keys
        final id = (map['id'] ?? map['filing_id'] ?? map['filingId'])?.toString();
        if (id != null && id.isNotEmpty) return id;
      }
      throw Exception('Unexpected response when creating filing');
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  /// Save answers for a T1 form.
  /// POST /t1-forms/{filing_id}/answers { "answers": { ... } }
  Future<void> saveAnswers({required String filingId, required T1FormData form}) async {
    try {
      final answers = _flattenToAnswers(form.toJson());
      await _dio().post(
        '${ApiEndpoints.T1_FORMS}/$filingId/answers',
        data: {
          'answers': answers,
        },
      );
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  /// Load a T1 form from backend by filing id.
  /// GET /t1-forms/{filing_id}
  Future<T1FormData> fetchForm({required String filingId}) async {
    try {
      final res = await _dio().get('${ApiEndpoints.T1_FORMS}/$filingId');
      final data = res.data;

      // If backend returns { "answers": { ... } }, unflatten first.
      if (data is Map && data['answers'] is Map) {
        final answers = Map<String, dynamic>.from(data['answers'] as Map);
        final nested = _unflattenAnswers(answers);
        // Ensure id is set from filingId
        nested['id'] = filingId;
        return T1FormData.fromJson(nested);
      }

      // Otherwise, if directly compatible with T1FormData.fromJson
      if (data is Map<String, dynamic>) {
        final map = Map<String, dynamic>.from(data);
        map['id'] ??= filingId;
        return T1FormData.fromJson(map);
      }
      if (data is Map) {
        final map = Map<String, dynamic>.from(data as Map);
        map['id'] ??= filingId;
        return T1FormData.fromJson(map);
      }

      if (data is String) {
        try {
          final decoded = json.decode(data) as Map<String, dynamic>;
          decoded['id'] ??= filingId;
          return T1FormData.fromJson(decoded);
        } catch (_) {}
      }

      throw Exception('Unexpected response when loading T1 form');
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  /// Submit a T1 form.
  /// POST /t1-forms/{filing_id}/submit
  Future<void> submit({required String filingId}) async {
    try {
      await _dio().post('${ApiEndpoints.T1_FORMS}/$filingId/submit');
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  // --- Helpers: flatten/unflatten ---

  /// Flatten a nested JSON-compatible map to the "answers" key-path format
  /// expected by the backend.
  ///
  /// NOTE: All DateTimes (or ISO-8601 date strings) are normalised to
  /// `yyyy-MM-dd` as required by `/t1-forms/{filing_id}/answers`.
  Map<String, dynamic> _flattenToAnswers(Map<String, dynamic> root) {
    final result = <String, dynamic>{};

    void walk(dynamic value, String path) {
      if (value == null) return;
      if (value is Map) {
        value.forEach((key, v) {
          final nextPath = path.isEmpty ? key.toString() : '$path.$key';
          walk(v, nextPath);
        });
      } else if (value is List) {
        for (var i = 0; i < value.length; i++) {
          final v = value[i];
          final nextPath = '$path[$i]';
          walk(v, nextPath);
        }
      } else {
        // Primitive / leaf
        if (value is DateTime) {
          result[path] = _formatDateOnly(value);
        } else if (value is String) {
          // If it looks like an ISO8601 date/time, normalise to date-only.
          final parsed = DateTime.tryParse(value);
          if (parsed != null) {
            result[path] = _formatDateOnly(parsed);
          } else {
            result[path] = value;
          }
        } else {
          result[path] = value;
        }
      }
    }

    walk(root, '');
    return result;
  }

  /// Format a DateTime as yyyy-MM-dd (no time component).
  String _formatDateOnly(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Turn a flat answers map like { 'personalInfo.firstName': 'John', ... }
  /// back into a nested JSON map that matches T1FormData.fromJson.
  Map<String, dynamic> _unflattenAnswers(Map<String, dynamic> answers) {
    final Map<String, dynamic> root = {};

    for (final entry in answers.entries) {
      final keyPath = entry.key;
      final value = entry.value;

      // Split on dots but keep [index] parts attached to the previous segment
      final segments = <String>[];
      final rawParts = keyPath.split('.');
      for (final part in rawParts) {
        segments.add(part);
      }

      Map<String, dynamic> current = root;
      for (var i = 0; i < segments.length; i++) {
        final seg = segments[i];
        final listMatch = RegExp(r'^(\\w+)\\[(\\d+)\\]').firstMatch(seg);

        final bool isLast = i == segments.length - 1;

        if (listMatch != null) {
          final field = listMatch.group(1)!;
          final index = int.parse(listMatch.group(2)!);

          current[field] ??= <dynamic>[];
          final list = current[field] as List;
          while (list.length <= index) {
            list.add(<String, dynamic>{});
          }

          if (isLast) {
            list[index] = value;
          } else {
            if (list[index] is! Map<String, dynamic>) {
              list[index] = <String, dynamic>{};
            }
            current = list[index] as Map<String, dynamic>;
          }
        } else {
          if (isLast) {
            current[seg] = value;
          } else {
            current[seg] ??= <String, dynamic>{};
            current = current[seg] as Map<String, dynamic>;
          }
        }
      }
    }

    return root;
  }

  String _extractErrorMessage(DioException e) {
    final uiError = mapDioErrorToUIError(e);
    return uiError.message;
  }
}
