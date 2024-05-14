import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
// Import your generative model package

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [];

  // Function to handle sending a message and generating a response
  Future<void> _sendMessage(String text) async {
    final apiKey = "enter your key";
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    String text1 = "message $text is food based give respose as yes else no";
    // Create content for the model
    final content = [Content.text(text1)];
    final content1 = [Content.text(text)];
    String generatedContent1 = "Ask me about food plz";
    try {
      // Generate content using the model
      final response = await model.generateContent(content);
      print(response.text!);
      if (response.text! == "yes") {
        final response1 = await model.generateContent(content1);

        // Extract the generated content from the response
        final generatedContent = response1.text!;
        setState(() {
          // Add the user message and generated response to the chat
          _messages.add(Message(text: text, isUser: true));
          _messages.add(Message(text: generatedContent, isUser: false));
        });
      } else {
        setState(() {
          // Add the user message and generated response to the chat
          _messages.add(Message(text: text, isUser: true));
          _messages.add(Message(text: generatedContent1, isUser: false));
        });
      }
    } catch (e) {
      // Handle any errors that occur during message generation
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 250, 230),
      appBar: AppBar(
        title: Text('Generative AI Chat Screen',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Color.fromARGB(255, 255, 250, 230),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = _messages[index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      message.text,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        hintText: 'Type a message...',
                        prefixIconColor: Colors.black),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Color.fromARGB(255, 253, 191, 96),
                  ),
                  onPressed: () {
                    String text = _textController.text.trim();
                    if (text.isNotEmpty) {
                      _sendMessage(text);
                      _textController.clear();
                    }
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

// Message class to represent user and AI generated messages
class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}

void main() {
  runApp(MaterialApp(
    home: ChatScreen(),
  ));
}
