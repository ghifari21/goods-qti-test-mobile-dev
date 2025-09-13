import 'package:dio/dio.dart';
import 'package:goods/data/responses/agg_asset_by_location_response.dart';
import 'package:goods/data/responses/agg_asset_by_status_response.dart';
import 'package:goods/data/responses/asset_detail_response.dart';
import 'package:goods/data/responses/asset_general_response.dart';
import 'package:goods/data/responses/asset_response.dart';
import 'package:goods/data/responses/auth_response.dart';
import 'package:goods/data/responses/general_response.dart';
import 'package:goods/data/responses/user_detail_response.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  // Authentication Endpoints
  Future<AuthResponse> login(String email, String password) async {
    try {
      // content-type: application/json
      final response = await _dio.post(
        'auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to login: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<UserDetailResponse> getUserDetails() async {
    try {
      // content-type: application/json
      final response = await _dio.get('auth/me');

      if (response.statusCode == 200) {
        return UserDetailResponse.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to fetch user details: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  // to generate new token when the old one is expired
  // using refresh token
  Future<String> generateToken(
    String username,
    String password,
    String refreshToken,
  ) async {
    try {
      // content-type: application/x-www-form-urlencoded
      final response = await _dio.post(
        'auth/token/',
        data: {'username': username, 'password': password},
        options: Options(
          headers: {
            'Authorization': 'Bearer $refreshToken',
            'Content-Type': Headers.formUrlEncodedContentType,
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['access_token'];
      } else {
        throw Exception(
          'Failed to generate token: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> logout() async {
    try {
      // content-type: application/json
      final response = await _dio.post('auth/logout');

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to logout: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  // Home Endpoints
  Future<AggAssetByStatusResponse> getAggAssetByStatus() async {
    try {
      // content-type: application/json
      final response = await _dio.get('home/agg-asset-by-status/');

      if (response.statusCode == 200) {
        return AggAssetByStatusResponse.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to fetch aggregated asset by status: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<AggAssetByLocationResponse> getAggAssetByLocation() async {
    try {
      // content-type: application/json
      final response = await _dio.get('home/agg-asset-by-location/');

      if (response.statusCode == 200) {
        return AggAssetByLocationResponse.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to fetch aggregated asset by location: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  // Location Endpoints
  Future<GeneralResponse> getAllLocations() async {
    try {
      // content-type: application/json
      final response = await _dio.get('location/');

      if (response.statusCode == 200) {
        return GeneralResponse.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to fetch locations: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  // Status Endpoints
  Future<GeneralResponse> getAllStatuses() async {
    try {
      // content-type: application/json
      final response = await _dio.get('status/');

      if (response.statusCode == 200) {
        return GeneralResponse.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to fetch statuses: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  // Asset Endpoints
  Future<AssetResponse> getAllAssets(int page, int size, String? query) async {
    try {
      // content-type: application/json
      final response = await _dio.get(
        'asset/?page=$page&size=$size${query != null ? '&search=$query' : ''}',
      );

      if (response.statusCode == 200) {
        return AssetResponse.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to fetch assets: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<AssetGeneralResponse> createAsset(
    String name,
    String statusId,
    String locationId,
  ) async {
    try {
      // content-type: application/json
      final response = await _dio.post(
        'asset/',
        data: {'name': name, 'status_id': statusId, 'location_id': locationId},
      );

      if (response.statusCode == 201) {
        return AssetGeneralResponse.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to create asset: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<AssetDetailResponse> getDetailAsset(String id) async {
    try {
      // content-type: application/json
      final response = await _dio.get('asset/$id');

      if (response.statusCode == 200) {
        return AssetDetailResponse.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to fetch asset details: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<AssetGeneralResponse> updateAsset(
    String id,
    String name,
    String statusId,
    String locationId,
  ) async {
    try {
      // content-type: application/json
      final response = await _dio.put(
        'asset/$id',
        data: {'name': name, 'status_id': statusId, 'location_id': locationId},
      );

      if (response.statusCode == 201) {
        return AssetGeneralResponse.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to update asset: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<String> deleteAsset(String id) async {
    try {
      // content-type: application/json
      final response = await _dio.delete('asset/$id');

      if (response.statusCode == 200) {
        return 'Success';
      } else {
        throw Exception(
          'Failed to delete asset: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      rethrow;
    }
  }
}
