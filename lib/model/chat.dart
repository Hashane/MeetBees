import 'dart:convert';

class Chat {
  final String name, lastMessage, image;
  final List<dynamic> user2;
  final bool isActive;
  final String lastOnline;

  Chat({
    this.name = '',
    this.lastMessage = '',
    this.image = '',
    this.user2,
    this.lastOnline = '',
    this.isActive = false,
  });

  ///Transform the JSON you receive from the Realtime Database, into a Message
  Chat.fromJson(Map<Object, Object> json,this.isActive,this.lastOnline)
      : name = json['name'],
        lastMessage = json['lastSentMessage'],
        image = json['thumb'],
        user2 =  json['members'];

  ///Used for fetching second user's info
  Chat.fromUsers(Map<Object, Object> json, this.lastMessage, this.user2)
      : name = json["name"],
        image = json['thumb'],
        isActive = json['isActive'] == "1" ? true : false,
        lastOnline = json['lastOnline'];

// factory Chat.fromUsers(MapEntry<dynamic, dynamic> data){
//   return Chat(
//     name: data.value['name'],
//     image: data.value['thumb'],
//    // image: data.value['LastSentMessage'],
//   );
// }

  // List chatsData = [
  //   Chat(
  //     name: "Jenny Wilson",
  //     lastMessage: "Hope you are doing well...",
  //     image: "assets/images/user.png",
  //     time: "3m ago",
  //     isActive: false,
  //   ),
  //   Chat(
  //     name: "Esther Howard",
  //     lastMessage: "Hello Abdullah! I am...",
  //     image: "assets/images/user_2.png",
  //     time: "8m ago",
  //     isActive: true,
  //   ),
  //   Chat(
  //     name: "Ralph Edwards",
  //     lastMessage: "Do you have update...",
  //     image: "assets/images/user_3.png",
  //     time: "5d ago",
  //     isActive: false,
  //   ),
  //   Chat(
  //     name: "Jacob Jones",
  //     lastMessage: "You’re welcome :)",
  //     image: "assets/images/user_4.png",
  //     time: "5d ago",
  //     isActive: true,
  //   ),
  //   Chat(
  //     name: "Albert Flores",
  //     lastMessage: "Thanks",
  //     image: "assets/images/user_5.png",
  //     time: "6d ago",
  //     isActive: false,
  //   ),
  //   Chat(
  //     name: "Jenny Wilson",
  //     lastMessage: "Hope you are doing well...",
  //     image: "assets/images/user.png",
  //     time: "3m ago",
  //     isActive: false,
  //   ),
  //   Chat(
  //     name: "Esther Howard",
  //     lastMessage: "Hello Abdullah! I am...",
  //     image: "assets/images/user_2.png",
  //     time: "8m ago",
  //     isActive: true,
  //   ),
  //   Chat(
  //     name: "Ralph Edwards",
  //     lastMessage: "Do you have update...",
  //     image: "assets/images/user_3.png",
  //     time: "5d ago",
  //     isActive: false,
  //   ),
  // ];
}