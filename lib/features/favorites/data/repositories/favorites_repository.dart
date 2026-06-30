import 'package:egy_metro/features/favorites/data/datasources/favorite_route_dao.dart';
import 'package:egy_metro/features/favorites/data/models/favorite_route_entity.dart';

class FavoritesRepository {
  final FavoriteRouteDao favoriteRouteDao;
  FavoritesRepository(this.favoriteRouteDao);

  Future<void> addFavoriteRoute(FavoriteRouteEntity favoriteRouteEntity) async {
    return await favoriteRouteDao.insertFavorite(favoriteRouteEntity);
  }

  Future<void> deleteFavoriteRoute(
    FavoriteRouteEntity favoriteRouteEntity,
  ) async {
    return await favoriteRouteDao.deleteFavorite(favoriteRouteEntity);
  }

  Future<List<FavoriteRouteEntity>> getAllFavoriteRoutes() async {
    return await favoriteRouteDao.findAll();
  }

  Future<FavoriteRouteEntity?> getFavoriteRouteByRoute(
    int fromId,
    int toId,
  ) async {
    return await favoriteRouteDao.findByRoute(fromId, toId);
  }

  Future<void> deleteFavoriteRouteById(int id) async {
    return await favoriteRouteDao.deleteById(id);
  }

  Future<void> deleteAllFavoriteRoutes() async {
    return await favoriteRouteDao.deleteAll();
  }
}
