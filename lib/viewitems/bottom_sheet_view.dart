
import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final String gifUrl;

  const CustomBottomSheet({required this.gifUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.white,
      child: Center(
        child: Image.network(gifUrl),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_gif/flutter_gif.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:we_chat_app/resources/dimens.dart';
// import 'package:we_chat_app/widgets/search_box_widget.dart';
//
// // class ExpandableBottomSheet extends StatefulWidget {
// //   @override
// //   _ExpandableBottomSheetState createState() => _ExpandableBottomSheetState();
// // }
// //
// // class _ExpandableBottomSheetState extends State<ExpandableBottomSheet>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _animationController;
// //   bool _isExpanded = false;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _animationController = AnimationController(
// //       vsync: this,
// //       duration: Duration(milliseconds: 300),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _animationController.dispose();
// //     super.dispose();
// //   }
// //
// //   void _toggleBottomSheet() {
// //     setState(() {
// //       _isExpanded = !_isExpanded;
// //       if (_isExpanded) {
// //         _animationController.forward();
// //       } else {
// //         _animationController.reverse();
// //       }
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: _toggleBottomSheet,
// //       child: Container(
// //         height: 200,
// //         color: Colors.transparent,
// //         child: Column(
// //           children: [
// //             SearchBoxWidget(
// //               hintText: "Search GIPHY",
// //               onSearch: (searchText){
// //                 // search function
// //
// //               },),
// //             Expanded(
// //               child: GridView.custom(
// //                 gridDelegate: SliverQuiltedGridDelegate(
// //                   crossAxisCount: 4,
// //                   mainAxisSpacing: 4,
// //                   crossAxisSpacing: 4,
// //                   repeatPattern: QuiltedGridRepeatPattern.inverted,
// //                   pattern: [
// //                     QuiltedGridTile(2, 2),
// //                     QuiltedGridTile(1, 1),
// //                     QuiltedGridTile(1, 1),
// //                     QuiltedGridTile(1, 2),
// //                   ],
// //                 ),
// //                 childrenDelegate: SliverChildBuilderDelegate(
// //                       (context, index) => ListTile(title: Text('$index')),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// class BottomSheetView extends StatefulWidget {
//
//
//   BottomSheetView({
//     super.key,
//
//   });
//
//   @override
//   State<BottomSheetView> createState() => _BottomSheetViewState();
// }
//
// class _BottomSheetViewState extends State<BottomSheetView> with TickerProviderStateMixin {
//   late FlutterGifController controller;
//   @override
//   void initState() {
//     controller = FlutterGifController(vsync: this);
//     controller.animateTo(10, duration: Duration(milliseconds: 1000)); // Note that animate to your last frame of your animation, here mine is 10.
//     controller.addListener(() {
//       if (controller.isCompleted) {
//         print("compleate");
//         controller.repeat(
//           min: 0,
//           max: 13,
//           period: const Duration(milliseconds: 3000),
//         );
//
//       }
//     });
//
//     super.initState();
//   }
// @override
//   void dispose() {
//   controller.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return
//       Container(
//         height: MediaQuery.of(context).size.height*0.8, // Add height
//         padding: EdgeInsets.all(MARGIN_MEDIUM),
//     child: Column(
//     children: [
//       SearchBoxWidget(
//         hintText: "Search GIPHY",
//         onSearch: (searchText){
//           // search function
//
//         },),
//         Expanded(
//           child: GridView.custom(
//             gridDelegate: SliverQuiltedGridDelegate(
//               crossAxisCount: 4,
//               mainAxisSpacing: 4,
//               crossAxisSpacing: 4,
//               repeatPattern: QuiltedGridRepeatPattern.inverted,
//               pattern: [
//                 QuiltedGridTile(2, 2),
//                 QuiltedGridTile(1, 1),
//                 QuiltedGridTile(1, 1),
//                 QuiltedGridTile(1, 2),
//               ],
//             ),
//             childrenDelegate: SliverChildBuilderDelegate(
//                   (context, index) => Container(
//                       color: Colors.grey,
//                       child:
//                       GifImage(
//                         controller: controller,
//                         repeat: ImageRepeat.repeat,
//                         image: const NetworkImage(
//                             "http://img.mp.itc.cn/upload/20161107/5cad975eee9e4b45ae9d3c1238ccf91e.jpg"),
//                       ),
//                      // ListTile(title: Text('$index'))
//                   ),
//             ),
//           ),
//         )
//
//     ],
//     ));
//
//   }
// }
