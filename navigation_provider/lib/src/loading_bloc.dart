import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'loading_event.dart';
part 'loading_state.dart';

class LoadingBloc extends Bloc<LoadingEvent, LoadingState> {
  LoadingBloc() : super(NotLoading());

  @override
  Stream<LoadingState> mapEventToState(
    LoadingEvent event,
  ) async* {
    if (event is StartLoadingEvent)
      yield LoadingInProgress();
    else
      yield NotLoading();
  }

  void start() {
    add(StartLoadingEvent());
  }

  void end() {
    add(EndLoadingEvent());
  }
}
