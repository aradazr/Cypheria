import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
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

  Future<bool> _checkMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> startRecording() async {
    try {
      _errorMessage = null;
      
      if (!await _checkMicrophonePermission()) {
        _errorMessage = _getLocalizedString('errorRecordingAudio');
        notifyListeners();
        return;
      }

      if (await _recorder.hasPermission()) {
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
      } else {
        _errorMessage = _getLocalizedString('errorRecordingAudio');
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = '${_getLocalizedString('errorRecordingAudio')}: $e';
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
      await Share.shareXFiles(
        [XFile(selectedAudioToEncode!.path)],
        text: _getLocalizedString('encryptedAudio'),
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
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
      await Share.shareXFiles(
        [XFile(selectedAudioToDecode!.path)],
        text: _getLocalizedString('decryptedAudio'),
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
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
      notifyListeners();
    }
  }
}

