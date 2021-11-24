// ignore_for_file: file_names
// ignore_for_file: prefer_const_constructors_in_immutables

import '../export.dart';

class AnimatedFab extends StatefulWidget {
  final double buttonSize;
  final Color buttonColor;
  final List<IconData> listOfIcons;
  final List<String> listOfText;
  final void Function(int) onPressed;
  AnimatedFab(
      {required this.listOfIcons, required this.onPressed, this.listOfText = const [], this.buttonColor = ThemeColor.main, this.buttonSize = 50});
  @override
  _AnimatedFabState createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab> with SingleTickerProviderStateMixin {
  bool isOpen = false;
  AnimationController? _animationController;
  //Animation<Color>? _buttonColor;
  Animation<double>? _animateIcon;
  Animation<double>? _translateButton;
  final Curve _curve = Curves.easeOut;
  bool showText = false;

  @override
  initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController!);
    /*_buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    )) as Animation<Color>?;*/
    _translateButton = Tween<double>(
      begin: widget.buttonSize,
      end: -20,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Interval(
        0.0,
        0.6,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpen) {
      setState(() {
        showText = true;
      });
      _animationController!.forward();
    } else {
      _animationController?.reverse();
      setState(() {
        showText = false;
      });
    }
    isOpen = !isOpen;
  }

  Widget get toggle => InkWell(
        onTap: animate,
        child: Container(
          margin: EdgeInsets.all(3),
          height: 56,
          width: 56,
          decoration: BoxDecoration(
              color: widget.buttonColor,
              border: Border.all(color: widget.buttonColor),
              borderRadius: BorderRadius.circular(28),
              boxShadow: ProXShadow),
          child: Center(
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _animateIcon!,
              color: Colors.white,
              size: 32
            ),
          ),
        ),
      );

  List<Widget> floatingList() {
    List<Widget> list = [];
    for (var i = 0; i < widget.listOfIcons.length; i++) {
      int multipleValue = widget.listOfIcons.length - i;
      print('multipleValue: $multipleValue');
      list.add(Transform(
        transform: Matrix4.translationValues(
          0.0,
          _translateButton!.value * (multipleValue) + 6,
          0.0,
        ),
        child: InkWell(
            onTap: () async {
              animate();
              await Future.delayed(Duration(milliseconds: 350));
              widget.onPressed(multipleValue - 1);
            },
            child: AnimatedOpacity(
              opacity: showText ? 1 : 0,
              duration: Duration(milliseconds: showText ? 300 : 500),
              child: Row(children: [
                Text(widget.listOfText[multipleValue - 1], maxLines: 1, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Container(
                  height: widget.buttonSize,
                  width: widget.buttonSize,
                  decoration: BoxDecoration(
                      color: ThemeColor.main,
                      borderRadius: BorderRadius.circular(
                        widget.buttonSize / 2,
                      )),
                  child: Icon(widget.listOfIcons[multipleValue - 1], color: Colors.white, size: 32),
                ),
                SizedBox(width: 6)
              ]),
            )),
      ));
    }
    list.add(toggle);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: floatingList(),
    );
  }
}
