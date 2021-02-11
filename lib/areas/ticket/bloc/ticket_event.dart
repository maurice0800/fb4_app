part of 'ticket_bloc.dart';

abstract class TicketBlocEvent extends Equatable {
  const TicketBlocEvent();

  @override
  List<Object> get props => [];
}

class GetTicketEvent extends TicketBlocEvent {}

class AddNewTicketEvent extends TicketBlocEvent {
  final String filePath;

  AddNewTicketEvent(this.filePath);
}

class DeleteTicketEvent extends TicketBlocEvent {}
