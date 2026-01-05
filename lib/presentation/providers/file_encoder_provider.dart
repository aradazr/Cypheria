import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/services/file_service.dart';

class FileEncoderProvider extends ChangeNotifier {
  bool _isEncoding = true;
  final TextEditingController keyController = TextEditingController();
  File? selectedFileToEncode;
  File? selectedFileToDecode;
  File? originalFileToEncode; // Keep original file for re-encoding
  File? originalFileToDecode; // Keep encrypted file for re-decoding
  bool isEncoded = false;
  bool isDecoded = false;
  bool isLoadingEncode = false;
  bool isLoadingDecode = false;
  String? _errorMessage;
  Locale _locale = const Locale('fa', 'IR');

  void setLocale(Locale locale) {
    _locale = locale;
  }

  String _getLocalizedString(String key) {
    return AppLocalizations.getString(_locale, key);
  }
  String? selectedFileName;
  String? originalFileName; // Keep original file name for display

  bool get isEncoding => _isEncoding;
  String? get errorMessage => _errorMessage;

  void toggleMode() {
    _isEncoding = !_isEncoding;
    _errorMessage = null;
    // Clear files when switching modes to prevent confusion
    if (_isEncoding) {
      // Switching to encoding mode - clear decode files
      selectedFileToDecode = null;
      originalFileToDecode = null;
      isDecoded = false;
      selectedFileName = null;
      originalFileName = null;
    } else {
      // Switching to decoding mode - clear encode files
      selectedFileToEncode = null;
      originalFileToEncode = null;
      isEncoded = false;
      selectedFileName = null;
      originalFileName = null;
    }
    notifyListeners();
  }

  Future<void> pickFileToEncode() async {
    try {
      _errorMessage = null;
      final result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final file = File(filePath);
        selectedFileToEncode = file;
        originalFileToEncode = file; // Keep original for re-encoding
        selectedFileName = result.files.single.name;
        originalFileName = result.files.single.name; // Keep original file name
        isEncoded = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'خطا در انتخاب فایل: $e';
      debugPrint('ERROR [FileEncoderProvider.pickFileToEncode]: $_errorMessage');
      debugPrint('ERROR StackTrace: ${StackTrace.current}');
      notifyListeners();
    }
  }

  Future<void> pickFileToDecode() async {
    try {
      _errorMessage = null;
      final result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final file = File(filePath);
        selectedFileToDecode = file;
        originalFileToDecode = file; // Keep encrypted file for re-decoding
        selectedFileName = result.files.single.name;
        originalFileName = result.files.single.name.replaceAll(
          '.encrypted',
          '',
        ); // Keep original file name without .encrypted
        isDecoded = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = '${_getLocalizedString('errorSelectingFile')}: $e';
      debugPrint('ERROR [FileEncoderProvider.pickFileToDecode]: $_errorMessage');
      debugPrint('ERROR StackTrace: ${StackTrace.current}');
      notifyListeners();
    }
  }

  void clearFileToEncode() {
    selectedFileToEncode = null;
    originalFileToEncode = null;
    selectedFileName = null;
    originalFileName = null;
    isEncoded = false;
    _errorMessage = null;
    keyController.clear();
    notifyListeners();
  }

  void clearFileToDecode() {
    selectedFileToDecode = null;
    originalFileToDecode = null;
    selectedFileName = null;
    originalFileName = null;
    isDecoded = false;
    _errorMessage = null;
    keyController.clear();
    notifyListeners();
  }

  Future<void> encodeFile(File file, String key) async {
    // Prevent multiple simultaneous encoding
    if (isLoadingEncode) return;

    _errorMessage = null;
    isLoadingEncode = true;
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

      // Store original file before encoding (if not already stored)
      if (originalFileToEncode == null ||
          originalFileToEncode!.path != file.path) {
        originalFileToEncode = file;
      }

      final encoded = await FileService.encodeFile(
        file,
        key,
        fileName: selectedFileName,
      );
      selectedFileToEncode = encoded; // This is the encrypted file
      // originalFileToEncode stays the same (original file for re-encoding)
      isEncoded = true;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint('ERROR [FileEncoderProvider.encodeFile]: $_errorMessage');
      debugPrint('ERROR StackTrace: ${StackTrace.current}');
      isEncoded = false; // Only reset on error
    } finally {
      isLoadingEncode = false;
      notifyListeners();
    }
  }

  Future<void> decodeFile(File file, String key) async {
    // Prevent multiple simultaneous decoding
    if (isLoadingDecode) return;

    _errorMessage = null;
    isLoadingDecode = true;
    notifyListeners();

    try {
      if (key.isEmpty) {
        throw Exception(_getLocalizedString('pleaseEnterEncryptionKey'));
      }

      if (key.length < 3) {
        throw Exception(_getLocalizedString('encryptionKeyMinLength'));
      }

      if (!await file.exists()) {
        throw Exception(_getLocalizedString('fileNotFound'));
      }

      // Store encrypted file before decoding (if not already stored)
      if (originalFileToDecode == null ||
          originalFileToDecode!.path != file.path) {
        originalFileToDecode = file;
      }

      final decoded = await FileService.decodeFile(
        file,
        key,
        fileName: selectedFileName,
      );
      selectedFileToDecode = decoded; // This is the decrypted file
      // originalFileToDecode stays the same (encrypted file for re-decoding)
      isDecoded = true;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint('ERROR [FileEncoderProvider.decodeFile]: $_errorMessage');
      debugPrint('ERROR StackTrace: ${StackTrace.current}');
      isDecoded = false; // Only reset on error
    } finally {
      isLoadingDecode = false;
      notifyListeners();
    }
  }

  Future<void> saveEncodedFile(String dialogTitle) async {
    if (selectedFileToEncode == null) {
      _errorMessage = _getLocalizedString('noEncryptedFileToSave');
      notifyListeners();
      return;
    }

    try {
      // Read base64 string from file and convert to UTF-8 bytes
      final base64String = await selectedFileToEncode!.readAsString();
      final bytes = utf8.encode(base64String);

      // Use file_picker to save the file
      // Preserve original extension and add .encrypted
      String fileNameToSave = 'encrypted_file.encrypted';
      if (selectedFileName != null) {
        final originalName = selectedFileName!;
        final baseName = originalName.replaceAll(RegExp(r'\.[^.]*$'), '');
        final extension = originalName.contains('.')
            ? originalName.substring(originalName.lastIndexOf('.'))
            : '';
        fileNameToSave = '${baseName}_encrypted$extension.encrypted';
      }

      final result = await FilePicker.platform.saveFile(
        dialogTitle: dialogTitle,
        fileName: fileNameToSave,
        bytes: bytes,
      );

      if (result != null) {
        _errorMessage = null;
      }
    } catch (e) {
      _errorMessage =
          '${_getLocalizedString('errorSavingFile')}: ${e.toString().replaceAll('Exception: ', '')}';
      debugPrint('ERROR [FileEncoderProvider.saveEncodedFile]: $_errorMessage');
      debugPrint('ERROR StackTrace: ${StackTrace.current}');
      notifyListeners();
    }
  }

  Future<void> saveDecodedFile(String dialogTitle) async {
    if (selectedFileToDecode == null || !isDecoded) {
      _errorMessage = _getLocalizedString('noDecryptedFileToSave');
      notifyListeners();
      return;
    }

    // Ensure we're using the decoded file, not the encrypted one
    if (selectedFileToDecode!.path == originalFileToDecode?.path) {
      _errorMessage = _getLocalizedString('fileNotDecrypted');
      notifyListeners();
      return;
    }

    try {
      // Use file_picker to save the file
      // Get the decoded file name (which has the correct extension)
      String decodedFileName = selectedFileToDecode!.path.split('/').last;

      // Remove timestamp pattern if exists: _timestamp_randomnumber
      // Keep the extension (e.g., S_1234567890_12345.rar -> S.rar)
      String fileNameToSave = decodedFileName;
      final pattern = RegExp(r'_\d+_\d+(\.\w+)$');
      if (pattern.hasMatch(decodedFileName)) {
        final match = pattern.firstMatch(decodedFileName);
        final extension = match?.group(1) ?? '';
        fileNameToSave = decodedFileName.replaceFirst(pattern, extension);
      }

      final result = await FilePicker.platform.saveFile(
        dialogTitle: dialogTitle,
        fileName: fileNameToSave,
        bytes: await selectedFileToDecode!.readAsBytes(),
      );

      if (result != null) {
        _errorMessage = null;
      }
    } catch (e) {
      _errorMessage =
          '${_getLocalizedString('errorSavingFile')}: ${e.toString().replaceAll('Exception: ', '')}';
      debugPrint('ERROR [FileEncoderProvider.saveDecodedFile]: $_errorMessage');
      debugPrint('ERROR StackTrace: ${StackTrace.current}');
      notifyListeners();
    }
  }

  Future<void> shareEncodedFile() async {
    if (selectedFileToEncode == null) {
      _errorMessage = _getLocalizedString('noEncryptedFileToShare');
      notifyListeners();
      return;
    }

    try {
      // Determine mimeType based on file extension
      String mimeType = 'application/octet-stream';
      final extension = selectedFileToEncode!.path.split('.').last.toLowerCase();
      if (extension == 'txt' || extension == 'text') {
        mimeType = 'text/plain';
      } else if (extension == 'pdf') {
        mimeType = 'application/pdf';
      } else if (extension == 'zip' || extension == 'rar') {
        mimeType = 'application/zip';
      }
      
      final xFile = XFile(
        selectedFileToEncode!.path,
        mimeType: mimeType,
      );
      
      if (Platform.isIOS) {
        // iOS requires sharePositionOrigin for iPad
        await Share.shareXFiles(
          [xFile],
          text: _getLocalizedString('encryptedFile'),
          sharePositionOrigin: const Rect.fromLTWH(0, 0, 100, 100),
        );
      } else {
        await Share.shareXFiles(
          [xFile],
          text: _getLocalizedString('encryptedFile'),
        );
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint('ERROR [FileEncoderProvider.shareEncodedFile]: $_errorMessage');
      debugPrint('ERROR StackTrace: ${StackTrace.current}');
      debugPrint('ERROR File path: ${selectedFileToEncode?.path}');
      notifyListeners();
    }
  }

  Future<void> shareDecodedFile() async {
    if (selectedFileToDecode == null || !isDecoded) {
      _errorMessage = _getLocalizedString('noDecryptedFileToShare');
      notifyListeners();
      return;
    }

    // Ensure we're using the decoded file, not the encrypted one
    if (selectedFileToDecode!.path == originalFileToDecode?.path) {
      _errorMessage = _getLocalizedString('fileNotDecrypted');
      notifyListeners();
      return;
    }

    try {
      // Determine mimeType based on file extension
      String mimeType = 'application/octet-stream';
      final extension = selectedFileToDecode!.path.split('.').last.toLowerCase();
      if (extension == 'txt' || extension == 'text') {
        mimeType = 'text/plain';
      } else if (extension == 'pdf') {
        mimeType = 'application/pdf';
      } else if (extension == 'zip' || extension == 'rar') {
        mimeType = 'application/zip';
      } else if (extension == 'jpg' || extension == 'jpeg') {
        mimeType = 'image/jpeg';
      } else if (extension == 'png') {
        mimeType = 'image/png';
      }
      
      final xFile = XFile(
        selectedFileToDecode!.path,
        mimeType: mimeType,
      );
      
      if (Platform.isIOS) {
        // iOS requires sharePositionOrigin for iPad
        await Share.shareXFiles(
          [xFile],
          text: _getLocalizedString('decryptedFile'),
          sharePositionOrigin: const Rect.fromLTWH(0, 0, 100, 100),
        );
      } else {
        await Share.shareXFiles(
          [xFile],
          text: _getLocalizedString('decryptedFile'),
        );
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint('ERROR [FileEncoderProvider.shareDecodedFile]: $_errorMessage');
      debugPrint('ERROR StackTrace: ${StackTrace.current}');
      debugPrint('ERROR File path: ${selectedFileToDecode?.path}');
      notifyListeners();
    }
  }
}
