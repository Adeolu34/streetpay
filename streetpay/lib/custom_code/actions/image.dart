import '/flutter_flow/flutter_flow_util.dart';
import '/services/image_compress_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

Future<FFUploadedFile> image() async {
  try {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) {
      return FFUploadedFile(bytes: Uint8List(0));
    }

    final bytes = await pickedFile.readAsBytes();
    final compressedBytes = await ImageCompressService.compressImageBytes(
      bytes,
      maxSizeKB: 150,
      minSizeKB: 100,
    );

    return FFUploadedFile(
      name: '${path.basenameWithoutExtension(pickedFile.name)}.jpg',
      bytes: compressedBytes,
      originalFilename: pickedFile.name,
    );
  } catch (e) {
    return FFUploadedFile(bytes: Uint8List(0));
  }
}
