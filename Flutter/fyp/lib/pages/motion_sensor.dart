import 'package:flutter/material.dart';

class MotionSensor extends StatefulWidget {
  const MotionSensor({super.key});

  @override
  State<MotionSensor> createState() => _MotionSensorState();
}

class _MotionSensorState extends State<MotionSensor> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Motion Sensor'));
  }
}
