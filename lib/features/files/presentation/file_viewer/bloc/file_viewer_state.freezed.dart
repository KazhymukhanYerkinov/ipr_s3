// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_viewer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FileViewerState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(SecureFileEntity file, Uint8List bytes) loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(SecureFileEntity file, Uint8List bytes)? loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(SecureFileEntity file, Uint8List bytes)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FileViewerInitial value) initial,
    required TResult Function(FileViewerLoading value) loading,
    required TResult Function(FileViewerLoaded value) loaded,
    required TResult Function(FileViewerError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileViewerInitial value)? initial,
    TResult? Function(FileViewerLoading value)? loading,
    TResult? Function(FileViewerLoaded value)? loaded,
    TResult? Function(FileViewerError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileViewerInitial value)? initial,
    TResult Function(FileViewerLoading value)? loading,
    TResult Function(FileViewerLoaded value)? loaded,
    TResult Function(FileViewerError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileViewerStateCopyWith<$Res> {
  factory $FileViewerStateCopyWith(
    FileViewerState value,
    $Res Function(FileViewerState) then,
  ) = _$FileViewerStateCopyWithImpl<$Res, FileViewerState>;
}

/// @nodoc
class _$FileViewerStateCopyWithImpl<$Res, $Val extends FileViewerState>
    implements $FileViewerStateCopyWith<$Res> {
  _$FileViewerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$FileViewerInitialImplCopyWith<$Res> {
  factory _$$FileViewerInitialImplCopyWith(
    _$FileViewerInitialImpl value,
    $Res Function(_$FileViewerInitialImpl) then,
  ) = __$$FileViewerInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FileViewerInitialImplCopyWithImpl<$Res>
    extends _$FileViewerStateCopyWithImpl<$Res, _$FileViewerInitialImpl>
    implements _$$FileViewerInitialImplCopyWith<$Res> {
  __$$FileViewerInitialImplCopyWithImpl(
    _$FileViewerInitialImpl _value,
    $Res Function(_$FileViewerInitialImpl) _then,
  ) : super(_value, _then);
}

/// @nodoc

class _$FileViewerInitialImpl implements FileViewerInitial {
  const _$FileViewerInitialImpl();

  @override
  String toString() {
    return 'FileViewerState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FileViewerInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(SecureFileEntity file, Uint8List bytes) loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(SecureFileEntity file, Uint8List bytes)? loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(SecureFileEntity file, Uint8List bytes)? loaded,
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
    required TResult Function(FileViewerInitial value) initial,
    required TResult Function(FileViewerLoading value) loading,
    required TResult Function(FileViewerLoaded value) loaded,
    required TResult Function(FileViewerError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileViewerInitial value)? initial,
    TResult? Function(FileViewerLoading value)? loading,
    TResult? Function(FileViewerLoaded value)? loaded,
    TResult? Function(FileViewerError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileViewerInitial value)? initial,
    TResult Function(FileViewerLoading value)? loading,
    TResult Function(FileViewerLoaded value)? loaded,
    TResult Function(FileViewerError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class FileViewerInitial implements FileViewerState {
  const factory FileViewerInitial() = _$FileViewerInitialImpl;
}

/// @nodoc
abstract class _$$FileViewerLoadingImplCopyWith<$Res> {
  factory _$$FileViewerLoadingImplCopyWith(
    _$FileViewerLoadingImpl value,
    $Res Function(_$FileViewerLoadingImpl) then,
  ) = __$$FileViewerLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FileViewerLoadingImplCopyWithImpl<$Res>
    extends _$FileViewerStateCopyWithImpl<$Res, _$FileViewerLoadingImpl>
    implements _$$FileViewerLoadingImplCopyWith<$Res> {
  __$$FileViewerLoadingImplCopyWithImpl(
    _$FileViewerLoadingImpl _value,
    $Res Function(_$FileViewerLoadingImpl) _then,
  ) : super(_value, _then);
}

/// @nodoc

class _$FileViewerLoadingImpl implements FileViewerLoading {
  const _$FileViewerLoadingImpl();

  @override
  String toString() {
    return 'FileViewerState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FileViewerLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(SecureFileEntity file, Uint8List bytes) loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(SecureFileEntity file, Uint8List bytes)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(SecureFileEntity file, Uint8List bytes)? loaded,
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
    required TResult Function(FileViewerInitial value) initial,
    required TResult Function(FileViewerLoading value) loading,
    required TResult Function(FileViewerLoaded value) loaded,
    required TResult Function(FileViewerError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileViewerInitial value)? initial,
    TResult? Function(FileViewerLoading value)? loading,
    TResult? Function(FileViewerLoaded value)? loaded,
    TResult? Function(FileViewerError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileViewerInitial value)? initial,
    TResult Function(FileViewerLoading value)? loading,
    TResult Function(FileViewerLoaded value)? loaded,
    TResult Function(FileViewerError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class FileViewerLoading implements FileViewerState {
  const factory FileViewerLoading() = _$FileViewerLoadingImpl;
}

/// @nodoc
abstract class _$$FileViewerLoadedImplCopyWith<$Res> {
  factory _$$FileViewerLoadedImplCopyWith(
    _$FileViewerLoadedImpl value,
    $Res Function(_$FileViewerLoadedImpl) then,
  ) = __$$FileViewerLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SecureFileEntity file, Uint8List bytes});
}

/// @nodoc
class __$$FileViewerLoadedImplCopyWithImpl<$Res>
    extends _$FileViewerStateCopyWithImpl<$Res, _$FileViewerLoadedImpl>
    implements _$$FileViewerLoadedImplCopyWith<$Res> {
  __$$FileViewerLoadedImplCopyWithImpl(
    _$FileViewerLoadedImpl _value,
    $Res Function(_$FileViewerLoadedImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? file = null, Object? bytes = null}) {
    return _then(
      _$FileViewerLoadedImpl(
        file:
            null == file
                ? _value.file
                : file // ignore: cast_nullable_to_non_nullable
                    as SecureFileEntity,
        bytes:
            null == bytes
                ? _value.bytes
                : bytes // ignore: cast_nullable_to_non_nullable
                    as Uint8List,
      ),
    );
  }
}

/// @nodoc

class _$FileViewerLoadedImpl implements FileViewerLoaded {
  const _$FileViewerLoadedImpl({required this.file, required this.bytes});

  @override
  final SecureFileEntity file;
  @override
  final Uint8List bytes;

  @override
  String toString() {
    return 'FileViewerState.loaded(file: $file, bytes: $bytes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileViewerLoadedImpl &&
            (identical(other.file, file) || other.file == file) &&
            const DeepCollectionEquality().equals(other.bytes, bytes));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    file,
    const DeepCollectionEquality().hash(bytes),
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FileViewerLoadedImplCopyWith<_$FileViewerLoadedImpl> get copyWith =>
      __$$FileViewerLoadedImplCopyWithImpl<_$FileViewerLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(SecureFileEntity file, Uint8List bytes) loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(file, bytes);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(SecureFileEntity file, Uint8List bytes)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(file, bytes);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(SecureFileEntity file, Uint8List bytes)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(file, bytes);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FileViewerInitial value) initial,
    required TResult Function(FileViewerLoading value) loading,
    required TResult Function(FileViewerLoaded value) loaded,
    required TResult Function(FileViewerError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileViewerInitial value)? initial,
    TResult? Function(FileViewerLoading value)? loading,
    TResult? Function(FileViewerLoaded value)? loaded,
    TResult? Function(FileViewerError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileViewerInitial value)? initial,
    TResult Function(FileViewerLoading value)? loading,
    TResult Function(FileViewerLoaded value)? loaded,
    TResult Function(FileViewerError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class FileViewerLoaded implements FileViewerState {
  const factory FileViewerLoaded({
    required final SecureFileEntity file,
    required final Uint8List bytes,
  }) = _$FileViewerLoadedImpl;

  SecureFileEntity get file;
  Uint8List get bytes;
  @JsonKey(ignore: true)
  _$$FileViewerLoadedImplCopyWith<_$FileViewerLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FileViewerErrorImplCopyWith<$Res> {
  factory _$$FileViewerErrorImplCopyWith(
    _$FileViewerErrorImpl value,
    $Res Function(_$FileViewerErrorImpl) then,
  ) = __$$FileViewerErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$FileViewerErrorImplCopyWithImpl<$Res>
    extends _$FileViewerStateCopyWithImpl<$Res, _$FileViewerErrorImpl>
    implements _$$FileViewerErrorImplCopyWith<$Res> {
  __$$FileViewerErrorImplCopyWithImpl(
    _$FileViewerErrorImpl _value,
    $Res Function(_$FileViewerErrorImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$FileViewerErrorImpl(
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc

class _$FileViewerErrorImpl implements FileViewerError {
  const _$FileViewerErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'FileViewerState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileViewerErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FileViewerErrorImplCopyWith<_$FileViewerErrorImpl> get copyWith =>
      __$$FileViewerErrorImplCopyWithImpl<_$FileViewerErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(SecureFileEntity file, Uint8List bytes) loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(SecureFileEntity file, Uint8List bytes)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(SecureFileEntity file, Uint8List bytes)? loaded,
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
    required TResult Function(FileViewerInitial value) initial,
    required TResult Function(FileViewerLoading value) loading,
    required TResult Function(FileViewerLoaded value) loaded,
    required TResult Function(FileViewerError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileViewerInitial value)? initial,
    TResult? Function(FileViewerLoading value)? loading,
    TResult? Function(FileViewerLoaded value)? loaded,
    TResult? Function(FileViewerError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileViewerInitial value)? initial,
    TResult Function(FileViewerLoading value)? loading,
    TResult Function(FileViewerLoaded value)? loaded,
    TResult Function(FileViewerError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class FileViewerError implements FileViewerState {
  const factory FileViewerError({required final String message}) =
      _$FileViewerErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$FileViewerErrorImplCopyWith<_$FileViewerErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
