import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

Future<img.Image> _decodeFlutterImage(File file) async {
  Uint8List bytes = await file.readAsBytes();
  return img.decodeImage(bytes)!;
}

int _keyToSeed(String key) {
  int hash = 0x811c9dc5;
  for (int i = 0; i < key.length; i++) {
    hash ^= key.codeUnitAt(i);
    hash *= 0x01000193;
  }
  return hash & 0x7fffffff;
}

img.Image _processImage(img.Image image, String key) {
  final seed = _keyToSeed(key);
  final rand = Random(seed);

  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final pixel = image.getPixel(x, y);

      final r = pixel.r.toInt() ^ rand.nextInt(256);
      final g = pixel.g.toInt() ^ rand.nextInt(256);
      final b = pixel.b.toInt() ^ rand.nextInt(256);

      image.setPixelRgb(x, y, r, g, b);
    }
  }

  return image;
}

Future<File> _saveImage(img.Image image, [String? fileName]) async {
  final bytes = img.encodePng(image);
  final dir = await getTemporaryDirectory();

  String randomName = fileName ?? "image";
  randomName += "_${DateTime.now().millisecondsSinceEpoch}";
  randomName += "_${Random().nextInt(100000)}";

  final file = File('${dir.path}/$randomName.png');
  await file.writeAsBytes(bytes, flush: true);

  return file;
}

Future<File> encodeFile(
  File inputFile,
  String key, {
  String fileName = "encoded_image",
}) async {
  final image = await _decodeFlutterImage(inputFile);
  final encoded = _processImage(image, key);
  return _saveImage(encoded, fileName);
}

Future<File> decodeFile(
  File encodedFile,
  String key, {
  String fileName = "decoded_image",
}) async {
  final image = await _decodeFlutterImage(encodedFile);
  final decoded = _processImage(image, key);
  return _saveImage(decoded, fileName);
}

Future<void> saveToGallery(File imageFile) async {
  await GallerySaver.saveImage(imageFile.path, albumName: "Encodit");
}
