
import 'package:final_project/chatboat/api_key.dart';
import 'package:flutter/material.dart';

class HomeChat extends StatefulWidget {
  const HomeChat({super.key});

  @override
  State<HomeChat> createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> {
  var size = ["small ", " medium", "large"];
  var values = ["256*256", "512*512", " 1024*1024"];
  String? dropValues;
  
  final _textController = TextEditingController();
  String image ='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI-Assistant To Generate iamges"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 60,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextFormField(
                                controller: _textController,
                                decoration: InputDecoration(
                                  hint: Text("Enter Your Promt "),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            height: 64,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                    icon: Icon(
                                      Icons.expand_more,
                                      color: Colors.black,
                                    ),
                                    value: dropValues,
                                    hint: Text("Select Size"),
                                    items: List.generate(size.length, (index) {
                                      return DropdownMenuItem(
                                        value: values[index],
                                        child: Text(size[index]),
                                      );
                                    }),
                                    onChanged: (values) {
                                      setState(() {
                                        dropValues = values.toString();
                                      });
                                    })),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 450,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shadowColor: Colors.black,
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadiusGeometry.circular(18))),
         onPressed: () async {
  if (_textController.text.isNotEmpty && dropValues != null) {
    final generatedImage = await ReplicateApi.generateImage(
      _textController.text,
      dropValues!,
    );
    if (generatedImage != null) {
      setState(() {
        image = generatedImage;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to generate image.")),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter a prompt and select image size")),
    );
  }
}
,


                            
                            child: Text(
                              "Genreate",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ))
                    ],
                  ),
                )),
            Expanded(
                child: Container(
              color: Colors.yellow,
            )),
          ],
        ),
      ),
    );
  }
}
