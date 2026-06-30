import 'package:bloc/bloc.dart';
import 'package:egy_metro/features/favorites/data/models/favorite_route_entity.dart';
import 'package:egy_metro/features/favorites/data/repositories/favorites_repository.dart';
import 'package:equatable/equatable.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoritesRepository favoritesRepository;
  FavoriteCubit({required this.favoritesRepository}) : super(FavoriteInitial());

  Future<void> getAllFavoriteRoutes() async {
    try {
      final favorites = await favoritesRepository.getAllFavoriteRoutes();
      emit(FavoriteLoaded(favorites));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> addFavoriteRoute(FavoriteRouteEntity favoriteRouteEntity) async {
    try {
      await favoritesRepository.addFavoriteRoute(favoriteRouteEntity);
      emit(FavoriteAdded('Favorite route added successfully'));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> deleteFavoriteRoute(
    FavoriteRouteEntity favoriteRouteEntity,
  ) async {
    try {
      await favoritesRepository.deleteFavoriteRoute(favoriteRouteEntity);
      emit(FavoriteDeleted('Favorite route deleted successfully'));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> getFavoriteRouteByRoute(int fromId, int toId) async {
    try {
      final favorite = await favoritesRepository.getFavoriteRouteByRoute(
        fromId,
        toId,
      );
      if (favorite != null) {
        emit(FavoriteItemLoaded(favorite));
      } else {
        emit(FavoriteNotFoun('Favorite route not found'));
      }
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> deleteFavoriteRouteById(int id) async {
    try {
      await favoritesRepository.deleteFavoriteRouteById(id);
      emit(FavoriteDeleted('Favorite route deleted successfully'));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> deleteAllFavoriteRoutes() async {
    try {
      await favoritesRepository.deleteAllFavoriteRoutes();
      emit(FavoriteCleared('Favorite routes cleared successfully'));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  // Future<void> filterFavoriteRoutes(String query) async {
  //   try {
  //     final favorites = await favoritesRepository.getAllFavoriteRoutes();
  //     final filteredFavorites = favorites.where((favorite) {
  //       return favorite.from.name.toLowerCase().contains(query.toLowerCase()) ||
  //           favorite.to.name.toLowerCase().contains(query.toLowerCase());
  //     }).toList();
  //     emit(FavoriteFiltered(filteredFavorites));
  //   } catch (e) {
  //     emit(FavoriteError(e.toString()));
  //   }
  // }
}
