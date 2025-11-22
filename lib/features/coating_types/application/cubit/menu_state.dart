import 'package:equatable/equatable.dart';

class MenuState extends Equatable {
  const MenuState({this.isOpen = false});

  final bool isOpen;

  MenuState copyWith({bool? isOpen}) {
    return MenuState(
      isOpen: isOpen ?? this.isOpen,
    );
  }

  @override
  List<Object?> get props => [isOpen];
}
