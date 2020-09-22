class ShopEvent {}

class GoToDetailEvent extends ShopEvent {
  int id;

  GoToDetailEvent(this.id);
}

class LoadingDataEvent extends ShopEvent {}
class UpdateDataEvent extends ShopEvent {
  int id;

  UpdateDataEvent(this.id);
}

class UpdateAnimationEvent extends ShopEvent {
  bool showAnimation;

  UpdateAnimationEvent(this.showAnimation);
}
