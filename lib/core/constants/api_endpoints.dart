// ignore_for_file: constant_identifier_names
//
class ApiEndpoints {
  // OpenAPI base
  static const String BASE_URL = 'https://fefca9c0f436.ngrok-free.app/api/v1';

  // Auth paths
  static const String REGISTER = '/auth/register';
  static const String LOGIN = '/auth/login';
  static const String LOGOUT = '/auth/logout';
  static const String REFRESH = '/auth/refresh';

  // OTP (for email verification & password reset)
  static const String REQUEST_OTP = '/auth/otp/request';
  static const String VERIFY_OTP = '/auth/otp/verify';

  // Password reset
  static const String PASSWORD_RESET_REQUEST = '/auth/password/reset-request';
  static const String PASSWORD_RESET_CONFIRM = '/auth/password/reset-confirm';

  // User profile (current user)
  static const String ME = '/users/me'; // used for both GET and PATCH

  // Filings & T1 forms
  static const String FILINGS = '/filings';
  static const String T1_FORMS = '/t1-forms';

  // Files paths
  static const String FILES_UPLOAD = '/documents/upload';
}
