import '../../domain/repositories/text_encoder_repository.dart';
import '../services/obfuscated_encoder_service.dart';

class TextEncoderRepositoryImpl implements TextEncoderRepository {
  @override
  String encode(String text, String key) {
    return ObfuscatedEncoderService.encode(text, key);
  }

  @override
  String decode(String encodedText, String key) {
    return ObfuscatedEncoderService.decode(encodedText, key);
  }
}

