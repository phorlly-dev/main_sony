import 'package:go_router/go_router.dart';
import 'package:main_sony/controllers/export_controller.dart';
import 'package:main_sony/views/export_views.dart';

class CommentDialog extends StatelessWidget {
  final int postId;

  const CommentDialog({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final commentCtrl = Get.put(CommentController());
    final formKey = GlobalKey<FormState>();

    // Controllers for form fields
    final name = TextEditingController();
    final email = TextEditingController();
    final website = TextEditingController();
    final comment = TextEditingController();

    final colors = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text('Leave a Reply'),
      icon: Icon(Icons.comment_rounded),
      iconColor: colors.primary,
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: comment,
                minLines: 3,
                maxLines: 8,
                decoration: InputDecoration(
                  labelText: 'Comment',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Comment required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Email required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.url,
                controller: website,
                decoration: const InputDecoration(labelText: 'Website'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton.icon(
          onPressed: commentCtrl.isSubmitting.value
              ? null
              : () => context.pop(),
          icon: const Icon(Icons.close_rounded),
          label: const Text('Cancel'),
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.outline,
            foregroundColor: Colors.white,
          ),
        ),
        Obx(() {
          return ElevatedButton.icon(
            onPressed: commentCtrl.isSubmitting.value
                ? null
                : () async {
                    if (!formKey.currentState!.validate()) return;
                    FocusScope.of(context).unfocus();

                    await commentCtrl.submitComment(
                      context,
                      postId: postId,
                      content: comment.text.trim(),
                      authorName: name.text.trim(),
                      authorEmail: email.text.trim(),
                      authorUrl: website.text.trim(),
                    );

                    if (context.mounted) {
                      context.pop();
                    }
                  },
            icon: const Icon(Icons.send_rounded),
            label: commentCtrl.isSubmitting.value
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Submit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: Colors.white,
            ),
          );
        }),
      ],
    );
  }
}
