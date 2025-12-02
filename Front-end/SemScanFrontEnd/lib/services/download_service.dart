import 'dart:convert';
import 'package:universal_io/io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../providers/story_provider.dart';

class DownloadService {
  static const String _downloadsDirName = 'downloads';

  static Future<String> _getDownloadsPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$_downloadsDirName';
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return path;
  }

  static Future<void> saveStory(Story story, List<Map<String, dynamic>> chapters) async {
    try {
      final downloadsPath = await _getDownloadsPath();
      final storyDir = Directory('$downloadsPath/${story.id}');
      if (!await storyDir.exists()) {
        await storyDir.create(recursive: true);
      }

      // Save story metadata
      final storyFile = File('${storyDir.path}/story.json');
      await storyFile.writeAsString(jsonEncode(story.toMap()));

      // Save chapters
      final chaptersFile = File('${storyDir.path}/chapters.json');
      await chaptersFile.writeAsString(jsonEncode(chapters));

      // Download and save cover image
      if (story.coverImageUrl != null && story.coverImageUrl!.isNotEmpty) {
        try {
          final response = await http.get(Uri.parse(story.coverImageUrl!));
          if (response.statusCode == 200) {
            final imageFile = File('${storyDir.path}/cover.jpg');
            await imageFile.writeAsBytes(response.bodyBytes);
          }
        } catch (e) {
          print('Error downloading cover image: $e');
        }
      }
    } catch (e) {
      throw Exception('Failed to save story: $e');
    }
  }

  static Future<List<Story>> getDownloadedStories() async {
    try {
      final downloadsPath = await _getDownloadsPath();
      final dir = Directory(downloadsPath);
      if (!await dir.exists()) return [];

      final List<Story> stories = [];
      await for (final entity in dir.list()) {
        if (entity is Directory) {
          final storyFile = File('${entity.path}/story.json');
          if (await storyFile.exists()) {
            final json = jsonDecode(await storyFile.readAsString());
            final story = Story.fromMap(json);
            
            // Check if local cover exists and update path
            final coverFile = File('${entity.path}/cover.jpg');
            if (await coverFile.exists()) {
              story.coverImageUrl = coverFile.path;
            }
            
            stories.add(story);
          }
        }
      }
      return stories;
    } catch (e) {
      print('Error getting downloaded stories: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getStoryChapters(String storyId) async {
    try {
      final downloadsPath = await _getDownloadsPath();
      final chaptersFile = File('$downloadsPath/$storyId/chapters.json');
      if (await chaptersFile.exists()) {
        final List<dynamic> json = jsonDecode(await chaptersFile.readAsString());
        return json.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Error getting story chapters: $e');
      return [];
    }
  }

  static Future<void> deleteStory(String storyId) async {
    try {
      final downloadsPath = await _getDownloadsPath();
      final storyDir = Directory('$downloadsPath/$storyId');
      if (await storyDir.exists()) {
        await storyDir.delete(recursive: true);
      }
    } catch (e) {
      throw Exception('Failed to delete story: $e');
    }
  }

  static Future<bool> isStoryDownloaded(String storyId) async {
    final downloadsPath = await _getDownloadsPath();
    final storyDir = Directory('$downloadsPath/$storyId');
    return await storyDir.exists();
  }
}
