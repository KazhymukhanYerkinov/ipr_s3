import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';
import 'package:ipr_s3/features/files/data/services/file_encryption_service.dart';

/// Represents a single file encryption task in the queue.
class FileTask {
  final String fileId;
  final String fileName;
  final Uint8List data;

  const FileTask({
    required this.fileId,
    required this.fileName,
    required this.data,
  });
}

/// Progress update emitted by the queue as tasks are processed.
class QueueProgress {
  final String fileId;
  final String fileName;
  final int completedCount;
  final int totalCount;
  final bool isComplete;
  final Uint8List? encryptedData;

  const QueueProgress({
    required this.fileId,
    required this.fileName,
    required this.completedCount,
    required this.totalCount,
    required this.isComplete,
    this.encryptedData,
  });

  double get progress => totalCount > 0 ? completedCount / totalCount : 0;
}

/// Sequential file encryption queue using [Queue] from dart:collection.
/// Processes files one by one via addLast/removeFirst,
/// emitting progress through a broadcast StreamController.
@lazySingleton
class EncryptionQueue {
  final FileEncryptionService _encryptionService;
  final _logger = SecureLogger();

  final Queue<FileTask> _queue = Queue<FileTask>();
  final _progressController = StreamController<QueueProgress>.broadcast();
  bool _isProcessing = false;
  int _totalEnqueued = 0;
  int _completedCount = 0;

  EncryptionQueue(this._encryptionService);

  Stream<QueueProgress> get progress => _progressController.stream;
  bool get isProcessing => _isProcessing;
  int get pendingCount => _queue.length;

  void enqueue(FileTask task) {
    _queue.addLast(task);
    _totalEnqueued++;
    _logger.info('Enqueued file for encryption: [REDACTED_PATH]');

    if (!_isProcessing) {
      _processQueue();
    }
  }

  void enqueueAll(List<FileTask> tasks) {
    for (final task in tasks) {
      _queue.addLast(task);
    }
    _totalEnqueued += tasks.length;
    _logger.info('Enqueued ${tasks.length} files for encryption');

    if (!_isProcessing) {
      _processQueue();
    }
  }

  Future<void> _processQueue() async {
    _isProcessing = true;
    _completedCount = 0;
    final total = _totalEnqueued;

    while (_queue.isNotEmpty) {
      final task = _queue.removeFirst();
      _logger.info('Processing encryption task: [REDACTED_PATH]');

      try {
        final encrypted = await _encryptionService.encrypt(task.data);
        _completedCount++;

        _progressController.add(QueueProgress(
          fileId: task.fileId,
          fileName: task.fileName,
          completedCount: _completedCount,
          totalCount: total,
          isComplete: _queue.isEmpty,
          encryptedData: encrypted,
        ));
      } catch (e, stackTrace) {
        _logger.error('Encryption failed for task', e, stackTrace);
        _completedCount++;

        _progressController.add(QueueProgress(
          fileId: task.fileId,
          fileName: task.fileName,
          completedCount: _completedCount,
          totalCount: total,
          isComplete: _queue.isEmpty,
        ));
      }
    }

    _isProcessing = false;
    _totalEnqueued = 0;
    _completedCount = 0;
  }

  void clear() {
    _queue.clear();
    _totalEnqueued = 0;
    _completedCount = 0;
    _logger.info('Encryption queue cleared');
  }

  void dispose() {
    clear();
    _progressController.close();
  }
}
