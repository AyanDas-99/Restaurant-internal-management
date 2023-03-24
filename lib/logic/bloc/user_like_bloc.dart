import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_management/data/provider/user_provider.dart';

part 'user_like_event.dart';
part 'user_like_state.dart';

class UserLikeBloc extends Bloc<UserLikeEvent, UserLikeState> {
  FirestoreUser _firestoreUser = FirestoreUser();
  UserLikeBloc() : super(UserLikes([])) {
    on<GetLikes>((event, emit) async {
      emit(UserLikesLoading());
      try {
        var likes = await _firestoreUser.getLikedItems(event.email);
        emit(UserLikes(likes));
      } catch (e) {
        emit(UserLikesError());
        print(e);
      }
    });

    on<LikeItem>((event, emit) async {
      emit(LikingItem());
      try {
        _firestoreUser.likeItem(event.email, event.item_name);
        emit(LikedItem());
        var likes = await _firestoreUser.getLikedItems(event.email);
        emit((UserLikes(likes)));
      } catch (e) {
        emit(LikingItemError(e.toString()));
      }
    });

    on<RemoveItemLike>((event, emit) async {
      emit(LikingItem());
      try {
        _firestoreUser.removeLikeFromItem(event.email, event.item_name);
        var likes = await _firestoreUser.getLikedItems(event.email);
        emit(UserLikes(likes));
      } catch (e) {
        emit(LikingItemError(e.toString()));
      }
    });
  }
}
