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

      // Save encrypted bytes to file
      final dir = await getTemporaryDirectory();
      final random = Random();
      final originalName = fileName ?? inputFile.path.split('/').last;
      String randomName = originalName;
      randomName += "_${DateTime.now().millisecondsSinceEpoch}";
      randomName += "_${random.nextInt(100000)}";
      randomName += ".encrypted";

      final file = File('${dir.path}/$randomName');
      await file.writeAsBytes(Uint8List.fromList(encrypted.bytes), flush: true);

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
      // Read encrypted bytes
      final encryptedBytes = await encodedFile.readAsBytes();
      if (encryptedBytes.isEmpty) {
        throw Exception('فایل رمزگذاری شده خالی است');
      }

      // Decrypt bytes using AES-256-CBC (same as text encryption)
      final keyMaterial = _prepareKeyMaterial(key);
      final vector = _prepareVector(key);
      final encrypter = enc.Encrypter(
        enc.AES(keyMaterial, mode: enc.AESMode.cbc),
      );

      final encrypted = enc.Encrypted(encryptedBytes);
      final decryptedBytesList = encrypter.decryptBytes(encrypted, iv: vector);
      final decryptedBytes = Uint8List.fromList(decryptedBytesList);

      // Save decrypted file
      final dir = await getTemporaryDirectory();
      final random = Random();
      final originalName = fileName ?? encodedFile.path.split('/').last.replaceAll('.encrypted', '');
      String randomName = originalName;
      randomName += "_${DateTime.now().millisecondsSinceEpoch}";
      randomName += "_${random.nextInt(100000)}";

      final file = File('${dir.path}/$randomName');
      await file.writeAsBytes(decryptedBytes, flush: true);

      return file;
    } on ArgumentError {
      throw Exception('کلید رمزگذاری اشتباه است یا فایل رمزگذاری شده با این کلید رمزگذاری نشده است.');
    } on Exception {
      rethrow;
    } catch (e) {
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('invalid') || errorMsg.contains('argument')) {
        throw Exception('کلید رمزگذاری اشتباه است یا فایل رمزگذاری شده با این کلید رمزگذاری نشده است.');
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

