import 'package:flutter/material.dart';
import 'package:progress_animation_builder/progress_animation_builder.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const _Home(),
    );
  }
}

class _Home extends StatefulWidget {
  const _Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  var _isInitial = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ProgressAnimationBuilder(
            value: _isInitial ? 0 : 1,
            duration: Duration(milliseconds: 1000),
            curve: Curves.slowMiddle,
            builder: (context, animation) {
              return Column(
                children: <Widget>[
                  AnimatedIcon(
                    size: MediaQuery.of(context).size.width * 3 / 4,
                    icon: AnimatedIcons.play_pause,
                    progress: animation,
                  ),
                  AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Slider(
                        value: animation.value.clamp(0, 1).toDouble(),
                        onChanged: null,
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _isInitial = !_isInitial),
        child: Icon(Icons.refresh),
      ),
    );
  }
}
