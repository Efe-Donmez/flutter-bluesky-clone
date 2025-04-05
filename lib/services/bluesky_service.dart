import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bluesky_viewer/models/post/bluesky_post.dart';

class BlueskyService {
  static const String _baseUrl = 'https://bsky.social/xrpc';
  String? _authToken;
  String? _refreshToken;
  String? _did;

  Future<bool> login(String identifier, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/com.atproto.server.createSession'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'identifier': identifier,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _authToken = data['accessJwt'];
      _refreshToken = data['refreshJwt'];
      _did = data['did'];
      return true;
    }
    return false;
  }

  Future<List<BlueskyPost>> getHomeFeed({int limit = 20}) async {
    if (_authToken == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/app.bsky.feed.getTimeline?limit=$limit'),
      headers: {'Authorization': 'Bearer $_authToken'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['feed'] as List)
          .map((post) => BlueskyPost.fromJson(post))
          .toList();
    } else {
      throw Exception('Failed to load home feed');
    }
  }

  Future<List<BlueskyPost>> searchPosts(String query) async {
    if (_authToken == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/app.bsky.feed.searchPosts?q=${Uri.encodeComponent(query)}'),
      headers: {'Authorization': 'Bearer $_authToken'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['posts'] as List)
          .map((post) => BlueskyPost.fromJson(post))
          .toList();
    } else {
      throw Exception('Failed to search posts');
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    if (_authToken == null || _did == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/app.bsky.actor.getProfile?actor=$_did'),
      headers: {'Authorization': 'Bearer $_authToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<List<Map<String, dynamic>>> getMessages() async {
    if (_authToken == null) {
      throw Exception('Not authenticated');
    }

    // Note: Bluesky doesn't have a direct messages API yet
    // This is a placeholder for when it becomes available
    return [];
  }
}
