part of 'user_like_bloc.dart';

abstract class UserLikeEvent extends Equatable {
  const UserLikeEvent();

  @override
  List<Object> get props => [];
}

class GetLikes extends UserLikeEvent {
  final String email;

  GetLikes(this.email);
}

class LikeItem extends UserLikeEvent {
  final String email;
  final String item_name;

  LikeItem(this.item_name, this.email);
}

class RemoveItemLike extends UserLikeEvent {
  final String email;
  final String item_name;

  RemoveItemLike(this.item_name, this.email);
}
