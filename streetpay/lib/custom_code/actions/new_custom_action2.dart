import '/flutter_flow/flutter_flow_util.dart';
import '/services/image_compress_service.dart';

Future<FFUploadedFile> newCustomAction2(
  FFUploadedFile? input, [
  int? maxSizeKB,
]) async {
  final name = (input?.name ?? input?.originalFilename ?? '').toLowerCase();
  final isProofOfAddress = name.contains('address') ||
      name.contains('proof') ||
      name.contains('verification') ||
      name.contains('utility');
  final targetSize = maxSizeKB ?? 150;
  final minSize = targetSize < 100 ? 0 : 100;
  return ImageCompressService.compressUploadedFile(
    input,
    maxSizeKB: targetSize,
    minSizeKB: minSize,
    isProof: isProofOfAddress,
  );
}
