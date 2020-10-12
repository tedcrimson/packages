part of 'pagination_bloc.dart';

abstract class PaginationState extends Equatable {
  const PaginationState();

  @override
  List<Object> get props => [];
}

class PaginationInitial extends PaginationState {}

class PaginationFailure extends PaginationState {}

class PaginationSuccess<T> extends PaginationState {
  final List<T> data;
  final bool hasReachedMax;
  final DocumentSnapshot lastSnapshot;
  const PaginationSuccess({
    this.data,
    this.lastSnapshot,
    this.hasReachedMax,
  });

  PaginationSuccess<T> copyWith({
    List<T> data,
    bool hasReachedMax,
    DocumentSnapshot lastSnapshot,
  }) {
    return PaginationSuccess<T>(
      data: data ?? this.data,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      lastSnapshot: lastSnapshot ?? this.lastSnapshot,
    );
  }

  @override
  List<Object> get props => [data, hasReachedMax, lastSnapshot];

  @override
  String toString() => 'PaginationSuccess { data: ${data.length}, hasReachedMax: $hasReachedMax }';
}
