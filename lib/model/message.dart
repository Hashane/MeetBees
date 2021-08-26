class Message1 {
  final String text;
  final DateTime date;

  Message1(this.text, this.date);

  ///Transform the JSON you receive from the Realtime Database, into a Message
  Message1.fromJson(Map<dynamic, dynamic> json)
      : date = DateTime.parse(json['date'] as String),
        text = json['text'] as String;

  ///Transform the Message into JSON, for saving.
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'date': date.toString(),
    'text': text,
  };
}