import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Recurso 1 — CÂMERA.
/// Abre a câmera nativa, e copia a foto para a pasta do app
/// (o arquivo temporário do image_picker pode ser apagado pelo sistema).
class PhotoService {
  final _picker = ImagePicker();

  Future<File?> takePhoto() async {
    final XFile? shot = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxWidth: 1600,
    );
    if (shot == null) return null; // usuário cancelou

    final docs = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(docs.path, 'fotos'));
    await photosDir.create(recursive: true);
    final dest = p.join(
      photosDir.path,
      'denuncia_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    return File(shot.path).copy(dest);
  }
}
