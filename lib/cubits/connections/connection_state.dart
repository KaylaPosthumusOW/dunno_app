part of 'connection_cubit.dart';

class MainConnectionState extends Equatable {
  final String? message;
  final String? errorMessage;
  final List<Connection>? allUserConnections;
  final Connection? selectedConnection;
  final num? numberOfUserConnections;

  const MainConnectionState({this.message, this.errorMessage, this.allUserConnections, this.selectedConnection, this.numberOfUserConnections});

  @override
  List<Object?> get props => [message, errorMessage, allUserConnections, selectedConnection, numberOfUserConnections];

  MainConnectionState copyWith({
    String? message,
    String? errorMessage,
    List<Connection>? allUserConnections,
    Connection? selectedConnection,
    num? numberOfUserConnections,
  }) {
    return MainConnectionState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      allUserConnections: allUserConnections ?? this.allUserConnections,
      selectedConnection: selectedConnection ?? this.selectedConnection,
      numberOfUserConnections: numberOfUserConnections ?? this.numberOfUserConnections,
    );
  }

  MainConnectionState copyWithNull({
    String? message,
    String? errorMessage,
    List<Connection>? allUserConnections,
    Connection? selectedConnection,
    num? numberOfUserConnections,
  }) {
    return MainConnectionState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      allUserConnections: allUserConnections ?? this.allUserConnections,
      selectedConnection: selectedConnection,
      numberOfUserConnections: numberOfUserConnections ?? this.numberOfUserConnections,
    );
  }
}

abstract class ConnectionState extends Equatable {
  final MainConnectionState mainConnectionState;

  const ConnectionState(this.mainConnectionState);

  @override
  List<Object> get props => [mainConnectionState];
}

class ConnectionInitial extends ConnectionState {
  const ConnectionInitial() : super(const MainConnectionState());
}

class LoadingConnections extends ConnectionState {
  const LoadingConnections(super.mainConnectionState);
}

class LoadedConnections extends ConnectionState {
  const LoadedConnections(super.mainConnectionState);
}

class CreatingConnection extends ConnectionState {
  const CreatingConnection(super.mainConnectionState);
}

class CreatedConnection extends ConnectionState {
  const CreatedConnection(super.mainConnectionState);
}

class SelectedConnection extends ConnectionState {
  const SelectedConnection(super.mainConnectionState);
}

class ConnectionError extends ConnectionState {
  final String stackTrace;

  const ConnectionError(super.mainConnectionState, {required this.stackTrace});

  @override
  List<Object> get props => [mainConnectionState, stackTrace];
}