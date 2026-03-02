import 'dart:async';
import 'dart:collection';

import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';
import 'package:ipr_s3/features/files/data/models/file_task.dart';
import 'package:ipr_s3/features/files/data/models/queue_progress.dart';
import 'package:ipr_s3/features/files/data/services/file_encryption_service.dart';

export 'package:ipr_s3/features/files/data/models/file_task.dart';
export 'package:ipr_s3/features/files/data/models/queue_progress.dart';

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

    if (!_isProcessing) {
      _processQueue();
    }
  }

  void enqueueAll(List<FileTask> tasks) {
    for (final task in tasks) {
      _queue.addLast(task);
    }
    _totalEnqueued += tasks.length;

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

      try {
        final encrypted = await _encryptionService.encrypt(task.data);
        _completedCount++;

        _progressController.add(
          QueueProgress(
            fileId: task.fileId,
            fileName: task.fileName,
            completedCount: _completedCount,
            totalCount: total,
            isComplete: _queue.isEmpty,
            encryptedData: encrypted,
          ),
        );
      } catch (e, stackTrace) {
        _logger.error('Encryption failed for task', e, stackTrace);
        _completedCount++;

        _progressController.add(
          QueueProgress(
            fileId: task.fileId,
            fileName: task.fileName,
            completedCount: _completedCount,
            totalCount: total,
            isComplete: _queue.isEmpty,
          ),
        );
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
  }

  void dispose() {
    clear();
    _progressController.close();
  }
}
