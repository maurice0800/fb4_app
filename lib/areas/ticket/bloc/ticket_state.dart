part of 'ticket_bloc.dart';

abstract class TicketBlocState extends Equatable {
  const TicketBlocState();

  @override
  List<Object> get props => [];
}

class TicketInitialState extends TicketBlocState {}

class TicketLoadingState extends TicketBlocState {}

class TicketLoadedState extends TicketBlocState {
  final Uint8List imageBytes;

  TicketLoadedState(this.imageBytes);
}

class TicketNotFoundState extends TicketBlocState {}

class TicketSavedState extends TicketBlocState {}

class TicketDeletedState extends TicketBlocState {}
