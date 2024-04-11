import 'package:flutter/widgets.dart';

/// Wrap your root App widget in this widget and call [DemoGeofence.rebirth] to restart your app.
class DemoGeofence extends StatefulWidget {
  final Widget child;

  DemoGeofence({Key? key, required this.child}) : super(key: key);

  @override
  _DemoGeofenceState createState() => _DemoGeofenceState();

  static rebirth(BuildContext context) {
    context.findAncestorStateOfType<_DemoGeofenceState>()!.restartApp();
  }
}

class _DemoGeofenceState extends State<DemoGeofence> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}
