import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class PhotoService {
  final _picker = ImagePicker();

  Future<File?> takePhoto() async {
    final XFile? shot = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxWidth: 1600,
    );
    if (shot == null) return null;

    final docs = await getApplicationDocumentsDirectory();
    final photosDir = Directory(path.join(docs.path, 'fotos'));
    await photosDir.create(recursive: true);
    final dest = path.join(
      photosDir.path,
      'denuncia_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    return File(shot.path).copy(dest);
  }
}
