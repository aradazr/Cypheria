import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/services/audio_service.dart';

class AudioEncoderProvider extends ChangeNotifier {
  bool _isEncoding = true;
  final TextEditingController keyController = TextEditingController();
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  
  File? recordedAudioFile;
  File? selectedAudioToEncode;
  File? selectedAudioToDecode;
  File? originalAudioToEncode; // Keep original audio for re-encoding
  File? originalAudioToDecode; // Keep encrypted file for re-decoding
  
  bool isEncoded = false;
  bool isDecoded = false;
  bool isLoadingEncode = false;
  bool isLoadingDecode = false;
  bool isRecording = false;
  bool isPlaying = false;
  String? _errorMessage;
  Locale _locale = const Locale('fa', 'IR');
  
  Duration? _recordingDuration;
  Duration? _playbackPosition;
  Duration? _playbackDuration;

  bool get isEncoding => _isEncoding;
  String? get errorMessage => _errorMessage;
  Duration? get recordingDuration => _recordingDuration;
  Duration? get playbackPosition => _playbackPosition;
  Duration? get playbackDuration => _playbackDuration;

  void setLocale(Locale locale) {
    _locale = locale;
  }

  String _getLocalizedString(String key) {
    return AppLocalizations.getString(_locale, key);
  }

  AudioEncoderProvider() {
    _player.onPositionChanged.listen((position) {
      _playbackPosition = position;
      notifyListeners();
    });
    
    _player.onDurationChanged.listen((duration) {
      _playbackDuration = duration;
      notifyListeners();
    });
    
    _player.onPlayerComplete.listen((_) {
      isPlaying = false;
      _playbackPosition = Duration.zero;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _recorder.dispose();
    _player.dispose();
    keyController.dispose();
    super.dispose();
  }

  void toggleMode() {
    _isEncoding = !_isEncoding;
    _errorMessage = null;
    notifyListeners();
  }

  bool _isPermissionPermanentlyDenied = false;

  bool get isPermissionPermanentlyDenied => _isPermissionPermanentlyDenied;

  Future<void> openSettings() async {
    await openAppSettings();
  }

  Future<bool> _checkMicrophonePermission() async {
    _isPermissionPermanentlyDenied = false;
    
    // First check with recorder package (more reliable for iOS)
    final hasRecorderPermission = await _recorder.hasPermission();
    debugPrint('DEBUG [AudioEncoderProvider._checkMicrophonePermission]: Recorder permission: $hasRecorderPermission');
    
    if (hasRecorderPermission) {
      debugPrint('DEBUG [AudioEncoderProvider._checkMicrophonePermission]: Recorder has permission, allowing');
      return true;
    }
    
    // If recorder doesn't have permission, check with permission_handler
    var status = await Permission.microphone.status;
    debugPrint('DEBUG [AudioEncoderProvider._checkMicrophonePermission]: Permission handler status: $status');
    
    if (status.isGranted) {
      // Permission is granted but recorder says no - this shouldn't happen
      debugPrint('WARNING [AudioEncoderProvider._checkMicrophonePermission]: Permission granted but recorder says no');
      return false;
    }
    
    if (status.isPermanentlyDenied) {
      // Permission is permanently denied, user needs to go to settings
      _isPermissionPermanentlyDenied = true;
      debugPrint('ERROR [AudioEncoderProvider._checkMicrophonePermission]: Permission permanently denied');
      return false;
    }
    
    if (status.isDenied) {
      // Request permission
      debugPrint('DEBUG [AudioEncoderProvider._checkMicrophonePermission]: Requesting permission...');
      status = await Permission.microphone.request();
      debugPrint('DEBUG [AudioEncoderProvider._checkMicrophonePermission]: After request status: $status');
      
      if (status.isPermanentlyDenied) {
        _isPermissionPermanentlyDenied = true;
        debugPrint('ERROR [AudioEncoderProvider._checkMicrophonePermission]: Permission permanently denied after request');
        return false;
      }
      
      if (status.isGranted) {
        // Check recorder again after permission granted
        final hasRecorderPermissionAfter = await _recorder.hasPermission();
        debugPrint('DEBUG [AudioEncoderProvider._checkMicrophonePermission]: Recorder permission after grant: $hasRecorderPermissionAfter');
        return hasRecorderPermissionAfter;
      }
    }
    
    return false;
  }

  Future<void> startRecording() async {
    try {
      _errorMessage = null;
      
      // Check permission first
      if (!await _checkMicrophonePermission()) {
        if (_isPermissionPermanentlyDenied) {
          _errorMessage = _getLocalizedString('errorRecordingAudio') + 
              ' - ' + (_locale.languageCode == 'fa' 
                  ? 'لطفاً به تنظیمات بروید و دسترسی میکروفون را فعال کنید'
                  : 'Please go to Settings and enable microphone access');
        } else {
          _errorMessage = _getLocalizedString('errorRecordingAudio');
        }
        debugPrint('ERROR [AudioEncoderProvider.startRecording]: Permission denied');
        notifyListeners();
        return;
      }

      // Double check with recorder
      if (!await _recorder.hasPermission()) {
        _errorMessage = _getLocalizedString('errorRecordingAudio');
        debugPrint('ERROR [AudioEncoderProvider.startRecording]: Recorder has no permission');
        notifyListeners();
        return;
      }

      final dir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${dir.path}/audio_$timestamp.m4a';
      
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath,
      );
      
      isRecording = true;
      _recordingDuration = Duration.zero;
      recordedAudioFile = File(filePath);
      notifyListeners();
      
      // Update duration every second
      _updateRecordingDuration();
    } catch (e) {
      _errorMessage = '${_getLocalizedString('errorRecordingAudio')}: $e';
      debugPrint('ERROR [AudioEncoderProvider.startRecording]: Exception: $e');
      debugPrint('ERROR StackTrace: ${StackTrace.current}');
      notifyListeners();
    }
  }

  void _updateRecordingDuration() {
    if (isRecording) {
      Future.delayed(const Duration(seconds: 1), () {
        if (isRecording) {
          _recordingDuration = (_recordingDuration ?? Duration.zero) + const Duration(seconds: 1);
          notifyListeners();
          _updateRecordingDuration();
        }
      });
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await _recorder.stop();
      isRecording = false;
      
      if (path != null) {
        recordedAudioFile = File(path);
        selectedAudioToEncode = recordedAudioFile;
        originalAudioToEncode = recordedAudioFile;
        isEncoded = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = '${_getLocalizedString('errorRecordingAudio')}: $e';
      debugPrint('ERROR [AudioEncoderProvider.stopRecording]: $_errorMessage');
      debugPrint('ERROR StackTrace: ${StackTrace.current}');
      notifyListeners();
    }
  }

  Future<void> playAudio(File audioFile) async {
    try {
      _errorMessage = null;
      
      if (isPlaying) {
        await _player.pause();
        isPlaying = false;
      } else {
        await _player.play(DeviceFileSource(audioFile.path));
        isPlaying = true;
      }
      
      notifyListeners();
    } catch (e) {
      _errorMessage = '${_getLocalizedString('errorPlayingAudio')}: $e';
      debugPrint('ERROR [AudioEncoderProvider.playAudio]: $_errorMessage');
      debugPrint('ERROR StackTrace: ${StackTrace.current}');
      isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> stopPlaying() async {
    try {
      await _player.stop();
      isPlaying = false;
      _playbackPosition = Duration.zero;
      notifyListeners();
    } catch (e) {
      _errorMessage = '${_getLocalizedString('errorPlayingAudio')}: $e';
      debugPrint('ERROR [AudioEncoderProvider.stopPlaying]: $_errorMessage');
      debugPrint('ERROR StackTrace: ${StackTrace.current}');
      notifyListeners();
    }
  }

  Future<void> pickAudioToDecode() async {
    try {
      _errorMessage = null;
      // Use file_picker to pick encrypted audio file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final file = File(filePath);
        selectedAudioToDecode = file;
        originalAudioToDecode = file;
        isDecoded = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = '${_getLocalizedString('errorSelectingFile')}: $e';
      debugPrint('ERROR [AudioEncoderProvider.pickAudioToDecode]: $_errorMessage');
      debugPrint('ERROR StackTrace: ${StackTrace.current}');
      notifyListeners();
    }
  }

  void clearAudio() {
    recordedAudioFile = null;
    selectedAudioToEncode = null;
    originalAudioToEncode = null;
    selectedAudioToDecode = null;
    originalAudioToDecode = null;
    isEncoded = false;
    isDecoded = false;
    isPlaying = false;
    _playbackPosition = null;
    _playbackDuration = null;
    _recordingDuration = null;
    _errorMessage = null;
    keyController.clear();
    _player.stop();
    notifyListeners();
  }

  Future<void> encodeAudio(File file, String key) async {
    if (isLoadingEncode) return;

    _errorMessage = null;
    isLoadingEncode = true;
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

      if (originalAudioToEncode == null || originalAudioToEncode!.path != file.path) {
        originalAudioToEncode = file;
      }

      final encoded = await AudioService.encodeFile(file, key);
      selectedAudioToEncode = encoded;
      isEncoded = true;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint('ERROR [AudioEncoderProvider.encodeAudio]: $_errorMessage');
      debugPrint('ERROR StackTrace: ${StackTrace.current}');
      isEncoded = false;
    } finally {
      isLoadingEncode = false;
      notifyListeners();
    }
  }

  Future<void> decodeAudio(File file, String key) async {
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

      if (originalAudioToDecode == null || originalAudioToDecode!.path != file.path) {
        originalAudioToDecode = file;
      }

      final decoded = await AudioService.decodeFile(file, key);
      selectedAudioToDecode = decoded;
      isDecoded = true;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint('ERROR [AudioEncoderProvider.decodeAudio]: $_errorMessage');
      debugPrint('ERROR StackTrace: ${StackTrace.current}');
      isDecoded = false;
    } finally {
      isLoadingDecode = false;
      notifyListeners();
    }
  }

  Future<void> shareEncodedAudio() async {
    if (selectedAudioToEncode == null) {
      _errorMessage = _getLocalizedString('noEncryptedAudioToShare');
      notifyListeners();
      return;
    }

    try {
      final xFile = XFile(
        selectedAudioToEncode!.path,
        mimeType: 'application/octet-stream',
      );
      
      if (Platform.isIOS) {
        // iOS requires sharePositionOrigin for iPad
        await Share.shareXFiles(
          [xFile],
          text: _getLocalizedString('encryptedAudio'),
          sharePositionOrigin: const Rect.fromLTWH(0, 0, 100, 100),
        );
      } else {
        await Share.shareXFiles(
          [xFile],
          text: _getLocalizedString('encryptedAudio'),
        );
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint('ERROR [AudioEncoderProvider.shareEncodedAudio]: $_errorMessage');
      debugPrint('ERROR StackTrace: ${StackTrace.current}');
      debugPrint('ERROR File path: ${selectedAudioToEncode?.path}');
      notifyListeners();
    }
  }

  Future<void> shareDecodedAudio() async {
    if (selectedAudioToDecode == null || !isDecoded) {
      _errorMessage = _getLocalizedString('noDecryptedAudioToShare');
      notifyListeners();
      return;
    }

    if (selectedAudioToDecode!.path == originalAudioToDecode?.path) {
      _errorMessage = _getLocalizedString('fileNotDecrypted');
      notifyListeners();
      return;
    }

    try {
      // Determine mimeType based on file extension
      String mimeType = 'audio/m4a';
      final extension = selectedAudioToDecode!.path.split('.').last.toLowerCase();
      if (extension == 'm4a') {
        mimeType = 'audio/m4a';
      } else if (extension == 'mp3') {
        mimeType = 'audio/mpeg';
      } else if (extension == 'wav') {
        mimeType = 'audio/wav';
      } else if (extension == 'aac') {
        mimeType = 'audio/aac';
      }
      
      final xFile = XFile(
        selectedAudioToDecode!.path,
        mimeType: mimeType,
      );
      
      if (Platform.isIOS) {
        // iOS requires sharePositionOrigin for iPad
        await Share.shareXFiles(
          [xFile],
          text: _getLocalizedString('decryptedAudio'),
          sharePositionOrigin: const Rect.fromLTWH(0, 0, 100, 100),
        );
      } else {
        await Share.shareXFiles(
          [xFile],
          text: _getLocalizedString('decryptedAudio'),
        );
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint('ERROR [AudioEncoderProvider.shareDecodedAudio]: $_errorMessage');
      debugPrint('ERROR StackTrace: ${StackTrace.current}');
      debugPrint('ERROR File path: ${selectedAudioToDecode?.path}');
      notifyListeners();
    }
  }

  Future<void> saveEncodedAudio(String dialogTitle) async {
    if (selectedAudioToEncode == null) {
      _errorMessage = _getLocalizedString('noEncryptedAudioToSave');
      notifyListeners();
      return;
    }

    try {
      // Read base64 string from file and convert to UTF-8 bytes
      final base64String = await selectedAudioToEncode!.readAsString();
      final bytes = utf8.encode(base64String);

      // Preserve original extension and add .encrypted
      String fileNameToSave = 'encrypted_audio.encrypted';
      final originalName = selectedAudioToEncode!.path.split('/').last;
      if (originalName.contains('_')) {
        final baseName = originalName.replaceAll(RegExp(r'_\d+_\d+.*$'), '');
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
      debugPrint('ERROR [AudioEncoderProvider.saveEncodedAudio]: $_errorMessage');
      debugPrint('ERROR StackTrace: ${StackTrace.current}');
      notifyListeners();
    }
  }

  Future<void> saveDecodedAudio(String dialogTitle) async {
    if (selectedAudioToDecode == null || !isDecoded) {
      _errorMessage = _getLocalizedString('noDecryptedAudioToSave');
      notifyListeners();
      return;
    }

    // Ensure we're using the decoded file, not the encrypted one
    if (selectedAudioToDecode!.path == originalAudioToDecode?.path) {
      _errorMessage = _getLocalizedString('fileNotDecrypted');
      notifyListeners();
      return;
    }

    try {
      // Read decrypted audio file as bytes
      final bytes = await selectedAudioToDecode!.readAsBytes();

      // Extract original name from file path
      String fileNameToSave = 'decrypted_audio.m4a';
      final originalName = selectedAudioToDecode!.path.split('/').last;
      if (originalName.contains('_')) {
        // Remove timestamp pattern: _timestamp_randomnumber
        final baseName = originalName.replaceAll(RegExp(r'_\d+_\d+'), '');
        final extension = originalName.contains('.')
            ? originalName.substring(originalName.lastIndexOf('.'))
            : '.m4a';
        fileNameToSave = baseName.endsWith(extension)
            ? baseName
            : '${baseName.split('.').first}$extension';
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
      debugPrint('ERROR [AudioEncoderProvider.saveDecodedAudio]: $_errorMessage');
      debugPrint('ERROR StackTrace: ${StackTrace.current}');
      notifyListeners();
    }
  }
}

