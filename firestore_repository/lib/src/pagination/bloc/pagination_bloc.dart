import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'pagination_event.dart';
part 'pagination_state.dart';

typedef Converter = T Function<T>(DocumentSnapshot snapshot);

class PaginationBloc<T> extends Bloc<PaginationEvent, PaginationState> {
  PaginationBloc(this.query, this.converter, {this.limit = 20}) : super(PaginationInitial());
  Query query;
  Converter converter;
  int limit;

  @override
  Stream<PaginationState> mapEventToState(
    PaginationEvent event,
  ) async* {
    final currentState = state;
    if (event is PaginationFetched && !_hasReachedMax(currentState)) {
      try {
        if (currentState is PaginationInitial) {
          final data = await _fetchPaginations(null, limit);
          yield PaginationSuccess(data: data, hasReachedMax: false);
          return;
        }
        if (currentState is PaginationSuccess) {
          final rawdata = await _fetchPaginations(currentState.lastSnapshot, limit);
          final last = rawdata.isNotEmpty ? rawdata.last : currentState.lastSnapshot;
          final data = rawdata.map((rawPagination) {
            return converter(rawPagination);
          }).toList();
          yield data.isEmpty
              ? currentState.copyWith(hasReachedMax: true, lastSnapshot: last)
              : PaginationSuccess(
                  data: currentState.data + data,
                  lastSnapshot: last,
                  hasReachedMax: false,
                );
        }
      } catch (_) {
        yield PaginationFailure();
      }
    }
  }

  bool _hasReachedMax(PaginationState state) => state is PaginationSuccess && state.hasReachedMax;

  Future<List<QueryDocumentSnapshot>> _fetchPaginations(DocumentSnapshot startAfter, int limit) async {
    var q = query;
    if (startAfter != null) q = q.startAfterDocument(startAfter);

    var snapshot = await q.limit(limit).get().catchError(() {
      throw Exception('error fetching data');
    });

    return snapshot.docs;
  }

  @override
  Stream<Transition<PaginationEvent, PaginationState>> transformEvents(
    Stream<PaginationEvent> events,
    TransitionFunction<PaginationEvent, PaginationState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }
}
