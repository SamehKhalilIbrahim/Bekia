part of 'hive_cubit.dart';

@immutable
sealed class HiveState {}

final class HiveInitial extends HiveState {}

final class HiveChangeFavoriteState extends HiveState {}

final class HiveChangeCartState extends HiveState {}
