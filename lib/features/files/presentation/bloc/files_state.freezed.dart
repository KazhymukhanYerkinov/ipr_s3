// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'files_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FilesState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<SecureFileEntity> files, ViewMode viewMode, String searchQuery)
        loaded,
    required TResult Function(String fileName) importing,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SecureFileEntity> files, ViewMode viewMode,
            String searchQuery)?
        loaded,
    TResult? Function(String fileName)? importing,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SecureFileEntity> files, ViewMode viewMode,
            String searchQuery)?
        loaded,
    TResult Function(String fileName)? importing,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FilesInitial value) initial,
    required TResult Function(FilesLoading value) loading,
    required TResult Function(FilesLoaded value) loaded,
    required TResult Function(FilesImporting value) importing,
    required TResult Function(FilesError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FilesInitial value)? initial,
    TResult? Function(FilesLoading value)? loading,
    TResult? Function(FilesLoaded value)? loaded,
    TResult? Function(FilesImporting value)? importing,
    TResult? Function(FilesError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FilesInitial value)? initial,
    TResult Function(FilesLoading value)? loading,
    TResult Function(FilesLoaded value)? loaded,
    TResult Function(FilesImporting value)? importing,
    TResult Function(FilesError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilesStateCopyWith<$Res> {
  factory $FilesStateCopyWith(
          FilesState value, $Res Function(FilesState) then) =
      _$FilesStateCopyWithImpl<$Res, FilesState>;
}

/// @nodoc
class _$FilesStateCopyWithImpl<$Res, $Val extends FilesState>
    implements $FilesStateCopyWith<$Res> {
  _$FilesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$FilesInitialImplCopyWith<$Res> {
  factory _$$FilesInitialImplCopyWith(
          _$FilesInitialImpl value, $Res Function(_$FilesInitialImpl) then) =
      __$$FilesInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FilesInitialImplCopyWithImpl<$Res>
    extends _$FilesStateCopyWithImpl<$Res, _$FilesInitialImpl>
    implements _$$FilesInitialImplCopyWith<$Res> {
  __$$FilesInitialImplCopyWithImpl(
      _$FilesInitialImpl _value, $Res Function(_$FilesInitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$FilesInitialImpl implements FilesInitial {
  const _$FilesInitialImpl();

  @override
  String toString() {
    return 'FilesState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FilesInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<SecureFileEntity> files, ViewMode viewMode, String searchQuery)
        loaded,
    required TResult Function(String fileName) importing,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SecureFileEntity> files, ViewMode viewMode,
            String searchQuery)?
        loaded,
    TResult? Function(String fileName)? importing,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SecureFileEntity> files, ViewMode viewMode,
            String searchQuery)?
        loaded,
    TResult Function(String fileName)? importing,
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
    required TResult Function(FilesInitial value) initial,
    required TResult Function(FilesLoading value) loading,
    required TResult Function(FilesLoaded value) loaded,
    required TResult Function(FilesImporting value) importing,
    required TResult Function(FilesError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FilesInitial value)? initial,
    TResult? Function(FilesLoading value)? loading,
    TResult? Function(FilesLoaded value)? loaded,
    TResult? Function(FilesImporting value)? importing,
    TResult? Function(FilesError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FilesInitial value)? initial,
    TResult Function(FilesLoading value)? loading,
    TResult Function(FilesLoaded value)? loaded,
    TResult Function(FilesImporting value)? importing,
    TResult Function(FilesError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class FilesInitial implements FilesState {
  const factory FilesInitial() = _$FilesInitialImpl;
}

/// @nodoc
abstract class _$$FilesLoadingImplCopyWith<$Res> {
  factory _$$FilesLoadingImplCopyWith(
          _$FilesLoadingImpl value, $Res Function(_$FilesLoadingImpl) then) =
      __$$FilesLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FilesLoadingImplCopyWithImpl<$Res>
    extends _$FilesStateCopyWithImpl<$Res, _$FilesLoadingImpl>
    implements _$$FilesLoadingImplCopyWith<$Res> {
  __$$FilesLoadingImplCopyWithImpl(
      _$FilesLoadingImpl _value, $Res Function(_$FilesLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$FilesLoadingImpl implements FilesLoading {
  const _$FilesLoadingImpl();

  @override
  String toString() {
    return 'FilesState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FilesLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<SecureFileEntity> files, ViewMode viewMode, String searchQuery)
        loaded,
    required TResult Function(String fileName) importing,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SecureFileEntity> files, ViewMode viewMode,
            String searchQuery)?
        loaded,
    TResult? Function(String fileName)? importing,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SecureFileEntity> files, ViewMode viewMode,
            String searchQuery)?
        loaded,
    TResult Function(String fileName)? importing,
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
    required TResult Function(FilesInitial value) initial,
    required TResult Function(FilesLoading value) loading,
    required TResult Function(FilesLoaded value) loaded,
    required TResult Function(FilesImporting value) importing,
    required TResult Function(FilesError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FilesInitial value)? initial,
    TResult? Function(FilesLoading value)? loading,
    TResult? Function(FilesLoaded value)? loaded,
    TResult? Function(FilesImporting value)? importing,
    TResult? Function(FilesError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FilesInitial value)? initial,
    TResult Function(FilesLoading value)? loading,
    TResult Function(FilesLoaded value)? loaded,
    TResult Function(FilesImporting value)? importing,
    TResult Function(FilesError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class FilesLoading implements FilesState {
  const factory FilesLoading() = _$FilesLoadingImpl;
}

/// @nodoc
abstract class _$$FilesLoadedImplCopyWith<$Res> {
  factory _$$FilesLoadedImplCopyWith(
          _$FilesLoadedImpl value, $Res Function(_$FilesLoadedImpl) then) =
      __$$FilesLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<SecureFileEntity> files, ViewMode viewMode, String searchQuery});
}

/// @nodoc
class __$$FilesLoadedImplCopyWithImpl<$Res>
    extends _$FilesStateCopyWithImpl<$Res, _$FilesLoadedImpl>
    implements _$$FilesLoadedImplCopyWith<$Res> {
  __$$FilesLoadedImplCopyWithImpl(
      _$FilesLoadedImpl _value, $Res Function(_$FilesLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? files = null,
    Object? viewMode = null,
    Object? searchQuery = null,
  }) {
    return _then(_$FilesLoadedImpl(
      files: null == files
          ? _value._files
          : files // ignore: cast_nullable_to_non_nullable
              as List<SecureFileEntity>,
      viewMode: null == viewMode
          ? _value.viewMode
          : viewMode // ignore: cast_nullable_to_non_nullable
              as ViewMode,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FilesLoadedImpl implements FilesLoaded {
  const _$FilesLoadedImpl(
      {required final List<SecureFileEntity> files,
      this.viewMode = ViewMode.list,
      this.searchQuery = ''})
      : _files = files;

  final List<SecureFileEntity> _files;
  @override
  List<SecureFileEntity> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  @JsonKey()
  final ViewMode viewMode;
  @override
  @JsonKey()
  final String searchQuery;

  @override
  String toString() {
    return 'FilesState.loaded(files: $files, viewMode: $viewMode, searchQuery: $searchQuery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilesLoadedImpl &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            (identical(other.viewMode, viewMode) ||
                other.viewMode == viewMode) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_files), viewMode, searchQuery);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FilesLoadedImplCopyWith<_$FilesLoadedImpl> get copyWith =>
      __$$FilesLoadedImplCopyWithImpl<_$FilesLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<SecureFileEntity> files, ViewMode viewMode, String searchQuery)
        loaded,
    required TResult Function(String fileName) importing,
    required TResult Function(String message) error,
  }) {
    return loaded(files, viewMode, searchQuery);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SecureFileEntity> files, ViewMode viewMode,
            String searchQuery)?
        loaded,
    TResult? Function(String fileName)? importing,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(files, viewMode, searchQuery);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SecureFileEntity> files, ViewMode viewMode,
            String searchQuery)?
        loaded,
    TResult Function(String fileName)? importing,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(files, viewMode, searchQuery);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FilesInitial value) initial,
    required TResult Function(FilesLoading value) loading,
    required TResult Function(FilesLoaded value) loaded,
    required TResult Function(FilesImporting value) importing,
    required TResult Function(FilesError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FilesInitial value)? initial,
    TResult? Function(FilesLoading value)? loading,
    TResult? Function(FilesLoaded value)? loaded,
    TResult? Function(FilesImporting value)? importing,
    TResult? Function(FilesError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FilesInitial value)? initial,
    TResult Function(FilesLoading value)? loading,
    TResult Function(FilesLoaded value)? loaded,
    TResult Function(FilesImporting value)? importing,
    TResult Function(FilesError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class FilesLoaded implements FilesState {
  const factory FilesLoaded(
      {required final List<SecureFileEntity> files,
      final ViewMode viewMode,
      final String searchQuery}) = _$FilesLoadedImpl;

  List<SecureFileEntity> get files;
  ViewMode get viewMode;
  String get searchQuery;
  @JsonKey(ignore: true)
  _$$FilesLoadedImplCopyWith<_$FilesLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FilesImportingImplCopyWith<$Res> {
  factory _$$FilesImportingImplCopyWith(_$FilesImportingImpl value,
          $Res Function(_$FilesImportingImpl) then) =
      __$$FilesImportingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String fileName});
}

/// @nodoc
class __$$FilesImportingImplCopyWithImpl<$Res>
    extends _$FilesStateCopyWithImpl<$Res, _$FilesImportingImpl>
    implements _$$FilesImportingImplCopyWith<$Res> {
  __$$FilesImportingImplCopyWithImpl(
      _$FilesImportingImpl _value, $Res Function(_$FilesImportingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = null,
  }) {
    return _then(_$FilesImportingImpl(
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FilesImportingImpl implements FilesImporting {
  const _$FilesImportingImpl({required this.fileName});

  @override
  final String fileName;

  @override
  String toString() {
    return 'FilesState.importing(fileName: $fileName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilesImportingImpl &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fileName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FilesImportingImplCopyWith<_$FilesImportingImpl> get copyWith =>
      __$$FilesImportingImplCopyWithImpl<_$FilesImportingImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<SecureFileEntity> files, ViewMode viewMode, String searchQuery)
        loaded,
    required TResult Function(String fileName) importing,
    required TResult Function(String message) error,
  }) {
    return importing(fileName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SecureFileEntity> files, ViewMode viewMode,
            String searchQuery)?
        loaded,
    TResult? Function(String fileName)? importing,
    TResult? Function(String message)? error,
  }) {
    return importing?.call(fileName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SecureFileEntity> files, ViewMode viewMode,
            String searchQuery)?
        loaded,
    TResult Function(String fileName)? importing,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (importing != null) {
      return importing(fileName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FilesInitial value) initial,
    required TResult Function(FilesLoading value) loading,
    required TResult Function(FilesLoaded value) loaded,
    required TResult Function(FilesImporting value) importing,
    required TResult Function(FilesError value) error,
  }) {
    return importing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FilesInitial value)? initial,
    TResult? Function(FilesLoading value)? loading,
    TResult? Function(FilesLoaded value)? loaded,
    TResult? Function(FilesImporting value)? importing,
    TResult? Function(FilesError value)? error,
  }) {
    return importing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FilesInitial value)? initial,
    TResult Function(FilesLoading value)? loading,
    TResult Function(FilesLoaded value)? loaded,
    TResult Function(FilesImporting value)? importing,
    TResult Function(FilesError value)? error,
    required TResult orElse(),
  }) {
    if (importing != null) {
      return importing(this);
    }
    return orElse();
  }
}

abstract class FilesImporting implements FilesState {
  const factory FilesImporting({required final String fileName}) =
      _$FilesImportingImpl;

  String get fileName;
  @JsonKey(ignore: true)
  _$$FilesImportingImplCopyWith<_$FilesImportingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FilesErrorImplCopyWith<$Res> {
  factory _$$FilesErrorImplCopyWith(
          _$FilesErrorImpl value, $Res Function(_$FilesErrorImpl) then) =
      __$$FilesErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$FilesErrorImplCopyWithImpl<$Res>
    extends _$FilesStateCopyWithImpl<$Res, _$FilesErrorImpl>
    implements _$$FilesErrorImplCopyWith<$Res> {
  __$$FilesErrorImplCopyWithImpl(
      _$FilesErrorImpl _value, $Res Function(_$FilesErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$FilesErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FilesErrorImpl implements FilesError {
  const _$FilesErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'FilesState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilesErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FilesErrorImplCopyWith<_$FilesErrorImpl> get copyWith =>
      __$$FilesErrorImplCopyWithImpl<_$FilesErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<SecureFileEntity> files, ViewMode viewMode, String searchQuery)
        loaded,
    required TResult Function(String fileName) importing,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SecureFileEntity> files, ViewMode viewMode,
            String searchQuery)?
        loaded,
    TResult? Function(String fileName)? importing,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SecureFileEntity> files, ViewMode viewMode,
            String searchQuery)?
        loaded,
    TResult Function(String fileName)? importing,
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
    required TResult Function(FilesInitial value) initial,
    required TResult Function(FilesLoading value) loading,
    required TResult Function(FilesLoaded value) loaded,
    required TResult Function(FilesImporting value) importing,
    required TResult Function(FilesError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FilesInitial value)? initial,
    TResult? Function(FilesLoading value)? loading,
    TResult? Function(FilesLoaded value)? loaded,
    TResult? Function(FilesImporting value)? importing,
    TResult? Function(FilesError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FilesInitial value)? initial,
    TResult Function(FilesLoading value)? loading,
    TResult Function(FilesLoaded value)? loaded,
    TResult Function(FilesImporting value)? importing,
    TResult Function(FilesError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class FilesError implements FilesState {
  const factory FilesError({required final String message}) = _$FilesErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$FilesErrorImplCopyWith<_$FilesErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
