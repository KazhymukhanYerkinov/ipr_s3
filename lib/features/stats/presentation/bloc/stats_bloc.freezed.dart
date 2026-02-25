// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stats_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StatsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            int totalFiles,
            int totalSize,
            Map<FileType, int> countByType,
            Map<FileType, int> sizeByType,
            List<SecureFileEntity> recentFiles,
            List<SecureFileEntity> largestFiles)
        loaded,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            int totalFiles,
            int totalSize,
            Map<FileType, int> countByType,
            Map<FileType, int> sizeByType,
            List<SecureFileEntity> recentFiles,
            List<SecureFileEntity> largestFiles)?
        loaded,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            int totalFiles,
            int totalSize,
            Map<FileType, int> countByType,
            Map<FileType, int> sizeByType,
            List<SecureFileEntity> recentFiles,
            List<SecureFileEntity> largestFiles)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StatsInitial value) initial,
    required TResult Function(StatsLoading value) loading,
    required TResult Function(StatsLoaded value) loaded,
    required TResult Function(StatsError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StatsInitial value)? initial,
    TResult? Function(StatsLoading value)? loading,
    TResult? Function(StatsLoaded value)? loaded,
    TResult? Function(StatsError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StatsInitial value)? initial,
    TResult Function(StatsLoading value)? loading,
    TResult Function(StatsLoaded value)? loaded,
    TResult Function(StatsError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatsStateCopyWith<$Res> {
  factory $StatsStateCopyWith(
          StatsState value, $Res Function(StatsState) then) =
      _$StatsStateCopyWithImpl<$Res, StatsState>;
}

/// @nodoc
class _$StatsStateCopyWithImpl<$Res, $Val extends StatsState>
    implements $StatsStateCopyWith<$Res> {
  _$StatsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$StatsInitialImplCopyWith<$Res> {
  factory _$$StatsInitialImplCopyWith(
          _$StatsInitialImpl value, $Res Function(_$StatsInitialImpl) then) =
      __$$StatsInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StatsInitialImplCopyWithImpl<$Res>
    extends _$StatsStateCopyWithImpl<$Res, _$StatsInitialImpl>
    implements _$$StatsInitialImplCopyWith<$Res> {
  __$$StatsInitialImplCopyWithImpl(
      _$StatsInitialImpl _value, $Res Function(_$StatsInitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$StatsInitialImpl implements StatsInitial {
  const _$StatsInitialImpl();

  @override
  String toString() {
    return 'StatsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StatsInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            int totalFiles,
            int totalSize,
            Map<FileType, int> countByType,
            Map<FileType, int> sizeByType,
            List<SecureFileEntity> recentFiles,
            List<SecureFileEntity> largestFiles)
        loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            int totalFiles,
            int totalSize,
            Map<FileType, int> countByType,
            Map<FileType, int> sizeByType,
            List<SecureFileEntity> recentFiles,
            List<SecureFileEntity> largestFiles)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            int totalFiles,
            int totalSize,
            Map<FileType, int> countByType,
            Map<FileType, int> sizeByType,
            List<SecureFileEntity> recentFiles,
            List<SecureFileEntity> largestFiles)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StatsInitial value) initial,
    required TResult Function(StatsLoading value) loading,
    required TResult Function(StatsLoaded value) loaded,
    required TResult Function(StatsError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StatsInitial value)? initial,
    TResult? Function(StatsLoading value)? loading,
    TResult? Function(StatsLoaded value)? loaded,
    TResult? Function(StatsError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StatsInitial value)? initial,
    TResult Function(StatsLoading value)? loading,
    TResult Function(StatsLoaded value)? loaded,
    TResult Function(StatsError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class StatsInitial implements StatsState {
  const factory StatsInitial() = _$StatsInitialImpl;
}

/// @nodoc
abstract class _$$StatsLoadingImplCopyWith<$Res> {
  factory _$$StatsLoadingImplCopyWith(
          _$StatsLoadingImpl value, $Res Function(_$StatsLoadingImpl) then) =
      __$$StatsLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StatsLoadingImplCopyWithImpl<$Res>
    extends _$StatsStateCopyWithImpl<$Res, _$StatsLoadingImpl>
    implements _$$StatsLoadingImplCopyWith<$Res> {
  __$$StatsLoadingImplCopyWithImpl(
      _$StatsLoadingImpl _value, $Res Function(_$StatsLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$StatsLoadingImpl implements StatsLoading {
  const _$StatsLoadingImpl();

  @override
  String toString() {
    return 'StatsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StatsLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            int totalFiles,
            int totalSize,
            Map<FileType, int> countByType,
            Map<FileType, int> sizeByType,
            List<SecureFileEntity> recentFiles,
            List<SecureFileEntity> largestFiles)
        loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            int totalFiles,
            int totalSize,
            Map<FileType, int> countByType,
            Map<FileType, int> sizeByType,
            List<SecureFileEntity> recentFiles,
            List<SecureFileEntity> largestFiles)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            int totalFiles,
            int totalSize,
            Map<FileType, int> countByType,
            Map<FileType, int> sizeByType,
            List<SecureFileEntity> recentFiles,
            List<SecureFileEntity> largestFiles)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StatsInitial value) initial,
    required TResult Function(StatsLoading value) loading,
    required TResult Function(StatsLoaded value) loaded,
    required TResult Function(StatsError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StatsInitial value)? initial,
    TResult? Function(StatsLoading value)? loading,
    TResult? Function(StatsLoaded value)? loaded,
    TResult? Function(StatsError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StatsInitial value)? initial,
    TResult Function(StatsLoading value)? loading,
    TResult Function(StatsLoaded value)? loaded,
    TResult Function(StatsError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class StatsLoading implements StatsState {
  const factory StatsLoading() = _$StatsLoadingImpl;
}

/// @nodoc
abstract class _$$StatsLoadedImplCopyWith<$Res> {
  factory _$$StatsLoadedImplCopyWith(
          _$StatsLoadedImpl value, $Res Function(_$StatsLoadedImpl) then) =
      __$$StatsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {int totalFiles,
      int totalSize,
      Map<FileType, int> countByType,
      Map<FileType, int> sizeByType,
      List<SecureFileEntity> recentFiles,
      List<SecureFileEntity> largestFiles});
}

/// @nodoc
class __$$StatsLoadedImplCopyWithImpl<$Res>
    extends _$StatsStateCopyWithImpl<$Res, _$StatsLoadedImpl>
    implements _$$StatsLoadedImplCopyWith<$Res> {
  __$$StatsLoadedImplCopyWithImpl(
      _$StatsLoadedImpl _value, $Res Function(_$StatsLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalFiles = null,
    Object? totalSize = null,
    Object? countByType = null,
    Object? sizeByType = null,
    Object? recentFiles = null,
    Object? largestFiles = null,
  }) {
    return _then(_$StatsLoadedImpl(
      totalFiles: null == totalFiles
          ? _value.totalFiles
          : totalFiles // ignore: cast_nullable_to_non_nullable
              as int,
      totalSize: null == totalSize
          ? _value.totalSize
          : totalSize // ignore: cast_nullable_to_non_nullable
              as int,
      countByType: null == countByType
          ? _value._countByType
          : countByType // ignore: cast_nullable_to_non_nullable
              as Map<FileType, int>,
      sizeByType: null == sizeByType
          ? _value._sizeByType
          : sizeByType // ignore: cast_nullable_to_non_nullable
              as Map<FileType, int>,
      recentFiles: null == recentFiles
          ? _value._recentFiles
          : recentFiles // ignore: cast_nullable_to_non_nullable
              as List<SecureFileEntity>,
      largestFiles: null == largestFiles
          ? _value._largestFiles
          : largestFiles // ignore: cast_nullable_to_non_nullable
              as List<SecureFileEntity>,
    ));
  }
}

/// @nodoc

class _$StatsLoadedImpl implements StatsLoaded {
  const _$StatsLoadedImpl(
      {required this.totalFiles,
      required this.totalSize,
      required final Map<FileType, int> countByType,
      required final Map<FileType, int> sizeByType,
      required final List<SecureFileEntity> recentFiles,
      required final List<SecureFileEntity> largestFiles})
      : _countByType = countByType,
        _sizeByType = sizeByType,
        _recentFiles = recentFiles,
        _largestFiles = largestFiles;

  @override
  final int totalFiles;
  @override
  final int totalSize;
  final Map<FileType, int> _countByType;
  @override
  Map<FileType, int> get countByType {
    if (_countByType is EqualUnmodifiableMapView) return _countByType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_countByType);
  }

  final Map<FileType, int> _sizeByType;
  @override
  Map<FileType, int> get sizeByType {
    if (_sizeByType is EqualUnmodifiableMapView) return _sizeByType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_sizeByType);
  }

  final List<SecureFileEntity> _recentFiles;
  @override
  List<SecureFileEntity> get recentFiles {
    if (_recentFiles is EqualUnmodifiableListView) return _recentFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentFiles);
  }

  final List<SecureFileEntity> _largestFiles;
  @override
  List<SecureFileEntity> get largestFiles {
    if (_largestFiles is EqualUnmodifiableListView) return _largestFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_largestFiles);
  }

  @override
  String toString() {
    return 'StatsState.loaded(totalFiles: $totalFiles, totalSize: $totalSize, countByType: $countByType, sizeByType: $sizeByType, recentFiles: $recentFiles, largestFiles: $largestFiles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatsLoadedImpl &&
            (identical(other.totalFiles, totalFiles) ||
                other.totalFiles == totalFiles) &&
            (identical(other.totalSize, totalSize) ||
                other.totalSize == totalSize) &&
            const DeepCollectionEquality()
                .equals(other._countByType, _countByType) &&
            const DeepCollectionEquality()
                .equals(other._sizeByType, _sizeByType) &&
            const DeepCollectionEquality()
                .equals(other._recentFiles, _recentFiles) &&
            const DeepCollectionEquality()
                .equals(other._largestFiles, _largestFiles));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalFiles,
      totalSize,
      const DeepCollectionEquality().hash(_countByType),
      const DeepCollectionEquality().hash(_sizeByType),
      const DeepCollectionEquality().hash(_recentFiles),
      const DeepCollectionEquality().hash(_largestFiles));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StatsLoadedImplCopyWith<_$StatsLoadedImpl> get copyWith =>
      __$$StatsLoadedImplCopyWithImpl<_$StatsLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            int totalFiles,
            int totalSize,
            Map<FileType, int> countByType,
            Map<FileType, int> sizeByType,
            List<SecureFileEntity> recentFiles,
            List<SecureFileEntity> largestFiles)
        loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(totalFiles, totalSize, countByType, sizeByType, recentFiles,
        largestFiles);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            int totalFiles,
            int totalSize,
            Map<FileType, int> countByType,
            Map<FileType, int> sizeByType,
            List<SecureFileEntity> recentFiles,
            List<SecureFileEntity> largestFiles)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(totalFiles, totalSize, countByType, sizeByType,
        recentFiles, largestFiles);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            int totalFiles,
            int totalSize,
            Map<FileType, int> countByType,
            Map<FileType, int> sizeByType,
            List<SecureFileEntity> recentFiles,
            List<SecureFileEntity> largestFiles)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(totalFiles, totalSize, countByType, sizeByType, recentFiles,
          largestFiles);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StatsInitial value) initial,
    required TResult Function(StatsLoading value) loading,
    required TResult Function(StatsLoaded value) loaded,
    required TResult Function(StatsError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StatsInitial value)? initial,
    TResult? Function(StatsLoading value)? loading,
    TResult? Function(StatsLoaded value)? loaded,
    TResult? Function(StatsError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StatsInitial value)? initial,
    TResult Function(StatsLoading value)? loading,
    TResult Function(StatsLoaded value)? loaded,
    TResult Function(StatsError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class StatsLoaded implements StatsState {
  const factory StatsLoaded(
      {required final int totalFiles,
      required final int totalSize,
      required final Map<FileType, int> countByType,
      required final Map<FileType, int> sizeByType,
      required final List<SecureFileEntity> recentFiles,
      required final List<SecureFileEntity> largestFiles}) = _$StatsLoadedImpl;

  int get totalFiles;
  int get totalSize;
  Map<FileType, int> get countByType;
  Map<FileType, int> get sizeByType;
  List<SecureFileEntity> get recentFiles;
  List<SecureFileEntity> get largestFiles;
  @JsonKey(ignore: true)
  _$$StatsLoadedImplCopyWith<_$StatsLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StatsErrorImplCopyWith<$Res> {
  factory _$$StatsErrorImplCopyWith(
          _$StatsErrorImpl value, $Res Function(_$StatsErrorImpl) then) =
      __$$StatsErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$StatsErrorImplCopyWithImpl<$Res>
    extends _$StatsStateCopyWithImpl<$Res, _$StatsErrorImpl>
    implements _$$StatsErrorImplCopyWith<$Res> {
  __$$StatsErrorImplCopyWithImpl(
      _$StatsErrorImpl _value, $Res Function(_$StatsErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$StatsErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$StatsErrorImpl implements StatsError {
  const _$StatsErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'StatsState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatsErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StatsErrorImplCopyWith<_$StatsErrorImpl> get copyWith =>
      __$$StatsErrorImplCopyWithImpl<_$StatsErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            int totalFiles,
            int totalSize,
            Map<FileType, int> countByType,
            Map<FileType, int> sizeByType,
            List<SecureFileEntity> recentFiles,
            List<SecureFileEntity> largestFiles)
        loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            int totalFiles,
            int totalSize,
            Map<FileType, int> countByType,
            Map<FileType, int> sizeByType,
            List<SecureFileEntity> recentFiles,
            List<SecureFileEntity> largestFiles)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            int totalFiles,
            int totalSize,
            Map<FileType, int> countByType,
            Map<FileType, int> sizeByType,
            List<SecureFileEntity> recentFiles,
            List<SecureFileEntity> largestFiles)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StatsInitial value) initial,
    required TResult Function(StatsLoading value) loading,
    required TResult Function(StatsLoaded value) loaded,
    required TResult Function(StatsError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StatsInitial value)? initial,
    TResult? Function(StatsLoading value)? loading,
    TResult? Function(StatsLoaded value)? loaded,
    TResult? Function(StatsError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StatsInitial value)? initial,
    TResult Function(StatsLoading value)? loading,
    TResult Function(StatsLoaded value)? loaded,
    TResult Function(StatsError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class StatsError implements StatsState {
  const factory StatsError({required final String message}) = _$StatsErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$StatsErrorImplCopyWith<_$StatsErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
