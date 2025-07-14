import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverUrl;
  final String category;
  final int publishYear;
  final String downloadUrl;
  final String previewUrl;
  final String webReaderUrl;
  final int viewCount;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverUrl,
    required this.category,
    required this.publishYear,
    required this.downloadUrl,
    required this.previewUrl,
    required this.webReaderUrl,
    required this.viewCount,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final accessInfo = json['accessInfo'] ?? {};

    // Extract different types of URLs
    final downloadLink =
        accessInfo['pdf']?['downloadLink'] ??
        accessInfo['epub']?['downloadLink'] ??
        '';
    final previewLink = volumeInfo['previewLink'] ?? '';
    final webReaderLink = accessInfo['webReaderLink'] ?? '';

    return Book(
      id: json['id']?.toString() ?? '',
      title: volumeInfo['title'] ?? 'Unknown Title',
      author:
          (volumeInfo['authors'] as List<dynamic>?)?.join(', ') ??
          'Unknown Author',
      description: volumeInfo['description'] ?? '',
      coverUrl: volumeInfo['imageLinks']?['thumbnail'] ?? '',
      category:
          (volumeInfo['categories'] as List<dynamic>?)?.first ?? 'General',
      publishYear: _parseYear(volumeInfo['publishedDate']),
      downloadUrl: downloadLink,
      previewUrl: previewLink,
      webReaderUrl: webReaderLink,
      viewCount: volumeInfo['ratingsCount'] ?? 0,
    );
  }

  static int _parseYear(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 0;
    try {
      // Try to extract year from various date formats
      final yearMatch = RegExp(r'\d{4}').firstMatch(dateString);
      return yearMatch != null ? int.parse(yearMatch.group(0)!) : 0;
    } catch (e) {
      return 0;
    }
  }

  // Get the best URL for previewing the book (prioritizing preview over download)
  String get bestPreviewUrl {
    if (webReaderUrl.isNotEmpty) return webReaderUrl;
    if (previewUrl.isNotEmpty) return previewUrl;
    if (downloadUrl.isNotEmpty) {
      // Use Google Docs Viewer to preview PDF instead of downloading
      return 'https://docs.google.com/gview?embedded=true&url=${Uri.encodeComponent(downloadUrl)}';
    }
    return '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'cover_url': coverUrl,
      'category': category,
      'publish_year': publishYear,
      'download_url': downloadUrl,
      'preview_url': previewUrl,
      'web_reader_url': webReaderUrl,
      'view_count': viewCount,
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    author,
    description,
    coverUrl,
    category,
    publishYear,
    downloadUrl,
    previewUrl,
    webReaderUrl,
    viewCount,
  ];
}
