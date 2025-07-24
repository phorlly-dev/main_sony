import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:main_sony/views/export_views.dart';

/// Chat screen UI
class AiChatbotScreen extends StatelessWidget {
  const AiChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatbotController controller = Get.put(ChatbotController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Model: ${controller.modelName.value}')),
        actions: [
          // Only wrap popup when observing modelName
          Obx(
            () => PopupMenuButton<String>(
              initialValue: controller.modelName.value,
              onSelected: (val) => controller.modelName.value = val,
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => ['gpt-4.1-mini', 'gpt-4o-mini']
                  .map(
                    (m) => PopupMenuItem(
                      value: m,
                      child: Row(
                        children: [
                          Text(m),
                          if (controller.modelName.value == m) ...[
                            SizedBox(width: 6),
                            Icon(Icons.check, size: 16, color: Colors.blue),
                          ],
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Message list
          Expanded(
            child: Obx(
              () => ListView.builder(
                controller: controller.scrollController,
                padding: EdgeInsets.all(8),
                itemCount: controller.messages.length,
                itemBuilder: (ctx, idx) =>
                    _buildMessage(controller.messages[idx], context),
              ),
            ),
          ),
          Divider(height: 1),
          // Input field + send button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.textController,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => controller.sendMessage(),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Type a prompt...',
                    ),
                    autofocus: true,
                    onChanged: (value) {
                      controller.prompt.value = value.trim();
                    },
                  ),
                ),
                Obx(() {
                  final isLoading = controller.isLoading.value;
                  final promptNotEmpty = controller.prompt.isNotEmpty;
                  final colors = Theme.of(context).colorScheme;

                  if (isLoading) {
                    return CupertinoActivityIndicator(color: colors.primary);
                  }
                  if (promptNotEmpty) {
                    return IconButton(
                      icon: Icon(Icons.send),
                      onPressed: controller.sendMessage,
                      color: colors.primary,
                    );
                  }

                  return SizedBox.shrink();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(
    OpenAIChatCompletionChoiceMessageModel msg,
    BuildContext context,
  ) {
    final isUser = msg.role == OpenAIChatMessageRole.user;
    final text =
        msg.content
            ?.where((c) => c.text != null)
            .map((c) => c.text!)
            .join('\n\n') ??
        '';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 6),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUser ? Colors.blueAccent : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SelectableText(
            text,
            style: TextStyle(
              color: isUser ? Colors.white : Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}
