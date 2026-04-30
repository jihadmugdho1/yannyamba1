import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:yannyamba/core/core.dart';
import '../models/profile_model.dart';

class ProfileService {
  final NetworkCaller _networkCaller = NetworkCaller();

  ProfileService()
    : _cachedProfile = const Profile(
        name: '',
        phoneNumber: '',
        email: '',
        imageUrl: ImagePath.profileAvatar,
        roles: [],
      );

  Profile _cachedProfile;

  Future<Profile> getProfile() async {
    try {
      final token = await StorageService.getToken();
      AppLoggerHelper.debug('Token: $token');

      final response = await _networkCaller.getRequest(
        ApiConstants.getProfile,
        headers: {'Authorization': '$token'},
      );

      if (response.statusCode == 200) {
        return Profile.fromJson(response.responseData);
      }
    } catch (e) {
      rethrow;
    }
    return _cachedProfile;
  }

  Future<Profile> updateProfile(Profile updatedProfile) async {
    try {
      final token = await StorageService.getToken();
      final Map<String, dynamic> dataMap = {
        'name': updatedProfile.name,
        'email': updatedProfile.email,
      };

      final List<http.MultipartFile> files = [];

      try {
        final imagePath = updatedProfile.imageUrl;
        if (imagePath.isNotEmpty && !imagePath.startsWith('http')) {
          final file = File(imagePath);
          if (await file.exists()) {
            String contentType = 'image/jpeg';
            final extension = imagePath.toLowerCase().split('.').last;
            if (extension == 'png') {
              contentType = 'image/png';
            } else if (extension == 'jpg' || extension == 'jpeg') {
              contentType = 'image/jpeg';
            } else if (extension == 'gif') {
              contentType = 'image/gif';
            } else if (extension == 'webp') {
              contentType = 'image/webp';
            }

            final multipartFile = http.MultipartFile.fromBytes(
              'image',
              await file.readAsBytes(),
              filename: imagePath.split('/').last,
              contentType: MediaType.parse(contentType),
            );
            files.add(multipartFile);
          }
        }
      } catch (e) {
        AppLoggerHelper.error('Failed to prepare image file for upload', e);
      }

      final response = await _networkCaller.multipartRequest(
        ApiConstants.updateProfile,
        method: 'PATCH',
        fields: {'data': jsonEncode(dataMap)},
        files: files.isNotEmpty ? files : null,
        token: token,
      );

      AppLoggerHelper.debug('Update Profile Service: ${response.responseData}');

      if (response.isSuccess) {
        _cachedProfile = Profile.fromJson(response.responseData);
        return _cachedProfile;
      }
    } catch (e) {
      rethrow;
    }
    return _cachedProfile;
  }
}
