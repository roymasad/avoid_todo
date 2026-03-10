import 'package:flutter/services.dart';

class ICloudKvStore {
  ICloudKvStore._();

  static const MethodChannel _channel =
      MethodChannel('avoid_todo/icloud_kv_store');

  static Future<bool> isAvailable() async {
    final result = await _channel.invokeMethod<bool>('isAvailable');
    return result ?? false;
  }

  static Future<String?> getString(String key) {
    return _channel.invokeMethod<String>('getString', {'key': key});
  }

  static Future<bool> setString(String key, String value) async {
    final result = await _channel.invokeMethod<bool>('setString', {
      'key': key,
      'value': value,
    });
    return result ?? false;
  }

  static Future<bool> remove(String key) async {
    final result = await _channel.invokeMethod<bool>('remove', {'key': key});
    return result ?? false;
  }
}
