import 'package:flutter/material.dart';
import 'package:giphy_get/giphy_get.dart';

class GiphyWidget extends StatefulWidget {
 // final String title;

  const GiphyWidget({ super.key});
  @override
  // ignore: library_private_types_in_public_api
  _GiphyWidgetState createState() => _GiphyWidgetState();
}

class _GiphyWidgetState extends State<GiphyWidget> {
 // late ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

  //Gif
  GiphyGif? currentGif;

  // Giphy Client
  late GiphyClient client = GiphyClient(apiKey: giphyApiKey, randomId: '');

  // Random ID
  String randomId = "";

  String giphyApiKey = const String.fromEnvironment("VV9RTZMYg9CMotPE7viDXSQTwOJos5Yg");

  @override
  void initState() {
    super.initState();
    print("giphy widget");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      client.getRandomId().then((value) {
        setState(() {
          randomId = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return

      GiphyGetWrapper(
        giphy_api_key: "VV9RTZMYg9CMotPE7viDXSQTwOJos5Yg",
        builder: (stream, giphyGetWrapper) {
          stream.listen((gif) {
            setState(() {
              currentGif = gif;
            });
          });

          return

            Scaffold(
            // appBar: AppBar(
            //   title: Row(
            //     children: [
            //       Image.network("http://img.mp.itc.cn/upload/20161107/5cad975eee9e4b45ae9d3c1238ccf91e.jpg"),
            //       const SizedBox(
            //         width: 20,
            //       ),
            //       const Text("GET DEMO")
            //     ],
            //   ),
            // ),
            body:

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Row(
                  //   children: [
                  //     const Expanded(child: Text("Dark Mode")),
                  //     // Switch(
                  //     //     value:
                  //     //     Theme.of(context).brightness == Brightness.dark,
                  //     //     onChanged: (value) {
                  //     //       themeProvider.setCurrentTheme(
                  //     //           value ? ThemeMode.dark : ThemeMode.light);
                  //     //     })
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     const Expanded(child: Text("Material 3")),
                  //     // Switch(
                  //     //     value: themeProvider.material3,
                  //     //     onChanged: (value) {
                  //     //       themeProvider.setMaterial3(value);
                  //     //     })
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // Text("Random ID: $randomId"),
                  // const Text(
                  //   "Selected GIF",
                  //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),


                  currentGif != null
                      ? SizedBox(
                    child: GiphyGifWidget(
                      imageAlignment: Alignment.center,
                      gif: currentGif!,
                      giphyGetWrapper: giphyGetWrapper,
                      borderRadius: BorderRadius.circular(30),
                      showGiphyLabel: true,
                    ),
                  )
                      : const Text("No GIF")
                ],
              ),
            ),

            floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  giphyGetWrapper.getGif(
                    '',
                    context,
                    showGIFs: true,
                    showStickers: true,
                    showEmojis: true,
                  );
                },
                tooltip: 'Open Sticker',
                child: const Icon(Icons
                    .insert_emoticon)), // This trailing comma makes auto-formatting nicer for build methods.
          );
        });
  }
}