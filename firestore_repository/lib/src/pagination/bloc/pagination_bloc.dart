import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'pagination_event.dart';
part 'pagination_state.dart';

typedef Converter<T> = T Function(DocumentSnapshot snapshot);

class PaginationBloc<T> extends Bloc<PaginationEvent, PaginationState<T>> {
  PaginationBloc(this.query, this.converter, {this.limit = 20}) : super(PaginationInitial<T>());
  Query query;
  Converter<T> converter;
  int limit;

  @override
  Stream<PaginationState<T>> mapEventToState(
    PaginationEvent event,
  ) async* {
    final currentState = state;
    if (event is PaginationFetched && !_hasReachedMax(currentState)) {
      try {
        if (currentState is PaginationInitial<T>) {
          final rawdata = await _fetchPaginations(null, limit);
          final data = rawdata.map((rawPagination) {
            return converter(rawPagination);
          }).toList();
          yield PaginationSuccess<T>(data: data, hasReachedMax: false);
          return;
        }
        if (currentState is PaginationSuccess<T>) {
          yield* _mapPaginationSuccess(currentState);
        }
      } catch (_) {
        yield PaginationFailure();
      }
    }
  }

  Stream<PaginationSuccess<T>> _mapPaginationSuccess(PaginationSuccess<T> currentState) async* {
    final rawdata = await _fetchPaginations(currentState.lastSnapshot, limit);
    final last = rawdata.isNotEmpty ? rawdata.last : currentState.lastSnapshot;
    final data = rawdata.map((rawPagination) {
      return converter(rawPagination);
    }).toList();
    if (data.isEmpty) {
      yield currentState.copyWith(hasReachedMax: true, lastSnapshot: last);
    } else
      yield PaginationSuccess<T>(
        data: currentState.data + data,
        lastSnapshot: last,
        hasReachedMax: false,
      );
  }

  bool _hasReachedMax(PaginationState state) => state is PaginationSuccess && state.hasReachedMax;

  Future<List<QueryDocumentSnapshot>> _fetchPaginations(DocumentSnapshot startAfter, int limit) async {
    var q = query;
    if (startAfter != null) q = q.startAfterDocument(startAfter);

    var snapshot = await q.limit(limit).get();
    // .catchError(() {
    //   throw Exception('error fetching data');
    // });

    return snapshot.docs;
  }

  @override
  Stream<Transition<PaginationEvent, PaginationState<T>>> transformEvents(
    Stream<PaginationEvent> events,
    TransitionFunction<PaginationEvent, PaginationState<T>> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }
}
