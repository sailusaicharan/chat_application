import 'package:chat_application/main.dart';
import 'package:chat_application/models/chat_user.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user; 

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      // color: Colors.blue.shade100,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      child: InkWell(
        onTap: () {},
        child:  ListTile(
          leading: const CircleAvatar(child: Icon(CupertinoIcons.person),),

          //user profile picture
          title: Text(widget.user.name),

          //last message
          subtitle: Text(widget.user.about, maxLines: 1),

          //last message time
          trailing: const Text('17:25 PM',style: TextStyle(color: Colors.black54),),
        ),
      ),
    );
  }
}
