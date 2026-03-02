// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'folders_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FoldersState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<FolderItem> folders) loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<FolderItem> folders)? loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<FolderItem> folders)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FoldersInitial value) initial,
    required TResult Function(FoldersLoading value) loading,
    required TResult Function(FoldersLoaded value) loaded,
    required TResult Function(FoldersError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FoldersInitial value)? initial,
    TResult? Function(FoldersLoading value)? loading,
    TResult? Function(FoldersLoaded value)? loaded,
    TResult? Function(FoldersError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FoldersInitial value)? initial,
    TResult Function(FoldersLoading value)? loading,
    TResult Function(FoldersLoaded value)? loaded,
    TResult Function(FoldersError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoldersStateCopyWith<$Res> {
  factory $FoldersStateCopyWith(
    FoldersState value,
    $Res Function(FoldersState) then,
  ) = _$FoldersStateCopyWithImpl<$Res, FoldersState>;
}

/// @nodoc
class _$FoldersStateCopyWithImpl<$Res, $Val extends FoldersState>
    implements $FoldersStateCopyWith<$Res> {
  _$FoldersStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$FoldersInitialImplCopyWith<$Res> {
  factory _$$FoldersInitialImplCopyWith(
    _$FoldersInitialImpl value,
    $Res Function(_$FoldersInitialImpl) then,
  ) = __$$FoldersInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FoldersInitialImplCopyWithImpl<$Res>
    extends _$FoldersStateCopyWithImpl<$Res, _$FoldersInitialImpl>
    implements _$$FoldersInitialImplCopyWith<$Res> {
  __$$FoldersInitialImplCopyWithImpl(
    _$FoldersInitialImpl _value,
    $Res Function(_$FoldersInitialImpl) _then,
  ) : super(_value, _then);
}

/// @nodoc

class _$FoldersInitialImpl implements FoldersInitial {
  const _$FoldersInitialImpl();

  @override
  String toString() {
    return 'FoldersState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FoldersInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<FolderItem> folders) loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<FolderItem> folders)? loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<FolderItem> folders)? loaded,
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
    required TResult Function(FoldersInitial value) initial,
    required TResult Function(FoldersLoading value) loading,
    required TResult Function(FoldersLoaded value) loaded,
    required TResult Function(FoldersError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FoldersInitial value)? initial,
    TResult? Function(FoldersLoading value)? loading,
    TResult? Function(FoldersLoaded value)? loaded,
    TResult? Function(FoldersError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FoldersInitial value)? initial,
    TResult Function(FoldersLoading value)? loading,
    TResult Function(FoldersLoaded value)? loaded,
    TResult Function(FoldersError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class FoldersInitial implements FoldersState {
  const factory FoldersInitial() = _$FoldersInitialImpl;
}

/// @nodoc
abstract class _$$FoldersLoadingImplCopyWith<$Res> {
  factory _$$FoldersLoadingImplCopyWith(
    _$FoldersLoadingImpl value,
    $Res Function(_$FoldersLoadingImpl) then,
  ) = __$$FoldersLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FoldersLoadingImplCopyWithImpl<$Res>
    extends _$FoldersStateCopyWithImpl<$Res, _$FoldersLoadingImpl>
    implements _$$FoldersLoadingImplCopyWith<$Res> {
  __$$FoldersLoadingImplCopyWithImpl(
    _$FoldersLoadingImpl _value,
    $Res Function(_$FoldersLoadingImpl) _then,
  ) : super(_value, _then);
}

/// @nodoc

class _$FoldersLoadingImpl implements FoldersLoading {
  const _$FoldersLoadingImpl();

  @override
  String toString() {
    return 'FoldersState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FoldersLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<FolderItem> folders) loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<FolderItem> folders)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<FolderItem> folders)? loaded,
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
    required TResult Function(FoldersInitial value) initial,
    required TResult Function(FoldersLoading value) loading,
    required TResult Function(FoldersLoaded value) loaded,
    required TResult Function(FoldersError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FoldersInitial value)? initial,
    TResult? Function(FoldersLoading value)? loading,
    TResult? Function(FoldersLoaded value)? loaded,
    TResult? Function(FoldersError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FoldersInitial value)? initial,
    TResult Function(FoldersLoading value)? loading,
    TResult Function(FoldersLoaded value)? loaded,
    TResult Function(FoldersError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class FoldersLoading implements FoldersState {
  const factory FoldersLoading() = _$FoldersLoadingImpl;
}

/// @nodoc
abstract class _$$FoldersLoadedImplCopyWith<$Res> {
  factory _$$FoldersLoadedImplCopyWith(
    _$FoldersLoadedImpl value,
    $Res Function(_$FoldersLoadedImpl) then,
  ) = __$$FoldersLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<FolderItem> folders});
}

/// @nodoc
class __$$FoldersLoadedImplCopyWithImpl<$Res>
    extends _$FoldersStateCopyWithImpl<$Res, _$FoldersLoadedImpl>
    implements _$$FoldersLoadedImplCopyWith<$Res> {
  __$$FoldersLoadedImplCopyWithImpl(
    _$FoldersLoadedImpl _value,
    $Res Function(_$FoldersLoadedImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? folders = null}) {
    return _then(
      _$FoldersLoadedImpl(
        folders:
            null == folders
                ? _value._folders
                : folders // ignore: cast_nullable_to_non_nullable
                    as List<FolderItem>,
      ),
    );
  }
}

/// @nodoc

class _$FoldersLoadedImpl implements FoldersLoaded {
  const _$FoldersLoadedImpl({required final List<FolderItem> folders})
    : _folders = folders;

  final List<FolderItem> _folders;
  @override
  List<FolderItem> get folders {
    if (_folders is EqualUnmodifiableListView) return _folders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_folders);
  }

  @override
  String toString() {
    return 'FoldersState.loaded(folders: $folders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoldersLoadedImpl &&
            const DeepCollectionEquality().equals(other._folders, _folders));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_folders));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FoldersLoadedImplCopyWith<_$FoldersLoadedImpl> get copyWith =>
      __$$FoldersLoadedImplCopyWithImpl<_$FoldersLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<FolderItem> folders) loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(folders);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<FolderItem> folders)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(folders);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<FolderItem> folders)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(folders);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FoldersInitial value) initial,
    required TResult Function(FoldersLoading value) loading,
    required TResult Function(FoldersLoaded value) loaded,
    required TResult Function(FoldersError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FoldersInitial value)? initial,
    TResult? Function(FoldersLoading value)? loading,
    TResult? Function(FoldersLoaded value)? loaded,
    TResult? Function(FoldersError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FoldersInitial value)? initial,
    TResult Function(FoldersLoading value)? loading,
    TResult Function(FoldersLoaded value)? loaded,
    TResult Function(FoldersError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class FoldersLoaded implements FoldersState {
  const factory FoldersLoaded({required final List<FolderItem> folders}) =
      _$FoldersLoadedImpl;

  List<FolderItem> get folders;
  @JsonKey(ignore: true)
  _$$FoldersLoadedImplCopyWith<_$FoldersLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FoldersErrorImplCopyWith<$Res> {
  factory _$$FoldersErrorImplCopyWith(
    _$FoldersErrorImpl value,
    $Res Function(_$FoldersErrorImpl) then,
  ) = __$$FoldersErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$FoldersErrorImplCopyWithImpl<$Res>
    extends _$FoldersStateCopyWithImpl<$Res, _$FoldersErrorImpl>
    implements _$$FoldersErrorImplCopyWith<$Res> {
  __$$FoldersErrorImplCopyWithImpl(
    _$FoldersErrorImpl _value,
    $Res Function(_$FoldersErrorImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$FoldersErrorImpl(
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

class _$FoldersErrorImpl implements FoldersError {
  const _$FoldersErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'FoldersState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoldersErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FoldersErrorImplCopyWith<_$FoldersErrorImpl> get copyWith =>
      __$$FoldersErrorImplCopyWithImpl<_$FoldersErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<FolderItem> folders) loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<FolderItem> folders)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<FolderItem> folders)? loaded,
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
    required TResult Function(FoldersInitial value) initial,
    required TResult Function(FoldersLoading value) loading,
    required TResult Function(FoldersLoaded value) loaded,
    required TResult Function(FoldersError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FoldersInitial value)? initial,
    TResult? Function(FoldersLoading value)? loading,
    TResult? Function(FoldersLoaded value)? loaded,
    TResult? Function(FoldersError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FoldersInitial value)? initial,
    TResult Function(FoldersLoading value)? loading,
    TResult Function(FoldersLoaded value)? loaded,
    TResult Function(FoldersError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class FoldersError implements FoldersState {
  const factory FoldersError({required final String message}) =
      _$FoldersErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$FoldersErrorImplCopyWith<_$FoldersErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
