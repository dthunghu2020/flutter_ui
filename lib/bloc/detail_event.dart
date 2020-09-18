class DetailEvent {}

class EditingNameEvent extends DetailEvent {
  String name;

  EditingNameEvent(this.name);
}

class SaveNameEvent extends DetailEvent {
  String name;

  SaveNameEvent(this.name);
}
