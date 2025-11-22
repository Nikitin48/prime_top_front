import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CustomTheme extends Equatable {
  final String name;
  final ThemeData data;

  const CustomTheme({
    required this.name,
    required this.data,
  });

  @override
  List<Object?> get props => [name, data];
}
