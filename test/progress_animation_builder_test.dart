import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:progress_animation_builder/progress_animation_builder.dart';

void main() {
  testWidgets('ProgressAnimationBuilder animates to value', (tester) async {
    var currentValue = 0.0;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: StatefulBuilder(
          builder: (context, setState) {
            return ProgressAnimationBuilder(
              value: currentValue,
              duration: const Duration(milliseconds: 200),
              builder: (context, animation) => AnimatedBuilder(
                animation: animation,
                builder: (context, _) =>
                    Text(animation.value.toStringAsFixed(1)),
              ),
            );
          },
        ),
      ),
    );

    expect(find.text('0.0'), findsOneWidget);

    currentValue = 1.0;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ProgressAnimationBuilder(
          value: currentValue,
          duration: const Duration(milliseconds: 200),
          builder: (context, animation) => AnimatedBuilder(
            animation: animation,
            builder: (context, _) => Text(animation.value.toStringAsFixed(1)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1.0'), findsOneWidget);
  });
}
