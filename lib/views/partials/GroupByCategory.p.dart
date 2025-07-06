// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:main_sony/controllers/Post.c.dart';
// import 'package:main_sony/views/widgets/BlogCart.w.dart';

// class GroupByCategory extends StatelessWidget {
//   final PostController controller;
//   const GroupByCategory({super.key, required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       // Group posts by category
//       final grouped = controller.groupByCategory(controller.posts);

//       // Optionally: To keep category order consistent
//       final sortedCatIds = grouped.keys.toList()..sort();

//       return Column(
//         children: [
//           for (final catId in sortedCatIds) ...[
//             // Category Header
//             Divider(height: 20, thickness: 2, color: Colors.teal.shade200),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 controller.categoryMap[catId]!.name?.toUpperCase() ??
//                     "Uncategorized",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.teal,
//                 ),
//               ),
//             ),
//             Divider(color: Colors.teal.shade100),
//             // Posts in category
//             ...grouped[catId]!.map((item) {
//               final yoast = item.yoastHeadJson;
//               final title = item.title?.rendered ?? 'No Title';
//               final desc = item.excerpt?.rendered ?? 'No Description';
//               final author = controller.authorName(item);
//               final media = controller.mediaMap[item.featuredMedia];
//               final ogImage = yoast?['og_image'];
//               final imgUrl = (ogImage is List && ogImage.isNotEmpty)
//                   ? ogImage[0]['url']
//                   : null;
//               final catName =
//                   controller.categoryMap[catId]!.name ??
//                   "Uncategorized";

//               return BlogCard(
//                 id: item.id,
//                 imageUrl: media?.sourceUrl ?? imgUrl,
//                 title: title,
//                 description: desc,
//                 date: item.date ?? DateTime.now(),
//                 onReadMore: () {
//                   print("Read more");
//                 },
//                 category: catName,
//                 author: author?.name ?? "User",
//                 onComment: () {},
//               );
//             }),
//           ],
//         ],
//       );
//     });
//   }
// }
