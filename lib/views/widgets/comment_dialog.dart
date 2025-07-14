import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_sony/controllers/comment_controller.dart';

Future<void> showCommentDialog({
  required BuildContext context,
  required int postId,
  Function()? onSuccess,
}) async {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();
  final commentController = TextEditingController();

  final commentCtrl = Get.put(CommentController());
  final colors = Theme.of(context).colorScheme;

  await Get.dialog(
    Obx(
      () => AlertDialog(
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
                  controller: commentController,
                  minLines: 3,
                  maxLines: 8,
                  decoration: InputDecoration(
                    labelText: 'Comment',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Comment required'
                      : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Name required' : null,
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Email required' : null,
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: websiteController,
                  decoration: InputDecoration(labelText: 'Website'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: commentCtrl.isSubmitting.value ? null : () => Get.back(),
            label: Text('Cancel'),
            icon: Icon(Icons.close_rounded),
            autofocus: true,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.outline, // Dark color (for Cancel)
              foregroundColor: Colors.white, // Text/Icon color
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          ElevatedButton.icon(
            onPressed: commentCtrl.isSubmitting.value
                ? null
                : () async {
                    if (!formKey.currentState!.validate()) return;

                    final success = await commentCtrl.submitComment(
                      postId: postId,
                      content: commentController.text.trim(),
                      authorName: nameController.text.trim(),
                      authorEmail: emailController.text.trim(),
                      authorUrl: websiteController.text.trim(),
                    );
                    if (success) {
                      Get.back();
                      if (onSuccess != null) onSuccess();
                    }
                  },
            label: commentCtrl.isSubmitting.value
                ? SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('Submit'),
            icon: Icon(Icons.send_rounded),
            autofocus: true,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    ),
    barrierDismissible: false,
  );
}
