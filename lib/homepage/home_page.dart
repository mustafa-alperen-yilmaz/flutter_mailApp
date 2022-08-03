import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:mailapp/api/speech_api.dart';
import 'package:clipboard/clipboard.dart';
import 'package:mailapp/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String text = "mail gönder alepren";
  String appBarTxt = "Mail APP";
  bool isMicActive = false;
  final PageStorageBucket _pageStorageBucket = PageStorageBucket();
  Widget curentScreen = const HomePage();
  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(appBarTxt),
          centerTitle: true,
          actions: [
            Builder(
              builder: ((context) => IconButton(
                    icon: const Icon(Icons.content_copy),
                    onPressed: () async {
                      await FlutterClipboard.copy(text);
                      // ignore: use_build_context_synchronously, deprecated_member_use
                      Scaffold.of(context).showSnackBar(
                        const SnackBar(content: Text("message Copied")),
                      );
                    },
                  )),
            ),
          ],
        ),
        body: PageStorage(
          bucket: _pageStorageBucket,
          child: SingleChildScrollView(
            reverse: true,
            padding: const EdgeInsets.all(30).copyWith(bottom: 150),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 30.0,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: isMicActive,
          endRadius: 60,
          glowColor: Theme.of(context).primaryColor,
          child: FloatingActionButton(
            // ignore: sort_child_properties_last
            child: Icon(isMicActive ? Icons.mic : Icons.mic_none, size: 38),
            onPressed: toggleRecording,
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 10,
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      colorBrightness: Brightness.light,
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1;
                          FlutterClipboard.copy(text);
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.send,
                            color:
                                _selectedIndex == 1 ? Colors.blue : Colors.grey,
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) => setState(() => this.text = text),
        onListening: (isMicActive) {
          setState(() => this.isMicActive = isMicActive);
          if (!isMicActive) {
            Future.delayed(const Duration(seconds: 1), () {
              Utils.textScan(text);
            });
          }
        },
      );
}
