class CaringType {
  int id;
  String name;
  String description;

  CaringType({required this.id, required this.name, required this.description});
}

class Patient {
  int id;
  String name;
  String roomNumber;
  bool isStopped;

  Patient(
      {required this.id,
      required this.name,
      required this.roomNumber,
      required this.isStopped});
}

class Caring {
  int id;
  int caringTypeId;
  int patientId;
  String time;
  String description;
  bool isStopped;

  Caring(
      {required this.id,
      required this.caringTypeId,
      required this.patientId,
      required this.time,
      required this.description,
      required this.isStopped});
}
