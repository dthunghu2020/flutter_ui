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

class OpenDetailAnimationEvent extends ShopEvent {
int id;

  OpenDetailAnimationEvent(this.id);
}

class CloseDetailAnimationEvent extends ShopEvent {


  CloseDetailAnimationEvent();
}

class EditingDetailNameEvent extends ShopEvent {
  String name;

  EditingDetailNameEvent(this.name);
}

class SaveDetailNameEvent extends ShopEvent {
  String name;
  int id;

  SaveDetailNameEvent(this.name,this.id);
}

