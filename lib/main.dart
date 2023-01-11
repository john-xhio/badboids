import 'dart:math';
import 'dart:ui';

import 'package:boids/boids.dart';
import 'package:boids/display.dart';
import 'package:boids/sandbox.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import 'camera.dart';
import 'view.dart';

void main() {
  print('hello');
  final myGame = MyGame();
  runApp(
    GameWidget(
      game: myGame,
    ),
  );
}


class MyGame extends Component with Game, PanDetector {
  View view = View();
  Matrix4 cview = Matrix4.zero();
  Vector3 target = Vector3(-00, -00, 0);
  Vector3 pos = Vector3(500,500,000);

  MyGame();

  onGameResize(Vector2 size) {
    super.onGameResize(size);
    g_Display.dimensions.setFrom(size);
    setMounted();
  }

  void onPanUpdate(DragUpdateInfo details) {
    pos.x += details.delta.global.x * 10;
    pos.y += details.delta.global.x * 10;
  }

  final N = 000;

  @override
  Future<void>? onLoad() {
   add(Sandbox(this));
   // add(CameraWedge(this));
    final List<Boid> boids = [];
    for (int i = 0; i < N; i++) {
      boids.add(Boid(this));
    }

    boids.forEach((b) {
      b.behavior = Behavior(b, boids);
       add(b);
    });

    return super.onLoad();
  }

  @override
  onMount() {

  }
  double theta = 0;
  @override
  void update(double dt) {
    lifecycle.processQueues();
    children.updateComponentList();
    final bds = children.whereType<Boid>();
    if (bds.isNotEmpty) {
      Boid camBoid = bds.first;
      Boid targetBoid = bds.last;;
    //pos = camBoid.pos - camBoid.velocity.normalized() * 50;
      //target = targetBoid.pos;




    }

    view.update(pos, target);

    theta += .010;
    pos.x =  500 * cos(theta);
    pos.z =  500 * sin(theta);
    pos.y = 000;
    children.forEach((c) => c.update(dt));
  }

  @override
  void render(Canvas canvas) {
    view.prepareFrame();
    children.forEach((c) => c.render(canvas));

    view.renderFrame(canvas);
  }
}




