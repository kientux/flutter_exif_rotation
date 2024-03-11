import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class FlutterExifRotation {
  static const MethodChannel _channel =
      const MethodChannel('flutter_exif_rotation');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Get the [path] of the image and fix the orientation.
  /// Return the [File] with the exif data fixed
  static Future<File> rotateImage({
    required String path,
  }) async =>
      await _rotateImageInternal(
        path: path,
        save: false,
      );

  /// Get the [path] of the image, fix the orientation and
  /// saves the file in the device.
  /// Return the [File] with the exif data fixed
  static Future<File> rotateAndSaveImage({
    required String path,
  }) async =>
      await _rotateImageInternal(
        path: path,
        save: true,
      );

  static Future<File> _rotateImageInternal({
    required String path,
    required bool save,
  }) async {
    String filePath = await (_channel.invokeMethod(
      'rotateImage',
      <String, dynamic>{
        'path': path,
        'save': false,
      },
    ));

    return new File(filePath);
  }

  static Future<Uint8List> rotateImageBytes({
    required Uint8List imageBytes,
  }) async {
    Uint8List bytes = await (_channel.invokeMethod(
      'rotateImageBytes',
      <String, dynamic>{
        'imageBytes': imageBytes,
        'save': false,
      },
    ));

    return bytes;
  }

  static Future<File> rotateImageBytesAndSave({
    required Uint8List imageBytes,
  }) async {
    String filePath = await (_channel.invokeMethod(
      'rotateImageBytes',
      <String, dynamic>{
        'imageBytes': imageBytes,
        'save': true,
      },
    ));

    return new File(filePath);
  }
}
