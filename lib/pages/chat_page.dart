import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'widgets/chat_bubble.dart';

const apiKey = 'AIzaSyAsM7WdFtuMOhvwuODMOUrtFBq2dXIFl1M';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  TextEditingController messageController = TextEditingController();

  // final prompt = 'Write a story about a magic backpack.';
  // final content = [Content.text(prompt)];
  // final response = await model.generateContent(content);

  bool isLoading = false;

  List<ChatBubble> chatBubbles = [
    const ChatBubble(
      direction: Direction.left,
      message: 'Halo, saya Hera AI. Ada yang bisa saya bantu?',
      photoUrl: 'https://i.pravatar.cc/150?img=47',
      type: BubbleType.alone,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CupertinoButton(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Hera AI', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              reverse: true,
              padding: const EdgeInsets.all(10),
              children: chatBubbles.reversed.toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          final content = [
                            Content.text(messageController.text)
                          ];
                          final GenerateContentResponse response =
                              await model.generateContent(content);
                          print(response.text);
                          setState(() {
                            chatBubbles = [
                              ...chatBubbles,
                              ChatBubble(
                                direction: Direction.right,
                                message: messageController.text,
                                photoUrl: null,
                                type: BubbleType.alone,
                              )
                            ];
                            chatBubbles = [
                              ...chatBubbles,
                              ChatBubble(
                                direction: Direction.left,
                                message: response.text ??
                                    'Maaf, saya tidak mengerti',
                                photoUrl: 'https://i.pravatar.cc/150?img=47',
                                type: BubbleType.alone,
                              )
                            ];

                            messageController.clear();
                            isLoading = false;
                          });
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
