import 'package:flutter/material.dart';
import 'package:k_learning/screen/learning_screen.dart';

class LinkScreen extends StatefulWidget {
  final int uid;
  const LinkScreen({super.key, required this.uid});

  @override
  State<LinkScreen> createState() => _LinkScreenState();
}

class _LinkScreenState extends State<LinkScreen> {
  int uid = 0;

  @override
  void initState() {
    super.initState();

    uid = widget.uid;
  }

  @override
  Widget build(BuildContext context) {
    final linkController = TextEditingController();

    void onPressed() {
      if (linkController.text != '') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => LearningScreen(
                uid: uid,
                link: linkController.text.substring(
                  linkController.text.indexOf('=') + 1,
                )),
          ),
        );
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Please Input Link",
                    ),
                  ],
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text("Confirm"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextField(
            controller: linkController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.link),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.blue),
              ),
              labelText: 'Input Youtube Link',
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onPressed,
          child: const Text('Start Learning'),
        ),
      ],
    );
  }
}
