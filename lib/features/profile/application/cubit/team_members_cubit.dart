import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/features/profile/application/cubit/team_members_state.dart';
import 'package:prime_top_front/features/profile/domain/repositories/team_repository.dart';

class TeamMembersCubit extends Cubit<TeamMembersState> {
  TeamMembersCubit(this._repository) : super(const TeamMembersState());

  final TeamRepository _repository;

  Future<void> load(String clientId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final members = await _repository.getMembers(clientId: clientId);
      emit(state.copyWith(members: members, isLoading: false, errorMessage: null));
    } on Exception catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    } catch (_) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Не удалось загрузить команду'));
    }
  }
}
