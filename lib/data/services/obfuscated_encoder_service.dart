import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as enc;

/// Text transformation service with secure encoding
class ObfuscatedEncoderService {
  // Prepare transformation key material
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

  // Generate transformation vector
  static enc.IV _prepareVector(String input) {
    final inputBytes = utf8.encode(input);
    final result = Uint8List(16);
    for (int i = 0; i < 16; i++) {
      result[i] = (inputBytes[i % inputBytes.length] ^ (i * 11) + 42) & 0xFF;
    }
    return enc.IV(result);
  }

  // Transform text with key
  static String encode(String text, String key) {
    if (text.isEmpty) return '';
    if (key.isEmpty) key = 'default';

    try {
      final keyMaterial = _prepareKeyMaterial(key);
      final vector = _prepareVector(key);
      final transformer = enc.Encrypter(
        enc.AES(keyMaterial, mode: enc.AESMode.cbc),
      );
      final transformed = transformer.encrypt(text, iv: vector);
      return transformed.base64;
    } catch (e) {
      throw Exception('Transformation failed: $e');
    }
  }

  // Reverse transformation with key
  static String decode(String encodedText, String key) {
    if (encodedText.isEmpty) return '';
    if (key.isEmpty) key = 'default';

    // Clean the encoded text (remove whitespace)
    final cleanedText = encodedText.trim().replaceAll(RegExp(r'\s+'), '');
    
    // Validate Base64 format
    if (cleanedText.isEmpty) {
      throw Exception('متن رمزگذاری شده خالی است');
    }

    try {
      // Validate Base64 characters
      final base64Regex = RegExp(r'^[A-Za-z0-9+/=]+$');
      if (!base64Regex.hasMatch(cleanedText)) {
        throw Exception('فرمت متن رمزگذاری شده معتبر نیست. لطفاً متن رمزگذاری شده صحیح را وارد کنید.');
      }

      final encrypted = enc.Encrypted.fromBase64(cleanedText);
      final keyMaterial = _prepareKeyMaterial(key);
      final vector = _prepareVector(key);
      final transformer = enc.Encrypter(
        enc.AES(keyMaterial, mode: enc.AESMode.cbc),
      );
      final reversed = transformer.decrypt(encrypted, iv: vector);
      return reversed;
    } on FormatException {
      throw Exception('فرمت متن رمزگذاری شده معتبر نیست. لطفاً متن رمزگذاری شده صحیح را وارد کنید.');
    } on ArgumentError {
      throw Exception('کلید رمزگذاری اشتباه است یا متن رمزگذاری شده با این کلید رمزگذاری نشده است.');
    } catch (e) {
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('invalid') || errorMsg.contains('argument')) {
        throw Exception('کلید رمزگذاری اشتباه است یا متن رمزگذاری شده با این کلید رمزگذاری نشده است.');
      }
      throw Exception('خطا در رمزگشایی: ${e.toString()}');
    }
  }
}
