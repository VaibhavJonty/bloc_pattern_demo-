class GetEventResponse {
  int count;
  Null next;
  Null previous;
  List<PetEvent> results;

  GetEventResponse({this.count, this.next, this.previous, this.results});

  GetEventResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = new List<PetEvent>();
      json['results'].forEach((v) {
        results.add(new PetEvent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PetEvent {
  int id;
  int eventType;
  String timestamp;
  String eventImage;
  String comment;
  int amountEaten;
  int foodGiven;
  Null medAmountGiven;
  int genericEventLabel;
  int pet;
  Null petMedicationName;

  PetEvent(
      {this.id,
        this.eventType,
        this.timestamp,
        this.eventImage,
        this.comment,
        this.amountEaten,
        this.foodGiven,
        this.medAmountGiven,
        this.genericEventLabel,
        this.pet,
        this.petMedicationName});

  PetEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventType = json['event_type'];
    timestamp = json['timestamp'];
    eventImage = json['event_image'];
    comment = json['comment'];
    amountEaten = json['amount_eaten'];
    foodGiven = json['food_given'];
    medAmountGiven = json['med_amount_given'];
    genericEventLabel = json['generic_event_label'];
    pet = json['pet'];
    petMedicationName = json['pet_medication_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['event_type'] = this.eventType;
    data['timestamp'] = this.timestamp;
    data['event_image'] = this.eventImage;
    data['comment'] = this.comment;
    data['amount_eaten'] = this.amountEaten;
    data['food_given'] = this.foodGiven;
    data['med_amount_given'] = this.medAmountGiven;
    data['generic_event_label'] = this.genericEventLabel;
    data['pet'] = this.pet;
    data['pet_medication_name'] = this.petMedicationName;
    return data;
  }
}
