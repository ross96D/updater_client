import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:updater_client/utils/utils.dart';

enum StreamConnectionState {
  /// Uninitialized connection.
  none,

  /// Connected to an asynchronous computation and awaiting interaction.
  waiting,

  /// Connected to an active asynchronous computation.
  ///
  /// For example, a [Stream] that has returned at least one value, but is not
  /// yet done.
  active,

  /// Connected to a terminated Stream.
  done,
}

class ConsumableErrors<E extends Err> {
  final List<E> _errors;

  List<E> get errs => _errors;

  const ConsumableErrors(this._errors);

  E? pop() {
    if (_errors.isEmpty) {
      return null;
    }
    return _errors.removeLast();
  }

  ConsumableErrors<E> add(E error) {
    _errors.add(error);
    return ConsumableErrors(_errors);
  }

  @override
  String toString() {
    return "ConsumableErrors [ ${_errors.map((e)=> e.toString()).join(" ")} ]";
  }
}

@immutable
class ResultSummary<T extends Object, E extends Err> {
  final T? data;

  final ConsumableErrors<E> errors;

  final StreamConnectionState connectionState;

  final Object? e;

  final StackTrace? st;

  ResultSummary._(this.connectionState, this.data, ConsumableErrors<E>? errors, this.e, this.st)
      : errors = errors ?? ConsumableErrors<E>([]);

  ResultSummary.nothing() : this._(StreamConnectionState.none, null, null, null, null);

  ResultSummary.waiting() : this._(StreamConnectionState.waiting, null, null, null, null);

  ResultSummary.withError(
    StreamConnectionState state,
    Object error, [
    StackTrace stackTrace = StackTrace.empty,
  ]) : this._(state, null, null, error, stackTrace);

  ResultSummary<T, E> inState(StreamConnectionState state) =>
      ResultSummary<T, E>._(state, data, errors, e, st);

  ResultSummary<T, E> withData(StreamConnectionState state, {T? data, E? error}) {
    return ResultSummary<T, E>._(
      state,
      data ?? this.data,
      error != null ? errors.add(error) : errors,
      e,
      st,
    );
  }

  ResultSummary<T, E> withError(
    StreamConnectionState state,
    Object e, [
    StackTrace st = StackTrace.empty,
  ]) {
    return ResultSummary<T, E>._(state, data, errors, e, st);
  }

  @override
  String toString() =>
      '${objectRuntimeType(this, 'ResultSummary')}($connectionState, $data, $errors, $e, $st)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ResultSummary<T, E> &&
        other.data == data &&
        other.errors == errors &&
        other.connectionState == connectionState &&
        other.e == e &&
        other.st == st;
  }

  @override
  int get hashCode => Object.hash(data, errors, connectionState, e);
}

class StreamResultBuilder<T extends Object, E extends Err>
    extends StreamBuilderBase<Result<T, E>, ResultSummary<T, E>> {
  /// Creates a [StreamResultBuilder] connected to the specified [stream].
  const StreamResultBuilder({
    super.key,
    required super.stream,
    required this.builder,
    this.initialData,
  });

  final Widget Function(BuildContext, ResultSummary<T, E>) builder;

  final Result<T, E>? initialData;

  @override
  Widget build(BuildContext context, ResultSummary<T, E> currentSummary) {
    return builder(context, currentSummary);
  }

  @override
  ResultSummary<T, E> initial() {
    if (initialData != null) {
      return initialData!.match(
        onSuccess: (v) =>
            ResultSummary<T, E>.nothing().withData(StreamConnectionState.none, data: v),
        onError: (e) =>
            ResultSummary<T, E>.nothing().withData(StreamConnectionState.none, error: e),
      );
    }
    return ResultSummary<T, E>.nothing();
  }

  @override
  ResultSummary<T, E> afterConnected(ResultSummary<T, E> current) =>
      current.inState(StreamConnectionState.waiting);

  @override
  ResultSummary<T, E> afterData(ResultSummary<T, E> current, Result<T, E> data) {
    return data.match(
      onSuccess: (v) => current.withData(StreamConnectionState.active, data: v),
      onError: (e) => current.withData(StreamConnectionState.active, error: e),
    );
  }

  @override
  ResultSummary<T, E> afterError(
    ResultSummary<T, E> current,
    Object error,
    StackTrace stackTrace,
  ) {
    return current.withError(StreamConnectionState.active, error, stackTrace);
  }

  @override
  ResultSummary<T, E> afterDone(ResultSummary<T, E> current) =>
      current.inState(StreamConnectionState.done);

  @override
  ResultSummary<T, E> afterDisconnected(ResultSummary<T, E> current) =>
      current.inState(StreamConnectionState.none);
}
