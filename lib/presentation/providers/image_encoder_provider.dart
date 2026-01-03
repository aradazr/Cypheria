import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/services/image_service.dart';
import '../../core/localization/app_localizations.dart';

class ImageEncoderProvider extends ChangeNotifier {
  bool _isEncoding = true;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController keyController = TextEditingController();
  File? selectedImageToEncode;
  File? selectedImageToDecode;
  bool isEncoded = false;
  bool isDecoded = false;
  bool isLoadingEncode = false;
  bool isLoadingDecode = false;

  bool get isEncoding => _isEncoding;
  ImagePicker get picker => _picker;

  void toggleMode() {
    _isEncoding = !_isEncoding;
    // Swap input and output when toggling

    notifyListeners();
  }

  String _getLocalizedError(BuildContext context, String key) {
    try {
      final localizations = AppLocalizations.of(context);
      if (localizations != null) {
        return key == 'pleaseEnterText'
            ? localizations.pleaseEnterText
            : localizations.pleaseEnterKey;
      }
      return 'Error';
    } catch (e) {
      return 'Error';
    }
  }

  Future<void> pickImageToEncode() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImageToEncode = File(image.path);
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> pickImageToDecode() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImageToDecode = File(image.path);
      notifyListeners();
    }
    notifyListeners();
  }

  void clearImageToEncode() {
    selectedImageToEncode = null;
    isEncoded = false;
    keyController.clear();

    notifyListeners();
  }

  void clearImageToDecode() {
    selectedImageToDecode = null;
    isDecoded = false;
    keyController.clear();
    notifyListeners();
  }

  void encodeImage(File file, String key) async {
    notifyListeners();

    File encoded = await encodeFile(file, key);

    selectedImageToEncode = encoded;
    isEncoded = true;
    notifyListeners();

    isLoadingEncode = false;
    notifyListeners();
  }

  Future<void> decodeImage(File file, String key) async {
    notifyListeners();

    File decoded = await decodeFile(file, key);
    selectedImageToDecode = decoded;
    isDecoded = true;
    notifyListeners();

    isLoadingDecode = false;
    notifyListeners();
  }

  void saveEncodedImage() {
    saveToGallery(selectedImageToEncode!);
    notifyListeners();
  }

  void saveDecodedImage() {
    saveToGallery(selectedImageToDecode!);
    notifyListeners();
  }
}
