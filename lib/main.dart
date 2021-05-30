import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame_flare/flame_flare.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_controls.dart';

import 'my-game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({Key key}) : super(key: key);
  final game = MyGame();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Container(
                width: 300,
                height: 300,
                child: game.widget,
                alignment: Alignment.topCenter,
              ),
              SizedBox(
                height: 50,
                width: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.blue[300],
                      child: Text('sad'),
                    ),
                    onTap: () {
                      game.minionController.playStand();
                    },
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.blue[300],
                      child: Text('happy'),
                    ),
                    onTap: () {
                      game.minionController.playJump();
                    },
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.blue[300],
                      child: Text('hey'),
                    ),
                    onTap: () {
                      game.minionController.playWave();
                    },
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.blue[300],
                      child: Text('see'),
                    ),
                    onTap: () {
                      game.minionController.playDance();
                    },
                  ),
                ],
              ),
              GotoJump(),
            ],
          ),
        )));
  }
}

class GotoJump extends StatefulWidget {
  GotoJump({Key key}) : super(key: key);

  @override
  _GotoJumpState createState() => _GotoJumpState();
}

class _GotoJumpState extends State<GotoJump> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
        child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.blue[300],
          child: Text('去 rive'),
        ),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TryRive()));
        },
      ),
    );
  }
}

class MyGame extends BaseGame with TapDetector, DoubleTapDetector {
  final paint = Paint()..color = const Color(0xFFE5E5E5E5);
  final List<String> _animations = ['fail', 'success', 'test', 'idel'];
  int _currentAnimation = 0;
  MinionComponent minionComponent;
  MinionController minionController;
  bool loaded = false;

  MyGame() {
    minionController = MinionController();
    minionComponent = MinionComponent(minionController);
    minionComponent.x = 0;
    minionComponent.y = 0;
    add(BGComponent());
    add(minionComponent);
    minionController.playStand();
  }

  // @override
  // bool debugMode() => true;

  @override
  void onTap() {
    minionController.playJump();
  }

  @override
  void onDoubleTap() {
    cycleAnimation();
  }

  void cycleAnimation() {
    if (_currentAnimation == 3) {
      _currentAnimation = 0;
    } else {
      _currentAnimation++;
    }
    minionController.play(_animations[_currentAnimation]);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}

class MinionController extends FlareControls {
  void playStand() {
    play("fail");
  }

  void playDance() {
    play("test");
  }

  void playJump() {
    play("success");
  }

  void playWave() {
    play("idle");
  }
}

class MinionComponent extends FlareActorComponent with Resizable {
  MinionController minionController;

  MinionComponent(this.minionController)
      : super(
          FlareActorAnimation(
            'assets/images/Teddy.flr',
            controller: minionController,
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
          ),
          width: 300,
          height: 300,
        );

  @override
  void render(Canvas c) {
    final rect = Rect.fromLTWH(x, y, width, height);
    final paint = Paint()..color = const Color(0xFFfafbfc);
    c.drawRect(rect, paint);
    super.render(c);
  }

  @override
  void resize(Size size) {
    super.resize(size);

    x = size.width / 2 - width / 2;
    y = size.height / 2 - height / 2;
  }
}

class BGComponent extends Component with Resizable {
  @override
  void render(Canvas c) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..color = const Color(0xFFFFFFFF);
    c.drawRect(rect, paint);
  }

  @override
  void update(double t) {}
}
