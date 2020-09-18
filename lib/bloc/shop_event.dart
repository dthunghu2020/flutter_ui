class ShopEvent {}

class GoToDetailEvent extends ShopEvent {
  int id;

  GoToDetailEvent(this.id);
}

class LoadingDataEvent extends ShopEvent {}
