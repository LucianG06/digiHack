import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(TinderScreen());

class TinderScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find your bestie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: SafeArea(
          child: CardDemo(),
        ),
      ),
    );
  }
}

class CardDemo extends StatefulWidget {
  @override
  CardDemoState createState() => CardDemoState();
}

class CardDemoState extends State<CardDemo> {
  late List<int> data;

  List<int> generateData() => List.generate(5, (i) => i + 1);

  @override
  void initState() {
    data = generateData();
    super.initState();
  }

  Widget card(Widget child) {
    return Card(
      elevation: 8,
      color: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 380,
            height: 400,
            child: SwipeableStack(
              totalCount: data.length,
              itemDistance: 10,
              speed: const Duration(milliseconds: 200),
              position: TopStack(),
              builder: (c, i) {
                final t = data[i];
                return card(
                  Text(
                    '$t',
                    style: TextStyle(fontSize: 150, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                );
              },
              swipedOut: (direction) {
                setState(() {
                  data.removeAt(0);
                });
              },
              swipeCount: 4,
              swipeCountComplete: (number) async {
                await Future.delayed(Duration(seconds: 5));
                setState(() {
                  data.addAll(List.generate(5, (i) => i + 1));
                });
              },
              progress: card(CircularProgressIndicator(
                backgroundColor: Colors.red,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )),
            ),
          ),
        ],
      ),
    );
  }
}

typedef SwipeableStackItemBuilder(BuildContext context, int index);
typedef Future<void> SwipeCountComplete(int number);

abstract class PositionBuilder {
  List<Position> build(double itemDistance, int stackCount);
}

class TopStack extends PositionBuilder {
  @override
  List<Position> build(double itemDistance, int stackCount) {
    final List<Position> positions = [];
    final gap = itemDistance;
    for (var i = 0; i < stackCount; i++) {
      final ri = stackCount - i;
      positions.add(
        Position(
          top: gap * ri,
          right: gap * i,
          bottom: 2 * gap * i,
          left: gap * i,
        ),
      );
    }
    return positions;
  }
}

class BottomStack extends PositionBuilder {
  @override
  List<Position> build(double itemDistance, int stackCount) {
    final List<Position> positions = [];
    final gap = itemDistance;
    for (var i = 0; i < stackCount; i++) {
      final ri = stackCount - i;
      positions.add(
        Position(
          top: 2 * gap * i,
          right: gap * i,
          bottom: gap * ri,
          left: gap * i,
        ),
      );
    }
    return positions;
  }
}

class TopRightStack extends PositionBuilder {
  @override
  List<Position> build(double itemDistance, int stackCount) {
    final List<Position> positions = [];
    final gap = itemDistance;
    for (var i = 0; i < stackCount; i++) {
      final ri = stackCount - i;
      positions.add(
        Position(
          top: gap * ri,
          right: gap * ri,
          bottom: gap * i,
          left: gap * i,
        ),
      );
    }
    return positions;
  }
}

class SwipeableStack extends StatefulWidget {
  final int totalCount;
  final int stackCount;
  final int swipeCount;
  final double itemDistance;
  final Duration speed;
  final SwipedOut swipedOut;
  final SwipeCountComplete swipeCountComplete;
  final SwipeableStackItemBuilder builder;
  final Widget progress;
  final PositionBuilder position;

  SwipeableStack({
    required this.totalCount,
    this.stackCount = 3,
    this.swipeCount = 5,
    required this.swipeCountComplete,
    this.itemDistance = 20.0,
    required this.builder,
    required this.swipedOut,
    this.speed = const Duration(milliseconds: 200),
    required this.progress,
    required this.position,
  });

  @override
  SwipeableStackState createState() => SwipeableStackState();
}

class Position {
  double top = 0;
  double right = 0;
  double bottom = 0;
  double left = 0;


  Position({required this.top, required this.right, required this.bottom, required this.left}) {
    // TODO: implement
    throw UnimplementedError();
  }
}

class SwipeableStackState extends State<SwipeableStack> with SingleTickerProviderStateMixin {
  late int _totalCount;
  int _swipeCount = 0;
  int _swipeCountCompleted = 1;
  List<Position> _positions = [];
  late AnimationController _controller;

  int _visibleTotalCount([Function(int index)? itr]) {
    int count = 0;
    for (int i = 0; i < widget.stackCount; i++) {
      if (i == _totalCount) break;
      itr?.call(i);
      count++;
    }
    return count;
  }

  bool _isLastIndex(int index) => index == (widget.stackCount - 1);

  @override
  void initState() {
    _controller = AnimationController(duration: widget.speed, vsync: this);
    _controller.addListener(() {
      setState(() {});
    });
    _totalCount = widget.totalCount;
    _positions = widget.position?.build(
      widget.itemDistance,
      widget.stackCount,
    ) ??
        TopStack().build(
          widget.itemDistance,
          widget.stackCount,
        );
    super.initState();
  }

  @override
  void didUpdateWidget(SwipeableStack oldWidget) {
    _totalCount = widget.totalCount;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animate() {
    _controller.stop();
    _controller.value = 0.0;
    _controller.forward();
  }

  double anim(BuildContext context, double begin, double end) {
    final size = MediaQuery.of(context).size;
    if (_controller.status == AnimationStatus.forward) {
      return Tween<double>(
        begin: begin ?? size.width,
        end: end,
      )
          .animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeIn),
      )
          .value;
    } else
      return end;
  }

  Widget _animatedPositionedFromIndex(index, Widget child) {
    final p0 = _isLastIndex(index) ? null : _positions[index + 1];
    final p1 = _positions[index];
    return _animatedPositioned(p0!, p1, child);
  }

  Widget _animatedPositioned(Position _p0, Position _p1, Widget child) {
    var p0;
    var p1;
    return Positioned(
      top: anim(context, p0?.top, p1?.top),
      right: anim(context, p0?.right, p1?.right),
      bottom: anim(context, p0?.bottom, p1?.bottom),
      left: anim(context, p0?.left, p1?.left),
      child: child,
    );
  }

  Widget _defWidget(BuildContext context, int index, bool drag) {
    return _animatedPositionedFromIndex(
      index,
      Swiper(
        speed: widget.speed,
        draggable: drag,
        child: widget.builder?.call(context, index) ?? Container(),
        swipedOut: (direction) {
          _animate();
          widget.swipedOut?.call(direction);
          _swipeCount++;
          if (_swipeCount % widget.swipeCount == 0) {
            widget.swipeCountComplete?.call(++_swipeCountCompleted);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> itemWidgets = [];
    _visibleTotalCount((i) {
      itemWidgets.add(
        _defWidget(context, i, i == 0),
      );
    });
    return Stack(
      children: [
        if (itemWidgets.length == 0) _animatedPositionedFromIndex(0, widget.progress ?? Container()),
        ...itemWidgets.reversed.toList(),
      ],
    );
  }
}

enum SwipedDirection { Left, Right, None }

typedef SwipedOut(SwipedDirection direction);

class Swiper extends StatefulWidget {
  final double swipeEdge;
  final SwipedOut swipedOut;
  final Widget child;
  final bool draggable;
  final Duration speed;

  Swiper({
    this.swipeEdge = 40,
    required this.child,
    required this.swipedOut,
    this.draggable = true,
    this.speed = const Duration(milliseconds: 200),
  }) : super(key: UniqueKey());

  @override
  SwiperState createState() => SwiperState();
}

class SwiperState extends State<Swiper> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset>? anim;
  Offset _o = Offset.zero;
  late Offset _end;

  double displacement(double width, double dx) => dx / width * 100;

  @override
  void initState() {
    _controller = AnimationController(duration: widget.speed, vsync: this);
    _controller.addListener(() => setState(() {
      if (anim != null) _o = anim!.value;
    }));
    _controller.addStatusListener((AnimationStatus s) {
      if (s == AnimationStatus.completed && _end != Offset.zero) widget.swipedOut?.call(_swipedDirection);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  SwipedDirection get _swipedDirection {
    if (_end == null) return SwipedDirection.None;
    if (_end.dx > widget.swipeEdge) return SwipedDirection.Right;
    if (_end.dx < widget.swipeEdge)
      return SwipedDirection.Left;
    else
      return SwipedDirection.None;
  }



  Offset? get offset {
    if (_controller.status == AnimationStatus.forward) {
      if (anim == null) {
        anim = Tween<Offset>(begin: _o, end: _end).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInCubic,
          ),
        );
      }

      return anim?.value;
    } else {
      anim = null;
      return _o;
    }
  }

  void _animate() {
    _controller.stop();
    _controller.value = 0.0;
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.draggable) {
      return widget.child ?? Container();
    } else {
      final width = MediaQuery.of(context).size.width;
      return GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _o += details.delta;
          });
        },
        onPanEnd: (_) {
          final dis = displacement(width, _o.dx);
          if (dis.abs() > widget.swipeEdge) {
            _end = _o * 5;
          } else {
            _end = Offset.zero;
          }
          _animate();
        },
        child: Transform.translate(
          offset: offset!,
          child: Transform.rotate(
            angle: (pi / 180.0) * _o.dx / 13,
            child: Transform.scale(
              scale: 1 - ((_o.dx / width) * 0.3).abs(),
              child: widget.child ?? Container(),
            ),
          ),
        ),
      );
    }
  }
}