import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var livedata;
  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();

  @override
  void initState() {
    super.initState();
    msgtime();
    getlivedata();
  }

  msgtime() {
    const fiveSeconds = const Duration(seconds: 5);
    // _fetchData() is your function to fetch data
    Timer.periodic(fiveSeconds, (Timer t) => getlivedata());
  }

  getlivedata() async {
    var apiurl = "https://skmasum.tech/flutterapi/notes.php";
    var apidata = await http.get(apiurl);
    livedata = convert.jsonDecode(apidata.body)["notes"];
    //print(livedata.toString());
    print("called data");
    //msgtime();
    setState(() {});
  }

  sendnotedata() async {
    final senddataapi =
        await http.post("https://skmasum.tech/flutterapi/sendnote.php", body: {
      'title': title.text,
      'note': note.text,
    });
    print('Response status: ${senddataapi.statusCode}');
    // print('Response body: ${senddataapi.body}');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // height: 300,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  TextField(
                    controller: title,
                    decoration: InputDecoration(
                      labelText: "Title",
                    ),
                  ),
                  TextField(
                    controller: note,
                    decoration: InputDecoration(
                      labelText: "Note",
                    ),
                  ),
                  Container(
                    width: 150,
                    padding: EdgeInsets.only(top: 20),
                    child: MaterialButton(
                      onPressed: () {
                        sendnotedata();
                      },
                      color: Colors.greenAccent,
                      child: Text("Send Note"),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 600,
              child: livedata != null
                  ? ListView.builder(
                      itemCount: livedata.length,
                      itemBuilder: (context, index) {
                        var dt = livedata[index];
                        return Padding(
                          padding: EdgeInsets.fromLTRB(20, 2, 20, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${dt['title']}"),
                              Text("${dt['note']}"),
                              Divider(
                                color: Colors.blue,
                              )
                            ],
                          ),
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
