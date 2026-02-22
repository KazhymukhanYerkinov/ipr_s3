import 'dart:async';
import 'dart:isolate';

import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';
import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';

/// Message sent from the main isolate to the search worker.
class SearchRequest {
  final String query;
  final List<Map<String, dynamic>> filesData;

  const SearchRequest({required this.query, required this.filesData});
}

/// Message sent from the search worker back to the main isolate.
class SearchResult {
  final String query;
  final List<Map<String, dynamic>> matchedFiles;

  const SearchResult({required this.query, required this.matchedFiles});
}

/// Top-level entry point for the search isolate.
/// Demonstrates bidirectional communication via SendPort/ReceivePort:
///   1. Receives main isolate's SendPort
///   2. Creates its own ReceivePort and sends its SendPort back
///   3. Listens for SearchRequest messages
///   4. Sends SearchResult responses back
void _searchIsolateEntry(SendPort mainSendPort) {
  final workerReceivePort = ReceivePort();
  mainSendPort.send(workerReceivePort.sendPort);

  workerReceivePort.listen((message) {
    if (message is SearchRequest) {
      final query = message.query.toLowerCase();

      final matched = message.filesData.where((fileData) {
        final name = (fileData['name'] as String? ?? '').toLowerCase();
        final tags = (fileData['tags'] as List<dynamic>? ?? [])
            .map((t) => t.toString().toLowerCase());

        return name.contains(query) || tags.any((tag) => tag.contains(query));
      }).toList();

      mainSendPort.send(SearchResult(query: message.query, matchedFiles: matched));
    }

    if (message == 'close') {
      workerReceivePort.close();
      Isolate.exit();
    }
  });
}

/// Service that performs full-text search on file metadata using
/// Isolate.spawn() with bidirectional SendPort/ReceivePort communication.
@lazySingleton
class FileSearchService {
  final _logger = SecureLogger();

  Isolate? _isolate;
  SendPort? _workerSendPort;
  ReceivePort? _mainReceivePort;
  StreamSubscription? _subscription;
  final _resultController = StreamController<SearchResult>.broadcast();

  Stream<SearchResult> get results => _resultController.stream;

  Future<void> initialize() async {
    if (_isolate != null) return;

    _mainReceivePort = ReceivePort();
    _isolate = await Isolate.spawn(
      _searchIsolateEntry,
      _mainReceivePort!.sendPort,
    );

    final completer = Completer<SendPort>();

    _subscription = _mainReceivePort!.listen((message) {
      if (message is SendPort && !completer.isCompleted) {
        completer.complete(message);
      } else if (message is SearchResult) {
        _resultController.add(message);
      }
    });

    _workerSendPort = await completer.future;
    _logger.info('Search isolate initialized with bidirectional communication');
  }

  /// Sends a search query to the worker isolate.
  /// Files are serialized to Map since isolates cannot share object references.
  Future<List<SecureFileEntity>> search(
    String query,
    List<SecureFileEntity> files,
  ) async {
    await initialize();

    final filesData = files
        .map((f) => {
              'id': f.id,
              'name': f.name,
              'typeIndex': f.type.index,
              'size': f.size,
              'encryptedPath': f.encryptedPath,
              'thumbnailPath': f.thumbnailPath,
              'createdAt': f.createdAt.toIso8601String(),
              'updatedAt': f.updatedAt.toIso8601String(),
              'tags': f.tags,
              'folderId': f.folderId,
            })
        .toList();

    _workerSendPort!.send(SearchRequest(query: query, filesData: filesData));

    final result = await _resultController.stream
        .firstWhere((r) => r.query == query);

    return result.matchedFiles.map(_mapToEntity).toList();
  }

  SecureFileEntity _mapToEntity(Map<String, dynamic> data) {
    return SecureFileEntity(
      id: data['id'] as String,
      name: data['name'] as String,
      type: FileType.values[data['typeIndex'] as int],
      size: data['size'] as int,
      encryptedPath: data['encryptedPath'] as String,
      thumbnailPath: data['thumbnailPath'] as String?,
      createdAt: DateTime.parse(data['createdAt'] as String),
      updatedAt: DateTime.parse(data['updatedAt'] as String),
      tags: List<String>.from(data['tags'] as List),
      folderId: data['folderId'] as String?,
    );
  }

  void dispose() {
    _workerSendPort?.send('close');
    _subscription?.cancel();
    _mainReceivePort?.close();
    _isolate?.kill(priority: Isolate.immediate);
    _resultController.close();
    _isolate = null;
    _workerSendPort = null;
    _logger.info('Search isolate disposed');
  }
}
