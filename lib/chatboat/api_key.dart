import 'dart:convert';
import 'package:http/http.dart' as http;

const String replicateApiKey = "r8_3oCoDRFAKL8HmloGcaGeXyTpgYwV7fj0ib0Xe";

class ReplicateApi {
  static final url = Uri.parse("b");

  static final headers = {
    "Authorization": "Token $replicateApiKey",
    "Content-Type": "application/json"
  };

  static Future<String?> generateImage(String prompt, String size) async {
    try {
      var body = jsonEncode({
        "version": "db21e45fbd72aa63a7fbcb3cf1a44a3332c63115ee4b8c8b090c3e83da3a0c60", // Stable Diffusion v1.5
        "input": {
          "prompt": prompt,
          "width": sizeToWidth(size),
          "height": sizeToHeight(size)
        }
      });

      var res = await http.post(url, headers: headers, body: body);

      if (res.statusCode == 201) {
        var data = jsonDecode(res.body);
        var getUrl = data['urls']['get']; // polling URL

        // Poll until image is ready
        while (true) {
          var pollRes = await http.get(Uri.parse(getUrl), headers: headers);
          var pollData = jsonDecode(pollRes.body);
          if (pollData['status'] == 'succeeded') {
            final imageUrl = pollData['output'][0];
            print("Image URL: $imageUrl");
            return imageUrl;
          } else if (pollData['status'] == 'failed') {
            print("Image generation failed.");
            return null;
          }
          await Future.delayed(Duration(seconds: 1)); // wait before retry
        }
      } else {
        print("Replicate API Error: ${res.statusCode}");
        print(res.body);
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  static int sizeToWidth(String size) {
    switch (size) {
      case "512x512":
        return 512;
      case "768x768":
        return 768;
      default:
        return 256;
    }
  }

  static int sizeToHeight(String size) => sizeToWidth(size);
}
