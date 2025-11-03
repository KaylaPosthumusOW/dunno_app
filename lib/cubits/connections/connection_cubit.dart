import 'package:dunno/constants/constants.dart';
import 'package:dunno/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:dunno/cubits/calender_event_cubit/calender_event_cubit.dart';
import 'package:dunno/cubits/collections/collection_cubit.dart';
import 'package:dunno/models/app_user_profile.dart';
import 'package:dunno/models/calender_events.dart';
import 'package:dunno/models/collections.dart';
import 'package:dunno/models/connections.dart';
import 'package:dunno/stores/firebase/connection_firebase_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'connection_state.dart';

class ConnectionCubit extends Cubit<ConnectionState> {
  final ConnectionFirebaseRepository _connectionFirebaseRepository = sl<ConnectionFirebaseRepository>();
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();
  final CalenderEventCubit _calenderEventCubit = sl<CalenderEventCubit>();
  final CollectionCubit _collectionCubit = sl<CollectionCubit>();

  ConnectionCubit() : super(const ConnectionInitial());

  Future<void> loadAllUserConnections({required String userUid}) async {
    emit(LoadingConnections(state.mainConnectionState.copyWith(message: 'Loading connections')));
    try {
      List<Connection> connections = await _connectionFirebaseRepository.loadAllConnectionsForUser(userUid: userUid);
      emit(LoadedConnections(state.mainConnectionState.copyWith(allUserConnections: connections, numberOfUserConnections: connections.length, message: 'Loaded ${connections.length} connections')));
    } catch (error, stackTrace) {
      emit(
        ConnectionError(
          state.mainConnectionState.copyWith(message: '', errorMessage: error.toString()),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  Future<num?> countAllUserConnections({required String userUid}) async {
    emit(LoadingConnections(state.mainConnectionState.copyWith(message: 'Counting connections')));
    try {
      num? count = await _connectionFirebaseRepository.countConnectionsForUser(userUid: userUid);
      emit(LoadedConnections(state.mainConnectionState.copyWith(numberOfUserConnections: count, message: 'Counted $count connections')));
      return count;
    } catch (error, stackTrace) {
      emit(
        ConnectionError(
          state.mainConnectionState.copyWith(message: '', errorMessage: error.toString()),
          stackTrace: stackTrace.toString(),
        ),
      );
      return 0;
    }
  }

  Future<void> createNewConnection(Connection newConnection) async {
    emit(CreatingConnection(state.mainConnectionState.copyWith(message: 'Creating new connection')));
    try {
      List<Connection> connections = List.from(state.mainConnectionState.allUserConnections ?? []);
      Connection connection = await _connectionFirebaseRepository.createConnection(newConnection);
      connections.add(connection);

      List<Collections> userCollections = _collectionCubit.state.mainCollectionState.allUserCollections ?? [];
      if (userCollections.isNotEmpty) {
        for (var collection in userCollections) {
          if (collection.isDateVisible == true) {
            await _calenderEventCubit.createNewCalenderEvent(CalenderEvent(user: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile ?? AppUserProfile(), friend: _appUserProfileCubit.state.mainAppUserProfileState.selectedProfile ?? AppUserProfile(), collection: collection));
          }
        }
      }

      emit(CreatedConnection(state.mainConnectionState.copyWith(allUserConnections: connections, numberOfUserConnections: connections.length, message: 'New connection created')));
    } catch (error, stackTrace) {
      emit(
        ConnectionError(
          state.mainConnectionState.copyWith(message: '', errorMessage: error.toString()),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  void selectConnection(Connection selectedConnection) {
    emit(LoadingConnections(state.mainConnectionState.copyWith(message: 'Selecting connection')));
    emit(SelectedConnection(state.mainConnectionState.copyWith(selectedConnection: selectedConnection, message: 'Connection selected')));
  }

  void clearSelectedConnection() {
    emit(LoadingConnections(state.mainConnectionState.copyWith(message: 'Clearing selected connection')));
    emit(SelectedConnection(state.mainConnectionState.copyWithNull(selectedConnection: null, allUserConnections: state.mainConnectionState.allUserConnections, numberOfUserConnections: state.mainConnectionState.numberOfUserConnections, message: 'Selected connection cleared')));
  }

  Future<void> updateConnection(Connection updatedConnection) async {
    emit(LoadingConnections(state.mainConnectionState.copyWith(message: 'Updating connection')));
    try {
      await _connectionFirebaseRepository.updateConnection(updatedConnection);
      List<Connection> connections = List.from(state.mainConnectionState.allUserConnections ?? []);
      int index = connections.indexWhere((c) => c.uid == updatedConnection.uid);
      if (index != -1) {
        connections[index] = updatedConnection;
      }
      emit(LoadedConnections(state.mainConnectionState.copyWith(allUserConnections: connections, selectedConnection: updatedConnection, message: 'Connection updated')));
    } catch (error, stackTrace) {
      emit(
        ConnectionError(
          state.mainConnectionState.copyWith(message: '', errorMessage: error.toString()),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  bool isConnectedWith(String otherUserUid) {
    final connections = state.mainConnectionState.allUserConnections ?? [];
    final currentUserUid = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '';

    return connections.any((connection) => 
      (connection.user?.uid == currentUserUid && connection.connectedUser?.uid == otherUserUid) ||
      (connection.user?.uid == otherUserUid && connection.connectedUser?.uid == currentUserUid)
    );
  }

  Future<void> disconnectFromUser(String otherUserUid) async {
    emit(LoadingConnections(state.mainConnectionState.copyWith(message: 'Disconnecting from user')));
    try {
      final connections = state.mainConnectionState.allUserConnections ?? [];
      final currentUserUid = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '';

      final connectionToDelete = connections.firstWhere(
        (connection) => 
          (connection.user?.uid == currentUserUid && connection.connectedUser?.uid == otherUserUid) ||
          (connection.user?.uid == otherUserUid && connection.connectedUser?.uid == currentUserUid),
        orElse: () => Connection()
      );

      if (connectionToDelete.uid != null) {
        await _connectionFirebaseRepository.deleteConnection(connectionToDelete.uid!);

        await _calenderEventCubit.deleteEventsForConnection(
          userUid: currentUserUid, 
          friendUid: otherUserUid
        );

        connections.removeWhere((connection) => connection.uid == connectionToDelete.uid);
        emit(LoadedConnections(state.mainConnectionState.copyWith(
          allUserConnections: connections, 
          numberOfUserConnections: connections.length, 
          message: 'Disconnected from user and removed calendar events'
        )));
      } else {
        emit(
          ConnectionError(
            state.mainConnectionState.copyWith(message: '', errorMessage: 'No connection found to disconnect'),
            stackTrace: '',
          ),
        );
      }
    } catch (error, stackTrace) {
      emit(
        ConnectionError(
          state.mainConnectionState.copyWith(message: '', errorMessage: error.toString()),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }
}
