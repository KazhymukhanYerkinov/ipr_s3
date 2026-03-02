// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'benchmark_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BenchmarkState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(
            String currentTask, int completedSteps, int totalSteps)
        running,
    required TResult Function(List<BenchmarkResult> results) completed,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String currentTask, int completedSteps, int totalSteps)?
        running,
    TResult? Function(List<BenchmarkResult> results)? completed,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String currentTask, int completedSteps, int totalSteps)?
        running,
    TResult Function(List<BenchmarkResult> results)? completed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BenchmarkInitial value) initial,
    required TResult Function(BenchmarkRunning value) running,
    required TResult Function(BenchmarkCompleted value) completed,
    required TResult Function(BenchmarkError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BenchmarkInitial value)? initial,
    TResult? Function(BenchmarkRunning value)? running,
    TResult? Function(BenchmarkCompleted value)? completed,
    TResult? Function(BenchmarkError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BenchmarkInitial value)? initial,
    TResult Function(BenchmarkRunning value)? running,
    TResult Function(BenchmarkCompleted value)? completed,
    TResult Function(BenchmarkError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BenchmarkStateCopyWith<$Res> {
  factory $BenchmarkStateCopyWith(
          BenchmarkState value, $Res Function(BenchmarkState) then) =
      _$BenchmarkStateCopyWithImpl<$Res, BenchmarkState>;
}

/// @nodoc
class _$BenchmarkStateCopyWithImpl<$Res, $Val extends BenchmarkState>
    implements $BenchmarkStateCopyWith<$Res> {
  _$BenchmarkStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$BenchmarkInitialImplCopyWith<$Res> {
  factory _$$BenchmarkInitialImplCopyWith(_$BenchmarkInitialImpl value,
          $Res Function(_$BenchmarkInitialImpl) then) =
      __$$BenchmarkInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BenchmarkInitialImplCopyWithImpl<$Res>
    extends _$BenchmarkStateCopyWithImpl<$Res, _$BenchmarkInitialImpl>
    implements _$$BenchmarkInitialImplCopyWith<$Res> {
  __$$BenchmarkInitialImplCopyWithImpl(_$BenchmarkInitialImpl _value,
      $Res Function(_$BenchmarkInitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$BenchmarkInitialImpl implements BenchmarkInitial {
  const _$BenchmarkInitialImpl();

  @override
  String toString() {
    return 'BenchmarkState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$BenchmarkInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(
            String currentTask, int completedSteps, int totalSteps)
        running,
    required TResult Function(List<BenchmarkResult> results) completed,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String currentTask, int completedSteps, int totalSteps)?
        running,
    TResult? Function(List<BenchmarkResult> results)? completed,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String currentTask, int completedSteps, int totalSteps)?
        running,
    TResult Function(List<BenchmarkResult> results)? completed,
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
    required TResult Function(BenchmarkInitial value) initial,
    required TResult Function(BenchmarkRunning value) running,
    required TResult Function(BenchmarkCompleted value) completed,
    required TResult Function(BenchmarkError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BenchmarkInitial value)? initial,
    TResult? Function(BenchmarkRunning value)? running,
    TResult? Function(BenchmarkCompleted value)? completed,
    TResult? Function(BenchmarkError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BenchmarkInitial value)? initial,
    TResult Function(BenchmarkRunning value)? running,
    TResult Function(BenchmarkCompleted value)? completed,
    TResult Function(BenchmarkError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class BenchmarkInitial implements BenchmarkState {
  const factory BenchmarkInitial() = _$BenchmarkInitialImpl;
}

/// @nodoc
abstract class _$$BenchmarkRunningImplCopyWith<$Res> {
  factory _$$BenchmarkRunningImplCopyWith(_$BenchmarkRunningImpl value,
          $Res Function(_$BenchmarkRunningImpl) then) =
      __$$BenchmarkRunningImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String currentTask, int completedSteps, int totalSteps});
}

/// @nodoc
class __$$BenchmarkRunningImplCopyWithImpl<$Res>
    extends _$BenchmarkStateCopyWithImpl<$Res, _$BenchmarkRunningImpl>
    implements _$$BenchmarkRunningImplCopyWith<$Res> {
  __$$BenchmarkRunningImplCopyWithImpl(_$BenchmarkRunningImpl _value,
      $Res Function(_$BenchmarkRunningImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentTask = null,
    Object? completedSteps = null,
    Object? totalSteps = null,
  }) {
    return _then(_$BenchmarkRunningImpl(
      currentTask: null == currentTask
          ? _value.currentTask
          : currentTask // ignore: cast_nullable_to_non_nullable
              as String,
      completedSteps: null == completedSteps
          ? _value.completedSteps
          : completedSteps // ignore: cast_nullable_to_non_nullable
              as int,
      totalSteps: null == totalSteps
          ? _value.totalSteps
          : totalSteps // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$BenchmarkRunningImpl implements BenchmarkRunning {
  const _$BenchmarkRunningImpl(
      {required this.currentTask,
      required this.completedSteps,
      required this.totalSteps});

  @override
  final String currentTask;
  @override
  final int completedSteps;
  @override
  final int totalSteps;

  @override
  String toString() {
    return 'BenchmarkState.running(currentTask: $currentTask, completedSteps: $completedSteps, totalSteps: $totalSteps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BenchmarkRunningImpl &&
            (identical(other.currentTask, currentTask) ||
                other.currentTask == currentTask) &&
            (identical(other.completedSteps, completedSteps) ||
                other.completedSteps == completedSteps) &&
            (identical(other.totalSteps, totalSteps) ||
                other.totalSteps == totalSteps));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, currentTask, completedSteps, totalSteps);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BenchmarkRunningImplCopyWith<_$BenchmarkRunningImpl> get copyWith =>
      __$$BenchmarkRunningImplCopyWithImpl<_$BenchmarkRunningImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(
            String currentTask, int completedSteps, int totalSteps)
        running,
    required TResult Function(List<BenchmarkResult> results) completed,
    required TResult Function(String message) error,
  }) {
    return running(currentTask, completedSteps, totalSteps);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String currentTask, int completedSteps, int totalSteps)?
        running,
    TResult? Function(List<BenchmarkResult> results)? completed,
    TResult? Function(String message)? error,
  }) {
    return running?.call(currentTask, completedSteps, totalSteps);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String currentTask, int completedSteps, int totalSteps)?
        running,
    TResult Function(List<BenchmarkResult> results)? completed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (running != null) {
      return running(currentTask, completedSteps, totalSteps);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BenchmarkInitial value) initial,
    required TResult Function(BenchmarkRunning value) running,
    required TResult Function(BenchmarkCompleted value) completed,
    required TResult Function(BenchmarkError value) error,
  }) {
    return running(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BenchmarkInitial value)? initial,
    TResult? Function(BenchmarkRunning value)? running,
    TResult? Function(BenchmarkCompleted value)? completed,
    TResult? Function(BenchmarkError value)? error,
  }) {
    return running?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BenchmarkInitial value)? initial,
    TResult Function(BenchmarkRunning value)? running,
    TResult Function(BenchmarkCompleted value)? completed,
    TResult Function(BenchmarkError value)? error,
    required TResult orElse(),
  }) {
    if (running != null) {
      return running(this);
    }
    return orElse();
  }
}

abstract class BenchmarkRunning implements BenchmarkState {
  const factory BenchmarkRunning(
      {required final String currentTask,
      required final int completedSteps,
      required final int totalSteps}) = _$BenchmarkRunningImpl;

  String get currentTask;
  int get completedSteps;
  int get totalSteps;
  @JsonKey(ignore: true)
  _$$BenchmarkRunningImplCopyWith<_$BenchmarkRunningImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BenchmarkCompletedImplCopyWith<$Res> {
  factory _$$BenchmarkCompletedImplCopyWith(_$BenchmarkCompletedImpl value,
          $Res Function(_$BenchmarkCompletedImpl) then) =
      __$$BenchmarkCompletedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<BenchmarkResult> results});
}

/// @nodoc
class __$$BenchmarkCompletedImplCopyWithImpl<$Res>
    extends _$BenchmarkStateCopyWithImpl<$Res, _$BenchmarkCompletedImpl>
    implements _$$BenchmarkCompletedImplCopyWith<$Res> {
  __$$BenchmarkCompletedImplCopyWithImpl(_$BenchmarkCompletedImpl _value,
      $Res Function(_$BenchmarkCompletedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? results = null,
  }) {
    return _then(_$BenchmarkCompletedImpl(
      results: null == results
          ? _value._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<BenchmarkResult>,
    ));
  }
}

/// @nodoc

class _$BenchmarkCompletedImpl implements BenchmarkCompleted {
  const _$BenchmarkCompletedImpl({required final List<BenchmarkResult> results})
      : _results = results;

  final List<BenchmarkResult> _results;
  @override
  List<BenchmarkResult> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  String toString() {
    return 'BenchmarkState.completed(results: $results)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BenchmarkCompletedImpl &&
            const DeepCollectionEquality().equals(other._results, _results));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_results));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BenchmarkCompletedImplCopyWith<_$BenchmarkCompletedImpl> get copyWith =>
      __$$BenchmarkCompletedImplCopyWithImpl<_$BenchmarkCompletedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(
            String currentTask, int completedSteps, int totalSteps)
        running,
    required TResult Function(List<BenchmarkResult> results) completed,
    required TResult Function(String message) error,
  }) {
    return completed(results);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String currentTask, int completedSteps, int totalSteps)?
        running,
    TResult? Function(List<BenchmarkResult> results)? completed,
    TResult? Function(String message)? error,
  }) {
    return completed?.call(results);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String currentTask, int completedSteps, int totalSteps)?
        running,
    TResult Function(List<BenchmarkResult> results)? completed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(results);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BenchmarkInitial value) initial,
    required TResult Function(BenchmarkRunning value) running,
    required TResult Function(BenchmarkCompleted value) completed,
    required TResult Function(BenchmarkError value) error,
  }) {
    return completed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BenchmarkInitial value)? initial,
    TResult? Function(BenchmarkRunning value)? running,
    TResult? Function(BenchmarkCompleted value)? completed,
    TResult? Function(BenchmarkError value)? error,
  }) {
    return completed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BenchmarkInitial value)? initial,
    TResult Function(BenchmarkRunning value)? running,
    TResult Function(BenchmarkCompleted value)? completed,
    TResult Function(BenchmarkError value)? error,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(this);
    }
    return orElse();
  }
}

abstract class BenchmarkCompleted implements BenchmarkState {
  const factory BenchmarkCompleted(
          {required final List<BenchmarkResult> results}) =
      _$BenchmarkCompletedImpl;

  List<BenchmarkResult> get results;
  @JsonKey(ignore: true)
  _$$BenchmarkCompletedImplCopyWith<_$BenchmarkCompletedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BenchmarkErrorImplCopyWith<$Res> {
  factory _$$BenchmarkErrorImplCopyWith(_$BenchmarkErrorImpl value,
          $Res Function(_$BenchmarkErrorImpl) then) =
      __$$BenchmarkErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$BenchmarkErrorImplCopyWithImpl<$Res>
    extends _$BenchmarkStateCopyWithImpl<$Res, _$BenchmarkErrorImpl>
    implements _$$BenchmarkErrorImplCopyWith<$Res> {
  __$$BenchmarkErrorImplCopyWithImpl(
      _$BenchmarkErrorImpl _value, $Res Function(_$BenchmarkErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$BenchmarkErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$BenchmarkErrorImpl implements BenchmarkError {
  const _$BenchmarkErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'BenchmarkState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BenchmarkErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BenchmarkErrorImplCopyWith<_$BenchmarkErrorImpl> get copyWith =>
      __$$BenchmarkErrorImplCopyWithImpl<_$BenchmarkErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(
            String currentTask, int completedSteps, int totalSteps)
        running,
    required TResult Function(List<BenchmarkResult> results) completed,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String currentTask, int completedSteps, int totalSteps)?
        running,
    TResult? Function(List<BenchmarkResult> results)? completed,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String currentTask, int completedSteps, int totalSteps)?
        running,
    TResult Function(List<BenchmarkResult> results)? completed,
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
    required TResult Function(BenchmarkInitial value) initial,
    required TResult Function(BenchmarkRunning value) running,
    required TResult Function(BenchmarkCompleted value) completed,
    required TResult Function(BenchmarkError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BenchmarkInitial value)? initial,
    TResult? Function(BenchmarkRunning value)? running,
    TResult? Function(BenchmarkCompleted value)? completed,
    TResult? Function(BenchmarkError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BenchmarkInitial value)? initial,
    TResult Function(BenchmarkRunning value)? running,
    TResult Function(BenchmarkCompleted value)? completed,
    TResult Function(BenchmarkError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class BenchmarkError implements BenchmarkState {
  const factory BenchmarkError({required final String message}) =
      _$BenchmarkErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$BenchmarkErrorImplCopyWith<_$BenchmarkErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
