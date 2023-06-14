import 'package:flutter/material.dart';
//import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  // final controller = MultiImagePickerController(
  //   maxImages: 10,
  //   withReadStream: true,
  //   allowedImageTypes: ['png', 'jpg', 'jpeg'],
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
          /*  MultiImagePickerView(
              addButtonTitle: "aaa",
              addMoreButtonTitle: "bbb",
              onChange: (list) {
                debugPrint(list.toString());
              },
              controller: controller,
              padding: const EdgeInsets.all(10),
            ),*/
            const SizedBox(height: 32),
          //  const CustomExamples()
          ],
        ),
      ),
    /*  appBar: AppBar(
        title: const Text('Multi Image Picker View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_upward),
            onPressed: () {
              final images = controller.images;
              // use these images
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(images.map((e) => e.name).toString())));
            },
          ),
        ],
      ),*/
    );
  }

 /* @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }*/
}