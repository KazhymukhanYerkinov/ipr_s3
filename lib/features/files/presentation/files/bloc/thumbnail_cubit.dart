import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/features/files/domain/use_cases/load_thumbnail.dart';

@injectable
class ThumbnailCubit extends Cubit<Map<String, Uint8List>> {
  final LoadThumbnailUseCase _loadThumbnail;

  ThumbnailCubit(this._loadThumbnail) : super(const {});

  Future<void> load(String thumbnailPath) async {
    if (state.containsKey(thumbnailPath)) return;

    final result = await _loadThumbnail(thumbnailPath);
    final bytes = result.value;
    if (bytes != null && !isClosed) {
      emit({...state, thumbnailPath: bytes});
    }
  }

  void evict(String path) {
    if (!state.containsKey(path)) return;
    emit(Map.of(state)..remove(path));
  }
}
