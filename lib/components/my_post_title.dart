import 'package:aplicaccion_2/models/post.dart';
import 'package:flutter/material.dart';

class MyPostTitle extends StatefulWidget {
  final Post post;
  const MyPostTitle({super.key, required this.post});

  @override
  State<MyPostTitle> createState() => _MyPostTitleState();
}

class _MyPostTitleState extends State<MyPostTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.primary,
              ),
              Text(
                widget.post.name,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '@${widget.post.username}',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              )
            ],
          ),
          Text(
            widget.post.message,
            style:
                TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          )
        ],
      ),
    );
  }
}
