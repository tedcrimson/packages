part of 'loading_bloc.dart';

abstract class LoadingState extends Equatable {
  const LoadingState();

  @override
  List<Object> get props => [];
}

class NotLoading extends LoadingState {}

class LoadingInProgress extends LoadingState {}
