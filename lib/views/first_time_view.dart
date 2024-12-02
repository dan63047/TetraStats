import 'package:flutter/material.dart';
import 'package:tetra_stats/gen/strings.g.dart';

class FirstTimeView extends StatefulWidget {
  /// The very first view, that user see when he launch this programm.
  const FirstTimeView({super.key});

  @override
  State<FirstTimeView> createState() => _FirstTimeState();
}

class _FirstTimeState extends State<FirstTimeView> with SingleTickerProviderStateMixin {
  late AnimationController _transition;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    _transition = AnimationController(vsync: this, duration: Durations.long4);

    _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _transition,
    curve: Curves.elasticIn,
  ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TweenAnimationBuilder(
          duration: Durations.long4,
          tween: Tween<double>(begin: 0, end: 1),
          curve: Easing.standard,
          builder: (context, value, child) {
            return Container(
              transform: Matrix4.translationValues(0, 600-value*600, 0),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(t.firstTimeView.welcome, style: Theme.of(context).textTheme.titleLarge),
                Text(t.firstTimeView.description),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(t.firstTimeView.nicknameQuestion, style: Theme.of(context).textTheme.titleSmall),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: SizedBox(width: 400.0, child: TextField(
                              maxLength: 16,
                              decoration: InputDecoration(
                                hintText: t.firstTimeView.inpuntHint,
                                counter: const Offstage()
                              ),
                            )),
                          ),
                          ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.subdirectory_arrow_left), label: Text("Submit"))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
            )
        ),
      ),
    );
  }
  
}