import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:path_provider/path_provider.dart';

/// File encryption service with AES-256-CBC encryption
class FileService {
  // Prepare encryption key material (same as text encryption)
  static enc.Key _prepareKeyMaterial(String input) {
    final inputBytes = utf8.encode(input);
    final hexString = inputBytes.map((b) => b.toRadixString(16)).join();
    final padded = hexString.padRight(32, '0').substring(0, 32);
    final keyBytes = utf8.encode(padded);
    final result = Uint8List(32);
    for (int i = 0; i < 32; i++) {
      result[i] = keyBytes[i % keyBytes.length] ^ (i * 7);
    }
    return enc.Key(result);
  }

  // Generate initialization vector (same as text encryption)
  static enc.IV _prepareVector(String input) {
    final inputBytes = utf8.encode(input);
    final result = Uint8List(16);
    for (int i = 0; i < 16; i++) {
      result[i] = (inputBytes[i % inputBytes.length] ^ (i * 11) + 42) & 0xFF;
    }
    return enc.IV(result);
  }

  // Validate key
  static void _validateKey(String key) {
    if (key.isEmpty) {
      throw Exception('کلید رمزگذاری نمی‌تواند خالی باشد');
    }
    if (key.length < 3) {
      throw Exception('کلید رمزگذاری باید حداقل ۳ کاراکتر باشد');
    }
  }

  // Validate file exists and is readable
  static Future<void> _validateFile(File file) async {
    if (!await file.exists()) {
      throw Exception('فایل وجود ندارد');
    }
    final length = await file.length();
    if (length == 0) {
      throw Exception('فایل خالی است');
    }
  }

  // Encrypt file using AES-256-CBC
  static Future<File> encodeFile(
    File inputFile,
    String key, {
    String? fileName,
  }) async {
    // Validate inputs
    _validateKey(key);
    await _validateFile(inputFile);

    try {
      // Read file bytes
      final fileBytes = await inputFile.readAsBytes();
      if (fileBytes.isEmpty) {
        throw Exception('فایل خالی است');
      }

      // Encrypt bytes using AES-256-CBC (same as text encryption)
      final keyMaterial = _prepareKeyMaterial(key);
      final vector = _prepareVector(key);
      final encrypter = enc.Encrypter(
        enc.AES(keyMaterial, mode: enc.AESMode.cbc),
      );
      final encrypted = encrypter.encryptBytes(fileBytes, iv: vector);

      // Convert encrypted bytes to base64 (same approach as text encryption)
      final base64Encoded = encrypted.base64;

      // Save base64 encoded string to file
      final dir = await getTemporaryDirectory();
      final random = Random();
      final originalName = fileName ?? inputFile.path.split('/').last;
      // Extract base name and extension
      final baseName = originalName.replaceAll(RegExp(r'\.[^.]*$'), '');
      final extension = originalName.contains('.')
          ? originalName.substring(originalName.lastIndexOf('.'))
          : '';
      String randomName = baseName;
      randomName += "_${DateTime.now().millisecondsSinceEpoch}";
      randomName += "_${random.nextInt(100000)}";
      randomName += "$extension.encrypted";

      final file = File('${dir.path}/$randomName');
      await file.writeAsString(base64Encoded, flush: true);

      return file;
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('خطا در رمزگذاری فایل: $e');
    }
  }

  // Decrypt file using AES-256-CBC
  static Future<File> decodeFile(
    File encodedFile,
    String key, {
    String? fileName,
  }) async {
    // Validate inputs
    _validateKey(key);
    await _validateFile(encodedFile);

    try {
      // Read bytes from file (FilePicker saves as binary)
      final fileBytes = await encodedFile.readAsBytes();
      if (fileBytes.isEmpty) {
        throw Exception('فایل رمزگذاری شده خالی است');
      }

      // Convert bytes to UTF-8 string (base64 encoded)
      final base64String = utf8.decode(fileBytes);
      if (base64String.trim().isEmpty) {
        throw Exception('فایل رمزگذاری شده خالی است');
      }

      // Clean the base64 string (remove whitespace)
      final cleanedBase64 = base64String.trim().replaceAll(RegExp(r'\s+'), '');

      // Validate Base64 format
      if (cleanedBase64.isEmpty) {
        throw Exception('فایل رمزگذاری شده خالی است');
      }

      // Convert base64 to Encrypted object (same approach as text decryption)
      final encrypted = enc.Encrypted.fromBase64(cleanedBase64);

      // Decrypt bytes using AES-256-CBC (same as text encryption)
      final keyMaterial = _prepareKeyMaterial(key);
      final vector = _prepareVector(key);
      final encrypter = enc.Encrypter(
        enc.AES(keyMaterial, mode: enc.AESMode.cbc),
      );

      final decryptedBytesList = encrypter.decryptBytes(encrypted, iv: vector);
      final decryptedBytes = Uint8List.fromList(decryptedBytesList);

      // Save decrypted file
      final dir = await getTemporaryDirectory();
      final random = Random();
      String originalName = fileName ?? encodedFile.path.split('/').last;
      String baseName = '';
      String extension = '';

      // Remove .encrypted extension
      if (originalName.endsWith('.encrypted')) {
        originalName = originalName.substring(
          0,
          originalName.length - 10,
        ); // Remove '.encrypted'
      }

      // Extract extension (before .encrypted we have the original extension)
      // Format can be: name_encrypted.ext or name_timestamp_random.ext
      final lastDot = originalName.lastIndexOf('.');
      if (lastDot > 0) {
        extension = originalName.substring(lastDot); // e.g., .jpeg
        baseName = originalName.substring(
          0,
          lastDot,
        ); // e.g., images_encrypted or images_1234567890_12345
      } else {
        baseName = originalName;
      }

      // Remove _encrypted suffix if present (from FilePicker saved files)
      if (baseName.endsWith('_encrypted')) {
        baseName = baseName.substring(0, baseName.length - 10);
      }
      // Remove timestamp pattern if present (from temp directory files)
      else {
        final timestampPattern = RegExp(r'_\d+_\d+$');
        if (timestampPattern.hasMatch(baseName)) {
          baseName = baseName.replaceFirst(timestampPattern, '');
        }
      }

      // Use original name with extension (add timestamp to avoid conflicts)
      String randomName = baseName;
      randomName += "_${DateTime.now().millisecondsSinceEpoch}";
      randomName += "_${random.nextInt(100000)}";
      randomName += extension; // Add extension at the end

      final file = File('${dir.path}/$randomName');
      await file.writeAsBytes(decryptedBytes, flush: true);

      return file;
    } on ArgumentError {
      throw Exception(
        'کلید رمزگذاری اشتباه است یا فایل رمزگذاری شده با این کلید رمزگذاری نشده است.',
      );
    } on Exception {
      rethrow;
    } catch (e) {
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('invalid') || errorMsg.contains('argument')) {
        throw Exception(
          'کلید رمزگذاری اشتباه است یا فایل رمزگذاری شده با این کلید رمزگذاری نشده است.',
        );
      }
      throw Exception('خطا در رمزگشایی فایل: $e');
    }
  }
}

// Export functions for backward compatibility
Future<File> encodeFile(File inputFile, String key, {String? fileName}) {
  return FileService.encodeFile(inputFile, key, fileName: fileName);
}

Future<File> decodeFile(File encodedFile, String key, {String? fileName}) {
  return FileService.decodeFile(encodedFile, key, fileName: fileName);
}
