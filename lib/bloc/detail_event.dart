class DetailEvent {}

class EditingNameEvent extends DetailEvent {
  String name;

  EditingNameEvent(this.name);
}

class SaveNameEvent extends DetailEvent {
  String name;
  int id;

  SaveNameEvent(this.name,this.id);
}
