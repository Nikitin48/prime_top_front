import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/features/coating_types/application/cubit/menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit() : super(const MenuState());

  void openMenu() {
    emit(state.copyWith(isOpen: true));
  }

  void closeMenu() {
    emit(state.copyWith(isOpen: false));
  }

  void toggleMenu() {
    emit(state.copyWith(isOpen: !state.isOpen));
  }
}

