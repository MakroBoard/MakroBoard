import 'package:flutter/material.dart';
import 'package:makro_board_client/models/ViewConfigValue.dart';

class ProgressBarControl extends StatefulWidget {
  final ViewConfigValue minValue;
  final ViewConfigValue maxValue;
  final ViewConfigValue value;

  ProgressBarControl({Key? key, required this.minValue, required this.maxValue, required this.value}) : super(key: key);

  @override
  _ProgressBarControlState createState() => _ProgressBarControlState();
}

class _ProgressBarControlState extends State<ProgressBarControl> {
  @override
  void initState() {
    widget.minValue.addListener(updateProgressBar);
    widget.maxValue.addListener(updateProgressBar);
    widget.value.addListener(updateProgressBar);

    super.initState();
  }

  void updateProgressBar() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.minValue.removeListener(updateProgressBar);
    widget.maxValue.removeListener(updateProgressBar);
    widget.value.removeListener(updateProgressBar);
  }

  @override
  Widget build(BuildContext context) {
    var minValue = widget.minValue.value as int? ?? 0;
    var maxValue = widget.maxValue.value as int? ?? 16000;
    var value = widget.value.value as int? ?? 0;

    var progress = value / (maxValue - minValue);
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              if (minValue != 0)
                SizedBox(
                  width: 100,
                  child: Text(
                    minValue.toString(),
                  ),
                ),
              Expanded(
                child: SizedBox(
                  height: 30,
                  child: Stack(
                    children: [
                      SizedBox.expand(
                        child: LinearProgressIndicator(
                          value: progress,
                        ),
                      ),
                      Center(
                        child: Text(
                          value.toString(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 70,
                child: Text(
                  maxValue.toString(),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
