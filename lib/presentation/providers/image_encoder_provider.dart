import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/services/image_service.dart';

class ImageEncoderProvider extends ChangeNotifier {
  bool _isEncoding = true;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController keyController = TextEditingController();
  File? selectedImageToEncode;
  File? selectedImageToDecode;
  File? originalImageToEncode; // Keep original image for display
  File? originalImageToDecode; // Keep encrypted file for re-decoding
  bool isEncoded = false;
  bool isDecoded = false;
  bool isLoadingEncode = false;
  bool isLoadingDecode = false;
  String? _errorMessage;

  bool get isEncoding => _isEncoding;
  ImagePicker get picker => _picker;
  String? get errorMessage => _errorMessage;

  void toggleMode() {
    _isEncoding = !_isEncoding;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> pickImageToEncode() async {
    try {
      _errorMessage = null;
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final imageFile = File(image.path);
        selectedImageToEncode = imageFile;
        originalImageToEncode = imageFile; // Keep original for display
        isEncoded = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'خطا در انتخاب تصویر: $e';
      notifyListeners();
    }
  }

  Future<void> pickImageToDecode() async {
    try {
      _errorMessage = null;
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final imageFile = File(image.path);
        selectedImageToDecode = imageFile;
        originalImageToDecode = imageFile; // Keep encrypted file for re-decoding
        isDecoded = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'خطا در انتخاب تصویر: $e';
      notifyListeners();
    }
  }

  void clearImageToEncode() {
    selectedImageToEncode = null;
    originalImageToEncode = null;
    isEncoded = false;
    _errorMessage = null;
    keyController.clear();
    notifyListeners();
  }

  void clearImageToDecode() {
    selectedImageToDecode = null;
    originalImageToDecode = null;
    isDecoded = false;
    _errorMessage = null;
    keyController.clear();
    notifyListeners();
  }

  Future<void> encodeImage(File file, String key) async {
    // Prevent multiple simultaneous encoding
    if (isLoadingEncode) return;

    _errorMessage = null;
    isLoadingEncode = true;
    // Don't reset isEncoded here - keep it true if already encoded
    notifyListeners();

    try {
      if (key.isEmpty) {
        throw Exception('لطفاً کلید رمزگذاری را وارد کنید');
      }

      if (key.length < 3) {
        throw Exception('کلید رمزگذاری باید حداقل ۳ کاراکتر باشد');
      }

      if (!await file.exists()) {
        throw Exception('فایل وجود ندارد');
      }

      // Store original image before encoding (if not already stored)
      if (originalImageToEncode == null || originalImageToEncode!.path != file.path) {
        originalImageToEncode = file;
      }

      final encoded = await encodeFile(file, key);
      selectedImageToEncode = encoded; // This is the encrypted file
      // originalImageToEncode stays the same (original image for display)
      isEncoded = true;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      isEncoded = false; // Only reset on error
    } finally {
      isLoadingEncode = false;
      notifyListeners();
    }
  }

  Future<void> decodeImage(File file, String key) async {
    // Prevent multiple simultaneous decoding
    if (isLoadingDecode) return;

    _errorMessage = null;
    isLoadingDecode = true;
    // Don't reset isDecoded here - keep it true if already decoded
    notifyListeners();

    try {
      if (key.isEmpty) {
        throw Exception('لطفاً کلید رمزگذاری را وارد کنید');
      }

      if (key.length < 3) {
        throw Exception('کلید رمزگذاری باید حداقل ۳ کاراکتر باشد');
      }

      if (!await file.exists()) {
        throw Exception('فایل وجود ندارد');
      }

      // Store encrypted file before decoding (if not already stored)
      if (originalImageToDecode == null || originalImageToDecode!.path != file.path) {
        originalImageToDecode = file;
      }

      final decoded = await decodeFile(file, key);
      selectedImageToDecode = decoded; // This is a valid PNG image
      // originalImageToDecode stays the same (encrypted file for re-decoding)
      isDecoded = true;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      isDecoded = false; // Only reset on error
    } finally {
      isLoadingDecode = false;
      notifyListeners();
    }
  }

  Future<void> saveEncodedImage() async {
    if (selectedImageToEncode == null) {
      _errorMessage = 'هیچ تصویر رمزگذاری شده‌ای برای ذخیره وجود ندارد';
      notifyListeners();
      return;
    }

    try {
      await saveToGallery(selectedImageToEncode!);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> saveDecodedImage() async {
    if (selectedImageToDecode == null) {
      _errorMessage = 'هیچ تصویر رمزگشایی شده‌ای برای ذخیره وجود ندارد';
      notifyListeners();
      return;
    }

    try {
      await saveToGallery(selectedImageToDecode!);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }
}
