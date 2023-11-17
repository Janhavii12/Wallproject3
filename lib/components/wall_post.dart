import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallproject/components/like_button.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;

  const WallPost({
    Key? key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
  }) : super(key: key);

  @override
  _wallPostState createState() => _wallPostState();
}

class _wallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    if (mounted) {
      setState(() {
        isLiked = !isLiked;
      });
    }
    DocumentReference postRef =
        FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.only(top: 25, left: 25, right: 25),
        padding: EdgeInsets.all(25),
        child: Row(
          children: [
            Column(
              children: [
                LikeButton(isLiked: isLiked, onTap: toggleLike),
                const SizedBox(
                  height: 5,
                ),
                Text(widget.likes.length.toString(),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),),
              ],
            ),
            // Container(
            //   decoration: BoxDecoration(
            //       shape: BoxShape.circle, color: Colors.grey[400]),
            //   padding: EdgeInsets.all(10),
            //   child: const Icon(
            //     Icons.person,
            //     color: Colors.white,
            //   ),
            // ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.message,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            )
          ],
        ));
  }

  @override
  void dispose() {
    // Cancel any ongoing operations like timers, animations, or streams.
    // For example:

    super.dispose();
  }
}
