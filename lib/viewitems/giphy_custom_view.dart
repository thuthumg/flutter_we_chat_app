import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomGiphyScreen extends StatefulWidget {
  @override
  _CustomGiphyScreenState createState() => _CustomGiphyScreenState();
}

class _CustomGiphyScreenState extends State<CustomGiphyScreen> {
  final String apiKey = "VV9RTZMYg9CMotPE7viDXSQTwOJos5Yg"; // Replace with your actual Giphy API key
  final String searchQuery = 'Happy'; // Replace with your desired search query
  List<String> gifUrls = [];

  Future<void> fetchCustomGIFs() async {
    try {
      final gifs = await getCustomGIFs(apiKey, searchQuery);
      setState(() {
        gifUrls = gifs;
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Giphy GIFs'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: fetchCustomGIFs,
              child: Text('Fetch GIFs'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: gifUrls.length,
                itemBuilder: (context, index) {

                 debugPrint("check url ${gifUrls[index]}");

                  return Image.network(gifUrls[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> getCustomGIFs(String apiKey, String searchQuery) async {
    final apiUrl = 'https://api.giphy.com/v1/gifs/search';
    final queryParameters = {
      'api_key': apiKey,
      'q': searchQuery,
    };
    final uri = Uri.parse(apiUrl).replace(queryParameters: queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final gifList = data['data'] as List<dynamic>;
      return gifList.map<String>((gif) => gif['url'] as String).toList();
    } else {
      throw Exception('Failed to fetch GIFs');
    }
  }
}
