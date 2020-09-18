class DetailState {}

class DetailInitial extends DetailState{}
class DetailEditing extends DetailState{
  String name;

  DetailEditing(this.name);
}
class DetailSavedName extends DetailState{
  String name;

  DetailSavedName(this.name);
}