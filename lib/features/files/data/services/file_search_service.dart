import 'dart:async';
import 'dart:isolate';

import 'package:injectable/injectable.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';
import 'package:uuid/uuid.dart';

class _SearchRequest {
  final String requestId;
  final String query;
  final List<SecureFileEntity> files;

  const _SearchRequest({
    required this.requestId,
    required this.query,
    required this.files,
  });
}

class _SearchResult {
  final String requestId;
  final List<SecureFileEntity> matchedFiles;

  const _SearchResult({required this.requestId, required this.matchedFiles});
}

void _searchIsolateEntry(SendPort mainSendPort) {
  final workerReceivePort = ReceivePort();
  mainSendPort.send(workerReceivePort.sendPort);

  workerReceivePort.listen((message) {
    if (message is _SearchRequest) {
      final query = message.query.toLowerCase();

      final matched =
          message.files.where((file) {
            final nameMatch = file.name.toLowerCase().contains(query);
            final tagMatch = file.tags.any(
              (tag) => tag.toLowerCase().contains(query),
            );
            return nameMatch || tagMatch;
          }).toList();

      mainSendPort.send(
        _SearchResult(requestId: message.requestId, matchedFiles: matched),
      );
    }
  });
}

@lazySingleton
class FileSearchService {
  Isolate? _isolate;
  SendPort? _workerSendPort;
  ReceivePort? _mainReceivePort;
  StreamSubscription? _subscription;
  final _resultController = StreamController<_SearchResult>.broadcast();
  final _uuid = const Uuid();

  static const _searchTimeout = Duration(seconds: 10);

  Future<void> initialize() async {
    if (_isolate != null) return;

    _mainReceivePort = ReceivePort();

    final errorPort = ReceivePort();
    _isolate = await Isolate.spawn(
      _searchIsolateEntry,
      _mainReceivePort!.sendPort,
      onError: errorPort.sendPort,
    );

    errorPort.listen((error) {
      _resultController.addError(Exception('Search isolate error: $error'));
    });

    final completer = Completer<SendPort>();

    _subscription = _mainReceivePort!.listen((message) {
      if (message is SendPort && !completer.isCompleted) {
        completer.complete(message);
      } else if (message is _SearchResult) {
        _resultController.add(message);
      }
    });

    _workerSendPort = await completer.future;
  }

  Future<List<SecureFileEntity>> search(
    String query,
    List<SecureFileEntity> files,
  ) async {
    await initialize();

    final requestId = _uuid.v4();

    _workerSendPort!.send(
      _SearchRequest(requestId: requestId, query: query, files: files),
    );

    final result = await _resultController.stream
        .firstWhere((r) => r.requestId == requestId)
        .timeout(_searchTimeout);

    return result.matchedFiles;
  }

  void dispose() {
    _subscription?.cancel();
    _mainReceivePort?.close();
    _isolate?.kill(priority: Isolate.immediate);
    _resultController.close();
    _isolate = null;
    _workerSendPort = null;
  }
}
