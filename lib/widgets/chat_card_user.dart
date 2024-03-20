import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/chat_user.dart';

class ChatUserCard extends StatelessWidget {
  final ChatUser user;

  const ChatUserCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Getting the media query for screen size
    final mq = MediaQuery.of(context);

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: mq.size.width * 0.04,
        vertical: 4,
      ),
      // You can change the shade to match your design
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          // Add your onTap functionality here
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(mq.size.height * .03),
                child: CachedNetworkImage(
                  width: mq.size.height * .055,
                  height: mq.size.height * .055,
                  imageUrl: user.image,
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(child: Icon(CupertinoIcons.person)),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User name
                    Text(
                      user.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Last message
                    Text(user.about),
                  ],
                ),
              ),
              // Last message time
              //Text('12:00 PM'),
              // Circular dot as trailing widget
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 2, 194, 101),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
