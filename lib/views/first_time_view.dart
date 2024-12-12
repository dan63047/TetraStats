import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tetra_stats/data_objects/tetrio_player.dart';
import 'package:tetra_stats/gen/strings.g.dart';
import 'package:tetra_stats/main.dart';

class FirstTimeView extends StatefulWidget {
  /// The very first view, that user see when he launch this programm.
  const FirstTimeView({super.key});

  @override
  State<FirstTimeView> createState() => _FirstTimeState();
}

class _FirstTimeState extends State<FirstTimeView> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late final Animation<double> _spinAnimation;
  late Animation<double> _opacity;
  late Animation<double> _enterNicknameOpacity;
  late Animation<double> _transform;
  late Animation<Color?> _badNicknameAnim;
  late Animation<double> _fadeOutOpacity;
  late TextEditingController _controller;
  String title = t.firstTimeView.welcome;
  String subtitle = t.firstTimeView.description;
  String helperText = "";
  String nickname = "";
  double helperTextOpacity = 0;
  bool userSet = false;

  @override
  void initState() {
    _animController = AnimationController(
      vsync: this,
      duration: Durations.extralong2
    );
    _spinAnimation = Tween<double>(
      begin: -0.3,
      end: 0.0000,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Interval(
        0.0,
        0.5,
        curve: Curves.linearToEaseOut,
      )
    ));
    _badNicknameAnim = new ColorTween(
      begin: Colors.redAccent,
      end: Colors.grey,
    ).animate(new CurvedAnimation(
      parent: _animController,
      curve: const Interval(
        0.5,
        0.75,
        curve: Curves.easeInCubic
      ),
    ));
    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(
          0.0,
          0.5,
          curve: Curves.linear,
        ),
      ),
    );
    _enterNicknameOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0
    ).animate(
       CurvedAnimation(
        parent: _animController,
        curve: const Interval(
          0.75,
          0.9,
          curve: Curves.ease,
        ),
      ),
    );
    _transform = Tween<double>(
      begin: 0.0,
      end: 150.0
    ).animate(
       CurvedAnimation(
        parent: _animController,
        curve: const Interval(
          0.75,
          0.9,
          curve: Curves.easeInOut,
        ),
      ),
    );
    _fadeOutOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0
    ).animate(
       CurvedAnimation(
        parent: _animController,
        curve: const Interval(
          0.9,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose(){
    _animController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _setDefaultNickname(String n) async {
    setState((){ 
      helperTextOpacity = 1;
      _animController.value = 0.75;
      helperText = t.settingsDestination.checking;
    });
    if (n.isNotEmpty) {
      try {
        if (n.length > 16){
          nickname = await teto.getNicknameByID(n);
          await prefs.setString('playerID', n);
        }else{
          TetrioPlayer player = await teto.fetchPlayer(n);
          nickname = player.username;
          await prefs.setString('playerID', player.userId);
          if(!(await teto.isPlayerTracking(player.userId))) await teto.addPlayerToTrack(player);
        }
        await prefs.setString('player', nickname);
        await prefs.setBool("notFirstTime", true);
        helperText = "";
        _animController.animateTo(0.9);
        setState((){
          userSet = true;
          title = "Nice to see you, ${nickname}";
          subtitle = "Let's take a look at your stats...";
        });
        Timer(Duration(seconds: 2), () => _animController.animateTo(1.0, duration: Duration(seconds: 1)));
        Timer(Duration(seconds: 3), () => context.replace("/"));
        return true;
      } catch (e) {
        _animController.value = 0.5;
        _animController.animateTo(0.75, duration: Duration(seconds: 1));
        setState((){
          helperText = t.settingsDestination.noSuchAccount;
        });
        return false;
      }
    } else {
      _animController.value = 0.5;
      _animController.animateTo(0.75, duration: Durations.long1);
      setState((){
        helperText = t.firstTimeView.emptyInputError;
      });
      return false;
    }
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Center(
      child: Container(
        transform: Matrix4.translationValues(0, _transform.value, 0),
        child: Opacity(
          opacity: _fadeOutOpacity.value,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: RotationTransition(
                  turns: _spinAnimation,
                  child: Image.asset("res/icons/app.png", height: 128, opacity: _opacity)
                ),
              ),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              Text(subtitle, style: TextStyle(color: Colors.grey)),
              Opacity(
                opacity: _enterNicknameOpacity.value,
                child: Padding(
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
                            child: SizedBox(width: 400.0, child: Focus(
                              onFocusChange: (value) {
                                setState((){if (value) helperTextOpacity = 0;});
                              },
                              child: TextField(
                                controller: _controller,
                                maxLength: 16,
                                textAlign: TextAlign.center,
                                enabled: !userSet,
                                decoration: InputDecoration(
                                  hintText: t.firstTimeView.inpuntHint,
                                  helper: Opacity(
                                    opacity: helperTextOpacity,
                                    child: Text(helperText, style: TextStyle(fontFamily: "Eurostile Round", color: _badNicknameAnim.value, height: 0.5))
                                  ),
                                  counter: const Offstage()
                                ),
                                onSubmitted: (value) => _setDefaultNickname(value),
                              ),
                            )),
                          ),
                          ElevatedButton.icon(onPressed: !userSet ? () => _setDefaultNickname(_controller.value.text) : null, icon: Icon(Icons.subdirectory_arrow_left), label: Text(t.actions.submit))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(flex: 2),
              TextButton(onPressed: (){ context.replace("/"); }, child: Text(t.firstTimeView.skip))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TweenAnimationBuilder(
          onEnd: (){
            _animController.animateTo(0.75);
          },
          duration: Durations.long4,
          tween: Tween<double>(begin: 0, end: 1),
          curve: Easing.standard,
          builder: (context, value, child) {
            return Container(
              transform: Matrix4.translationValues(0, 600-value*600, 0),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: AnimatedBuilder(
            animation: _animController,
            builder: _buildAnimation
          )
        ),
      ),
    );
  }
  
}