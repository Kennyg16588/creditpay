import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart' as cloudinary;
import 'package:flutter/foundation.dart';

// IMPORTANT: Define this enum locally to match generic usage and avoid breaking changes
enum CloudinaryResourceType { Image, Video, Raw, Auto }

class CloudinaryService {
  static const String _cloudName = 'dttrmkdts';
  static const String _uploadPreset = 'creditpay_uploads';

  // Initialize CloudinaryPublic client
  final cloudinary.CloudinaryPublic _cloudinary = cloudinary.CloudinaryPublic(
    _cloudName,
    _uploadPreset,
    cache: false,
  );

  /// Uploads a file to Cloudinary using cloudinary_public package.
  Future<String?> uploadFile(
    File file, {
    String? folder,
    CloudinaryResourceType? resourceType,
  }) async {
    try {
      debugPrint('☁️ Uploading to Cloudinary using cloudinary_public...');

      // Map local enum to package enum
      // Assuming CloudinaryResourceType values in the package are UpperCamelCase (Image, Video, etc.)
      // based on typical usage. If the package uses lowercase, this will need adjustment.
      cloudinary.CloudinaryResourceType pubType;
      switch (resourceType) {
        case CloudinaryResourceType.Image:
          pubType = cloudinary.CloudinaryResourceType.Image;
          break;
        case CloudinaryResourceType.Video:
          pubType = cloudinary.CloudinaryResourceType.Video;
          break;
        case CloudinaryResourceType.Raw:
          pubType = cloudinary.CloudinaryResourceType.Raw;
          break;
        case CloudinaryResourceType.Auto:
        default:
          pubType = cloudinary.CloudinaryResourceType.Auto;
          break;
      }

      final response = await _cloudinary.uploadFile(
        cloudinary.CloudinaryFile.fromFile(
          file.path,
          folder: folder,
          resourceType: pubType,
        ),
      );

      debugPrint('✅ Cloudinary Upload Success: ${response.secureUrl}');
      return response.secureUrl;
    } catch (e) {
      debugPrint('❌ Cloudinary Upload Error: $e');
      if (e.toString().contains('401')) {
        debugPrint(
          '⚠️ DETECTED 401 UNAUTHORIZED: This often means your Upload Preset ($_uploadPreset) is incorrect or set to "Signed".',
        );
        debugPrint(
          '   Please verify Cloud Name: "$_cloudName" and Preset: "$_uploadPreset".',
        );
      }

      // Try to print more details if available (depending on exception type)
      try {
        // dynamic cast to access potential dio response properties without importing dio
        final dynamic exception = e;
        if (exception.response != null) {
          debugPrint('🔎 Cloudinary Response Data: ${exception.response.data}');
          debugPrint(
            '🔎 Cloudinary Response Headers: ${exception.response.headers}',
          );
        }
      } catch (_) {}

      return null;
    }
  }
}
