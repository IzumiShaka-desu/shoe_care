import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shoe_care/presentation/widgets/rating_bar.dart';

class ReviewForm {
  final String comment;
  final double rating;
  ReviewForm(this.comment, this.rating);
}

class ReviewDialog extends StatefulWidget {
  const ReviewDialog({
    super.key,
  });

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  late final TextEditingController _commentController;
  final formKey = GlobalKey<FormState>();
  double _rating = 0;
  @override
  void initState() {
    _commentController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Review"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Give your review "),
          const SizedBox(
            height: 8,
          ),
          Form(
            key: formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _commentController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Comment can't be empty";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Give your review",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              RatingBar(
                onRatingChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final form = ReviewForm(_commentController.text, _rating);
              context.pop(form);
            }
          },
          child: const Text("Add Review"),
        ),
      ],
    );
  }
}
