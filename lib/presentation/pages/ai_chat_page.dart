import 'package:ai_financial_management_system/ai_model/model_settings/model_config.dart';
import 'package:ai_financial_management_system/ai_model/model_settings/model_rules.dart';
import 'package:ai_financial_management_system/data_crud/data_crud.dart';
import 'package:ai_financial_management_system/presentation/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ai_financial_management_system/ai_model/chat_users.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

final _aiChatBox = Hive.box('ai_chat_history');

Map<String, dynamic> _chatMessageToMap(ChatMessage message) {
  return {
    'text': message.text,
    'createdAt': message.createdAt.toIso8601String(),
    'user': message.user.id,
  };
}

ChatMessage _mapToChatMessage(Map<String, dynamic> map) {
  return ChatMessage(
    text: map['text'],
    createdAt: DateTime.parse(map['createdAt']),
    user: map['user'] == currentUser.id ? currentUser : aifms,
  );
}

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  late final GenerativeModel _geminiModel;
  final List<ChatMessage> allMessages = [];
  final List<ChatUser> _typingUsers = <ChatUser>[];

  @override
  void initState() {
    super.initState();
    _geminiModel = geminiModel;
    _loadChatHistory();
    if (allMessages.isEmpty) {
      _addWelcomeMessage();
    }
  }

  void _loadChatHistory() {
    final chatHistory = _aiChatBox.get('messages');
    if (chatHistory != null) {
      setState(() {
        allMessages.addAll(
          (chatHistory as List).map((message) =>
              _mapToChatMessage(Map<String, dynamic>.from(message))),
        );
      });
    }
  }

  void _saveChatHistory() {
    final messages = allMessages.map(_chatMessageToMap).toList();
    _aiChatBox.put('messages', messages);
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      user: aifms,
      text: "Welcome! How may I assist you today?",
      createdAt: DateTime.now(),
    );
    setState(() {
      allMessages.insert(0, welcomeMessage);
      _saveChatHistory();
    });
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    final dataCrud = Provider.of<DataCrud>(context, listen: false);
    final summary = dataCrud.getAllExpensesSummary();
    setState(() {
      allMessages.insert(0, chatMessage);
      _typingUsers.add(aifms);
    });
    _saveChatHistory();

    try {
      final List<Content> conversationHistory =
          allMessages.reversed.map((message) {
        return Content.text(message.text);
      }).toList();

      final response = await _geminiModel.generateContent([
        Content.text(systemPrompt),
        Content.text(summary),
        ...conversationHistory,
      ], generationConfig: GeminiModelInstance().generationConfig);

      if (response.text != null) {
        final chatCleanedResponse =
            response.text!.replaceFirst(RegExp('^:+\\s*'), '');
        final aiMessage = ChatMessage(
          user: aifms,
          text: chatCleanedResponse,
          createdAt: DateTime.now(),
        );

        setState(() {
          allMessages.insert(0, aiMessage);
          _typingUsers.remove(aifms);
        });
        _saveChatHistory();
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _typingUsers.remove(aifms);
      });
    }
  }

  Future<void> _getAllExpenses() async {
    final dataCrud = Provider.of<DataCrud>(context, listen: false);
    final summary = dataCrud.getAllExpensesSummary();

    if (summary.isEmpty) {
      _sendFinancialData("No financial data found in the database.");
      return;
    }

    _sendFinancialData(summary);
  }

  void _sendFinancialData(String text) {
    setState(() {
      allMessages.insert(
          0,
          ChatMessage(
            user: currentUser,
            text: text,
            createdAt: DateTime.now(),
          ));
    });
    _saveChatHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        actions: [
          TextButton.icon(
            icon: Icon(Icons.delete_sweep, color: mainWhite),
            label: Text(
              'Clear chat',
              style: TextStyle(color: secWhite),
            ),
            onPressed: () {
              setState(() {
                allMessages.clear();
                final clreaMessage = ChatMessage(
                  user: aifms,
                  text: "Chat history cleared.",
                  createdAt: DateTime.now(),
                );
                allMessages.add(clreaMessage);
                _saveChatHistory();
              });
            },
          ),
        ],
        backgroundColor: mainGreen,
        // centerTitle: true,
        title: Text(
          'AI Financial Assistant',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: mainWhite),
        ),
      ),
      body: _aiUi(),
    );
  }

  Widget _aiUi() {
    return Column(
      children: [
        Expanded(
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: DashChat(
              typingUsers: [..._typingUsers],
              currentUser: currentUser,
              onSend: _sendMessage,
              scrollToBottomOptions: ScrollToBottomOptions(
                scrollToBottomBuilder: (scrollController) => Container(
                    alignment: Alignment.bottomCenter,
                    child: FloatingActionButton.small(
                      shape: CircleBorder(),
                      backgroundColor: Colors.white70,
                      child: Icon(Icons.arrow_downward,
                          color: mainGreen, size: 20),
                      onPressed: () {
                        scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                    )),
              ),
              messageOptions: MessageOptions(
                messagePadding: EdgeInsets.all(13),
                textColor: secWhite,
                showTime: true,
                containerColor: secGreen,
                currentUserContainerColor: mainGreen,
                messageTextBuilder: _buildMarkdownMessage,
              ),
              messages: allMessages,
              inputOptions: InputOptions(
                cursorStyle: const CursorStyle(color: Colors.white70),
                sendOnEnter: true,
                leading: [
                  IconButton(
                    icon: Icon(Icons.analytics, color: mainGreen),
                    onPressed: _getAllExpenses,
                  ),
                ],
                sendButtonBuilder: (onSend) {
                  return IconButton(
                    icon: Icon(Icons.send, color: mainGreen),
                    onPressed: onSend,
                  );
                },
                inputDecoration: InputDecoration(
                  hintText: 'Ask a question...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: mainGreen)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: mainGreen)),
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 13.5),
          padding: const EdgeInsets.only(left: 25),
          alignment: Alignment.centerLeft,
          child: Text(
            'Note: AI responses may contain inaccuracies. Please verify financial information.',
            // textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 8,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildMarkdownMessage(ChatMessage message, _, __) {
    return MarkdownBody(data: message.text);
  }
}
