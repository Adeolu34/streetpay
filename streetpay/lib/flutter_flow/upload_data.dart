import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:mime_type/mime_type.dart';
import 'package:video_player/video_player.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow_util.dart';
import '/services/image_compress_service.dart';

const allowedFormats = {'image/png', 'image/jpeg', 'video/mp4', 'image/gif'};

class SelectedFile {
  const SelectedFile({
    this.storagePath = '',
    this.filePath,
    required this.bytes,
    this.dimensions,
    this.blurHash,
    this.originalFilename = '',
  });
  final String storagePath;
  final String? filePath;
  final Uint8List bytes;
  final MediaDimensions? dimensions;
  final String? blurHash;
  final String originalFilename;
}

class MediaDimensions {
  const MediaDimensions({
    this.height,
    this.width,
  });
  final double? height;
  final double? width;
}

enum MediaSource {
  photoGallery,
  videoGallery,
  camera,
}

void _ensureAndroidPhotoPickerEnabled() {
  if (!kIsWeb && Platform.isAndroid) {
    try {
      final picker = ImagePickerPlatform.instance;
      if (picker is ImagePickerAndroid) {
        picker.useAndroidPhotoPicker = true;
      }
    } catch (e) {
      debugPrint('Failed to enable Android Photo Picker: $e');
    }
  }
}

Future<List<SelectedFile>?> selectMediaWithSourceBottomSheet({
  required BuildContext context,
  String? storageFolderPath,
  double? maxWidth,
  double? maxHeight,
  int? imageQuality,
  required bool allowPhoto,
  bool allowVideo = false,
  String pickerFontFamily = 'Outfit',
  Color? textColor,
  Color? backgroundColor,
  bool includeDimensions = false,
  bool includeBlurHash = false,
}) async {
  _ensureAndroidPhotoPickerEnabled();

  final theme = FlutterFlowTheme.of(context);
  final sheetBgColor = backgroundColor ?? theme.secondaryBackground;
  final titleColor = textColor ?? theme.primaryText;
  final subColor = theme.secondaryText;

  final mediaSource = await showModalBottomSheet<MediaSource>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: false,
    builder: (sheetContext) {
      return Container(
        decoration: BoxDecoration(
          color: sheetBgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Upload Media',
                style: GoogleFonts.getFont(
                  pickerFontFamily,
                  color: titleColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Select a source to continue',
                style: GoogleFonts.getFont(
                  pickerFontFamily,
                  color: subColor,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),
              if (allowPhoto) ...[
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.photo_library_outlined, color: theme.primary, size: 24),
                  ),
                  title: Text(
                    allowVideo ? 'Gallery (Photo)' : 'Photo Gallery',
                    style: GoogleFonts.getFont(
                      pickerFontFamily,
                      color: titleColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Choose an image from your device',
                    style: TextStyle(color: subColor, fontSize: 12),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onTap: () => Navigator.of(sheetContext).pop(MediaSource.photoGallery),
                ),
                const SizedBox(height: 6),
              ],
              if (allowVideo) ...[
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.video_library_outlined, color: Colors.purple, size: 24),
                  ),
                  title: Text(
                    'Video Gallery',
                    style: GoogleFonts.getFont(
                      pickerFontFamily,
                      color: titleColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Choose a video from your device',
                    style: TextStyle(color: subColor, fontSize: 12),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onTap: () => Navigator.of(sheetContext).pop(MediaSource.videoGallery),
                ),
                const SizedBox(height: 6),
              ],
              if (!kIsWeb) ...[
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.camera_alt_outlined, color: Colors.teal, size: 24),
                  ),
                  title: Text(
                    'Camera',
                    style: GoogleFonts.getFont(
                      pickerFontFamily,
                      color: titleColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Take a new photo with your camera',
                    style: TextStyle(color: subColor, fontSize: 12),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onTap: () => Navigator.of(sheetContext).pop(MediaSource.camera),
                ),
              ],
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.primaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.alternate,
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 16,
                      color: theme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Our app allows users to verify and update their profile by uploading photos or videos. These media files are encrypted on the device before upload to protect user privacy. This operation is infrequent and occurs only at user request.',
                        style: GoogleFonts.getFont(
                          pickerFontFamily,
                          color: subColor,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  if (mediaSource == null) {
    return null;
  }

  // Allow sheet dismissal animation to fully finish before native intent launches
  await Future.delayed(const Duration(milliseconds: 200));

  return selectMedia(
    context: context,
    storageFolderPath: storageFolderPath,
    maxWidth: maxWidth,
    maxHeight: maxHeight,
    imageQuality: imageQuality,
    isVideo: mediaSource == MediaSource.videoGallery ||
        (mediaSource == MediaSource.camera && allowVideo && !allowPhoto),
    mediaSource: mediaSource,
    includeDimensions: includeDimensions,
    includeBlurHash: includeBlurHash,
  );
}

bool _isSelectingMedia = false;

Future<List<SelectedFile>?> selectMedia({
  BuildContext? context,
  String? storageFolderPath,
  double? maxWidth,
  double? maxHeight,
  int? imageQuality,
  bool isVideo = false,
  MediaSource mediaSource = MediaSource.camera,
  bool multiImage = false,
  bool includeDimensions = false,
  bool includeBlurHash = false,
}) async {
  if (_isSelectingMedia) {
    debugPrint('selectMedia already in progress, skipping duplicate call.');
    return null;
  }
  _isSelectingMedia = true;

  try {
    _ensureAndroidPhotoPickerEnabled();
    final picker = ImagePicker();

    if (multiImage) {
      List<XFile> pickedMedia = [];
      try {
        pickedMedia = await picker.pickMultiImage(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
        );
      } catch (e) {
        debugPrint('pickMultiImage exception: $e. Attempting FilePicker fallback.');
        try {
          final res = await FilePicker.platform.pickFiles(
            type: FileType.image,
            allowMultiple: true,
            withData: true,
          );
          if (res != null && res.files.isNotEmpty) {
            return Future.wait(res.files.asMap().entries.map((e) async {
              final index = e.key;
              final file = e.value;
              var mediaBytes = file.bytes ?? (file.path != null ? await File(file.path!).readAsBytes() : Uint8List(0));
              if (mediaBytes.length > 150 * 1024) {
                mediaBytes = await ImageCompressService.compressImageBytes(mediaBytes, maxSizeKB: 150, minSizeKB: 100);
              }
              final path = _getStoragePath(storageFolderPath, file.name, false, index);
              final dimensions = includeDimensions ? _getImageDimensions(mediaBytes) : null;
              return SelectedFile(
                storagePath: path,
                filePath: kIsWeb ? null : file.path,
                bytes: mediaBytes,
                dimensions: await dimensions,
                originalFilename: file.name,
              );
            }));
          }
        } catch (fErr) {
          debugPrint('FilePicker multi fallback error: $fErr');
        }
      }

      if (pickedMedia.isEmpty) {
        return null;
      }
      return Future.wait(pickedMedia.asMap().entries.map((e) async {
        final index = e.key;
        final media = e.value;
        var mediaBytes = await media.readAsBytes();
        if (!isVideo && mediaBytes.length > 150 * 1024) {
          mediaBytes = await ImageCompressService.compressImageBytes(mediaBytes, maxSizeKB: 150, minSizeKB: 100);
        }
        final path = _getStoragePath(storageFolderPath, media.name, false, index);
        final dimensions = includeDimensions
            ? isVideo
                ? _getVideoDimensions(media.path)
                : _getImageDimensions(mediaBytes)
            : null;

        return SelectedFile(
          storagePath: path,
          filePath: media.path,
          bytes: mediaBytes,
          dimensions: await dimensions,
          originalFilename: media.name,
        );
      }));
    }

    final source = mediaSource == MediaSource.camera
        ? ImageSource.camera
        : ImageSource.gallery;

    XFile? pickedMedia;
    try {
      pickedMedia = isVideo
          ? await picker.pickVideo(source: source)
          : await picker.pickImage(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              imageQuality: imageQuality,
              source: source,
            );
    } catch (e) {
      debugPrint('picker.pickImage/Video exception: $e');
      if (source == ImageSource.gallery && !isVideo) {
        debugPrint('Falling back to FilePicker for gallery...');
        try {
          final res = await FilePicker.platform.pickFiles(
            type: FileType.image,
            allowMultiple: false,
            withData: true,
          );
          if (res != null && res.files.isNotEmpty) {
            final file = res.files.first;
            var mediaBytes = file.bytes ?? (file.path != null ? await File(file.path!).readAsBytes() : Uint8List(0));
            if (mediaBytes.length > 150 * 1024) {
              mediaBytes = await ImageCompressService.compressImageBytes(mediaBytes, maxSizeKB: 150, minSizeKB: 100);
            }
            final path = _getStoragePath(storageFolderPath, file.name, false);
            final dimensions = includeDimensions ? _getImageDimensions(mediaBytes) : null;
            return [
              SelectedFile(
                storagePath: path,
                filePath: kIsWeb ? null : file.path,
                bytes: mediaBytes,
                dimensions: await dimensions,
                originalFilename: file.name,
              ),
            ];
          }
        } catch (fErr) {
          debugPrint('FilePicker fallback error: $fErr');
        }
      } else if (source == ImageSource.camera) {
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Camera access error or permission denied. Please grant camera permission in your phone settings.'),
              duration: Duration(seconds: 4),
            ),
          );
        }
      }
      return null;
    }

    if (pickedMedia == null) {
      return null;
    }

    var mediaBytes = await pickedMedia.readAsBytes();
    if (mediaBytes.isEmpty) {
      return null;
    }
    if (!isVideo && mediaBytes.length > 150 * 1024) {
      mediaBytes = await ImageCompressService.compressImageBytes(mediaBytes, maxSizeKB: 150, minSizeKB: 100);
    }
    final path = _getStoragePath(storageFolderPath, pickedMedia.name, isVideo);
    final dimensions = includeDimensions
        ? isVideo
            ? _getVideoDimensions(pickedMedia.path)
            : _getImageDimensions(mediaBytes)
        : null;

    return [
      SelectedFile(
        storagePath: path,
        filePath: pickedMedia.path,
        bytes: mediaBytes,
        dimensions: await dimensions,
        originalFilename: pickedMedia.name,
      ),
    ];
  } catch (e, stack) {
    debugPrint('Unexpected error in selectMedia: $e\n$stack');
    return null;
  } finally {
    _isSelectingMedia = false;
  }
}

bool validateFileFormat(String filePath, BuildContext context) {
  if (allowedFormats.contains(mime(filePath))) {
    return true;
  }
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text('Invalid file format: ${mime(filePath)}'),
    ));
  return false;
}

Future<SelectedFile?> selectFile({
  String? storageFolderPath,
  List<String>? allowedExtensions,
}) =>
    selectFiles(
      storageFolderPath: storageFolderPath,
      allowedExtensions: allowedExtensions,
      multiFile: false,
    ).then((value) => value?.first);

Future<List<SelectedFile>?> selectFiles({
  String? storageFolderPath,
  List<String>? allowedExtensions,
  bool multiFile = false,
}) async {
  final pickedFiles = await FilePicker.platform.pickFiles(
    type: allowedExtensions != null ? FileType.custom : FileType.any,
    allowedExtensions: allowedExtensions,
    withData: true,
    allowMultiple: multiFile,
  );
  if (pickedFiles == null || pickedFiles.files.isEmpty) {
    return null;
  }
  if (multiFile) {
    return Future.wait(pickedFiles.files.asMap().entries.map((e) async {
      final index = e.key;
      final file = e.value;
      var fileBytes = file.bytes!;
      if (fileBytes.length > 150 * 1024 && ImageCompressService.isImage(fileBytes, file.name)) {
        fileBytes = await ImageCompressService.compressImageBytes(fileBytes, maxSizeKB: 150, minSizeKB: 100);
      }
      final storagePath =
          _getStoragePath(storageFolderPath, file.name, false, index);
      return SelectedFile(
        storagePath: storagePath,
        filePath: isWeb ? null : file.path,
        bytes: fileBytes,
        originalFilename: file.name,
      );
    }));
  }
  final file = pickedFiles.files.first;
  if (file.bytes == null) {
    return null;
  }
  var fileBytes = file.bytes!;
  if (fileBytes.length > 150 * 1024 && ImageCompressService.isImage(fileBytes, file.name)) {
    fileBytes = await ImageCompressService.compressImageBytes(fileBytes, maxSizeKB: 150, minSizeKB: 100);
  }
  final storagePath = _getStoragePath(storageFolderPath, file.name, false);
  return [
    SelectedFile(
      storagePath: storagePath,
      filePath: isWeb ? null : file.path,
      bytes: fileBytes,
      originalFilename: file.name,
    )
  ];
}

List<SelectedFile> selectedFilesFromUploadedFiles(
  List<FFUploadedFile> uploadedFiles, {
  String? storageFolderPath,
  bool isMultiData = false,
}) =>
    uploadedFiles.asMap().entries.map(
      (entry) {
        final index = entry.key;
        final file = entry.value;
        return SelectedFile(
            storagePath: _getStoragePath(
              storageFolderPath != null ? storageFolderPath : null,
              file.name!,
              false,
              isMultiData ? index : null,
            ),
            bytes: file.bytes!,
            originalFilename: file.originalFilename);
      },
    ).toList();

Future<MediaDimensions> _getImageDimensions(Uint8List mediaBytes) async {
  final image = await decodeImageFromList(mediaBytes);
  return MediaDimensions(
    width: image.width.toDouble(),
    height: image.height.toDouble(),
  );
}

Future<MediaDimensions> _getVideoDimensions(String path) async {
  final VideoPlayerController videoPlayerController =
      VideoPlayerController.asset(path);
  await videoPlayerController.initialize();
  final size = videoPlayerController.value.size;
  return MediaDimensions(width: size.width, height: size.height);
}

String _getStoragePath(
  String? pathPrefix,
  String filePath,
  bool isVideo, [
  int? index,
]) {
  pathPrefix = _removeTrailingSlash(pathPrefix);
  final timestamp = DateTime.now().microsecondsSinceEpoch;
  // Workaround fixed by https://github.com/flutter/plugins/pull/3685
  // (not yet in stable).
  final ext = isVideo ? 'mp4' : filePath.split('.').last;
  final indexStr = index != null ? '_$index' : '';
  return '$pathPrefix/$timestamp$indexStr.$ext';
}

String getSignatureStoragePath([String? pathPrefix]) {
  pathPrefix = _removeTrailingSlash(pathPrefix);
  final timestamp = DateTime.now().microsecondsSinceEpoch;
  return '$pathPrefix/signature_$timestamp.png';
}

void showUploadMessage(
  BuildContext context,
  String message, {
  bool showLoading = false,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (showLoading)
              Padding(
                padding: EdgeInsetsDirectional.only(end: 10.0),
                child: CircularProgressIndicator(
                  valueColor: Theme.of(context).brightness == Brightness.dark
                      ? AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).accent4)
                      : null,
                ),
              ),
            Text(message),
          ],
        ),
        duration: showLoading ? Duration(days: 1) : Duration(seconds: 4),
      ),
    );
}

String? _removeTrailingSlash(String? path) => path != null && path.endsWith('/')
    ? path.substring(0, path.length - 1)
    : path;
