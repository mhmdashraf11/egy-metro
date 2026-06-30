part of 'favorite_cubit.dart';

sealed class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

final class FavoriteInitial extends FavoriteState {}

final class FavoriteLoaded extends FavoriteState {
  final List<FavoriteRouteEntity> favorites;
  const FavoriteLoaded(this.favorites);

  @override
  List<Object> get props => [favorites];
}

final class FavoriteItemLoaded extends FavoriteState {
  final FavoriteRouteEntity favorite;
  const FavoriteItemLoaded(this.favorite);

  @override
  List<Object> get props => [favorite];
}

final class FavoriteError extends FavoriteState {
  final String message;
  const FavoriteError(this.message);

  @override
  List<Object> get props => [message];
}

final class FavoriteDeleted extends FavoriteState {
  final String message;
  const FavoriteDeleted(this.message);

  @override
  List<Object> get props => [message];
}

final class FavoriteCleared extends FavoriteState {
  final String message;
  const FavoriteCleared(this.message);

  @override
  List<Object> get props => [message];
}

final class FavoriteAdded extends FavoriteState {
  final String message;
  const FavoriteAdded(this.message);

  @override
  List<Object> get props => [message];
}

final class FavoriteNotFoun extends FavoriteState {
  final String message;
  const FavoriteNotFoun(this.message);

  @override
  List<Object> get props => [message];
}

final class FavoriteEmpty extends FavoriteState {
  final String message;
  const FavoriteEmpty(this.message);

  @override
  List<Object> get props => [message];
}

final class FavoriteFiltered extends FavoriteState {
  final List<FavoriteRouteEntity> favorites;
  const FavoriteFiltered(this.favorites);

  @override
  List<Object> get props => [favorites];
}
