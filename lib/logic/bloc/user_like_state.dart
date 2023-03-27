part of 'user_like_bloc.dart';

abstract class UserLikeState extends Equatable {
  const UserLikeState();

  @override
  List<Object> get props => [];
}

class UserLikes extends UserLikeState {
  final List likedItems;

  UserLikes(this.likedItems);
}

class UserLikesLoading extends UserLikeState {}

class UserLikesError extends UserLikeState {}

class LikingItem extends UserLikeState {}

class LikedItem extends UserLikeState {}

class LikingItemError extends UserLikeState {
  final String message;

  LikingItemError(this.message);
}
