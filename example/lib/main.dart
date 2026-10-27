import 'package:material_ui/material_ui.dart';
import 'package:progress_animation_builder/progress_animation_builder.dart';

void main() => runApp(const App());

class const App({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: _Home());
  }
}

class const _Home() extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState() extends State<_Home> {
  var _isInitial = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ProgressAnimationBuilder(
            value: _isInitial ? 0 : 1,
            duration: const Duration(milliseconds: 1000),
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
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
