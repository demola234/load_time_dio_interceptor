import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';

class LoadTimeDioInterceptor extends Interceptor {
  static const int kInitialTab = 1;
  static const bool compact = true;
  static const int maxWidth = 90;

  final StreamController<String> _loadTimeController =
      StreamController<String>.broadcast();

  Stream<String> get loadTimeStream => _loadTimeController.stream;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['startTime'] = DateTime.now();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['startTime'] as DateTime;
    final endTime = DateTime.now();
    final loadTime = endTime.difference(startTime);
    final formattedTime = _formatDuration(loadTime);
    logPrint('Request to ${response.requestOptions.uri} took $formattedTime');
    _loadTimeController.add(formattedTime);

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = err.requestOptions.extra['startTime'] as DateTime;
    final endTime = DateTime.now();
    final loadTime = endTime.difference(startTime);
    final formattedTime = _formatDuration(loadTime);
    logPrint(
        'Request to ${err.requestOptions.uri} failed after $formattedTime');
    _loadTimeController.add(formattedTime);
    if (err.response != null) {}
    super.onError(err, handler);
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    final milliseconds = duration.inMilliseconds.remainder(1000);
    return '$minutes:${seconds.toString().padLeft(2, '0')}:${milliseconds.toString().padLeft(3, '0')}';
  }

  void logPrint(String message) {
    log(message);
  }

  void dispose() {
    _loadTimeController.close();
  }
}
