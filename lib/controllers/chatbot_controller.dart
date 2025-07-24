import 'package:get/get.dart';
import 'package:main_sony/views/export_views.dart';

/// Controller for handling chat interactions
class ChatbotController extends GetxController {
  // Reactive list of messages
  final RxList<OpenAIChatCompletionChoiceMessageModel> messages =
      <OpenAIChatCompletionChoiceMessageModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString prompt = ''.obs; // Make it observable
  final RxString modelName = 'gpt-4.1-mini'.obs;

  // Controllers
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  Future<void> sendMessage() async {
    final msg = textController.text.trim();
    if (msg.isEmpty || isLoading.value) return;

    // Lock UI and clear input
    isLoading.value = true;
    textController.clear();
    prompt.value = '';

    // 1️⃣ Add user message to UI
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      role: OpenAIChatMessageRole.user,
      content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(msg)],
    );
    messages.add(userMessage);

    // 2️⃣ Prepare conversation payload from existing messages
    final conversation = List<OpenAIChatCompletionChoiceMessageModel>.from(
      messages,
    );

    try {
      // 3️⃣ Send to OpenAI
      final response = await OpenAI.instance.chat.create(
        model: modelName.value,
        messages: conversation,
      );

      final choice = response.choices.first.message;
      // Concatenate text parts
      final botText =
          choice.content
              ?.where((c) => c.text != null)
              .map((c) => c.text!)
              .join('\n\n') ??
          '';

      // 4️⃣ Add assistant response to UI
      final assistantMessage = OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.assistant,
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(botText),
        ],
      );
      messages.add(assistantMessage);

      // 5️⃣ Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      messages.add(
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.assistant,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text('Error: $e'),
          ],
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
