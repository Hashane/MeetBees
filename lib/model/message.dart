class Message {
  final String text;
  final DateTime date;

  Message(this.text, this.date);

  ///Transform the JSON you receive from the Realtime Database, into a Message
  Message.fromJson(Map<dynamic, dynamic> json)
      : date = DateTime.parse(json['date'] as String),
        text = json['text'] as String;

  ///Transform the Message into JSON, for saving.
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'date': date.toString(),
    'text': text,
  };
}