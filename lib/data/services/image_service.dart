import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

/// Image encryption service with AES-256-CBC encryption
class ImageService {
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
    if (!await file.readAsBytes().then((_) => true).catchError((_) => false)) {
      throw Exception('فایل قابل خواندن نیست');
    }
  }

  // Decode image from file with proper error handling
  static Future<img.Image?> _decodeFlutterImage(File file) async {
    try {
      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) {
        throw Exception('فایل خالی است');
      }
      final image = img.decodeImage(bytes);
      if (image == null) {
        throw Exception(
          'فرمت تصویر معتبر نیست. لطفاً یک تصویر معتبر انتخاب کنید.',
        );
      }
      return image;
    } catch (e) {
      if (e.toString().contains('فایل') || e.toString().contains('فرمت')) {
        rethrow;
      }
      throw Exception('خطا در خواندن تصویر: $e');
    }
  }

  // Save image to file
  static Future<File> _saveImage(img.Image image, [String? fileName]) async {
    try {
      final bytes = img.encodePng(image);
      if (bytes.isEmpty) {
        throw Exception('خطا در ذخیره تصویر');
      }

      final dir = await getTemporaryDirectory();
      final random = Random();

      String randomName = fileName ?? "image";
      randomName += "_${DateTime.now().millisecondsSinceEpoch}";
      randomName += "_${random.nextInt(100000)}";

      final file = File('${dir.path}/$randomName.png');
      await file.writeAsBytes(bytes, flush: true);

      return file;
    } catch (e) {
      throw Exception('خطا در ذخیره تصویر: $e');
    }
  }

  // Encrypt image file using AES-256-CBC
  static Future<File> encodeFile(
    File inputFile,
    String key, {
    String fileName = "encoded_image",
  }) async {
    // Validate inputs
    _validateKey(key);
    await _validateFile(inputFile);

    try {
      // Read image
      final image = await _decodeFlutterImage(inputFile);
      if (image == null) {
        throw Exception('فرمت تصویر معتبر نیست');
      }

      // Convert image to PNG bytes
      final imageBytes = img.encodePng(image);

      // Encrypt bytes using AES-256-CBC (same as text encryption)
      final keyMaterial = _prepareKeyMaterial(key);
      final vector = _prepareVector(key);
      final encrypter = enc.Encrypter(
        enc.AES(keyMaterial, mode: enc.AESMode.cbc),
      );
      final encrypted = encrypter.encryptBytes(imageBytes, iv: vector);

      // Save encrypted bytes to file (as PNG for compatibility with image_picker)
      // Note: The file contains encrypted data, not a valid image
      final dir = await getTemporaryDirectory();
      final random = Random();
      String randomName = fileName;
      randomName += "_${DateTime.now().millisecondsSinceEpoch}";
      randomName += "_${random.nextInt(100000)}";

      final file = File('${dir.path}/$randomName.png');
      await file.writeAsBytes(Uint8List.fromList(encrypted.bytes), flush: true);

      return file;
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('خطا در رمزگذاری تصویر: $e');
    }
  }

  // Decrypt image file using AES-256-CBC
  static Future<File> decodeFile(
    File encodedFile,
    String key, {
    String fileName = "decoded_image",
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

      // Decode image from decrypted bytes
      final image = img.decodeImage(decryptedBytes);
      if (image == null) {
        throw Exception(
          'کلید رمزگذاری اشتباه است یا فایل رمزگذاری شده با این کلید رمزگذاری نشده است.',
        );
      }

      // Save decoded image
      return await _saveImage(image, fileName);
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
      throw Exception('خطا در رمزگشایی تصویر: $e');
    }
  }

  // Save image to gallery with proper error handling
  static Future<void> saveToGallery(File imageFile) async {
    try {
      if (!await imageFile.exists()) {
        throw Exception('فایل وجود ندارد');
      }
      await GallerySaver.saveImage(imageFile.path, albumName: "Cypheria");
    } catch (e) {
      throw Exception('خطا در ذخیره تصویر در گالری: $e');
    }
  }
}

// Export functions for backward compatibility
Future<File> encodeFile(
  File inputFile,
  String key, {
  String fileName = "encoded_image",
}) {
  return ImageService.encodeFile(inputFile, key, fileName: fileName);
}

Future<File> decodeFile(
  File encodedFile,
  String key, {
  String fileName = "decoded_image",
}) {
  return ImageService.decodeFile(encodedFile, key, fileName: fileName);
}

Future<void> saveToGallery(File imageFile) {
  return ImageService.saveToGallery(imageFile);
}
