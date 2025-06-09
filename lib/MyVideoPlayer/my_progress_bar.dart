import 'package:flutter/material.dart';

class MyProgressBar extends StatelessWidget {
  const MyProgressBar(
      {super.key,
      required this.width,
      required this.maxValue,
      required this.currentPosition,
      required this.onChanged,
      this.bufferedPosition,
      this.onChangeStart,
      this.onChangeEnd,
      this.bufferedColor = Colors.grey,
      this.progressColor = Colors.blue,
      this.thumbColor = const Color.fromRGBO(13, 71, 161, 1),
      this.thumbDiameter = 15,
      this.trackHeight = 10});

  /// [width] Width of the progress bar.
  final double width;

  /// [maxValue] Represents the maximum value the progressbar can have.
  final double maxValue;

  /// [currentPosition] Represents the progressbar's current position.
  final double currentPosition;

  /// [onChanged] Callback function. Called whenever the progressbar's current value gots changed.
  final ValueChanged<double> onChanged;

  /// [onChangeStart] callback function. Called whenever the progressbar's current value starts to be changed.
  /// It only called when the progressbar is dragged.
  final ValueChanged<double>? onChangeStart;

  /// [onChangeEnd] Callback function. Called whenever the progressbar's current value changes ends.
  /// It only called when the progressbar is dragged.
  final ValueChanged<double>? onChangeEnd;

  /// [bufferedPosition] Represents the buffered value.
  final double? bufferedPosition;

  /// [bufferedColor] Buffered area color.
  final Color bufferedColor;

  /// [progressColor] Progress area color.
  final Color progressColor;

  /// [thumbColor] Thumb color.
  final Color thumbColor;

  /// [thumbDiameter] The diameter of the thumb.
  final double thumbDiameter;

  /// [trackHeight] Height of the progress and buffered track
  final double trackHeight;

  @override
  Widget build(BuildContext context) {
    final partition = width / maxValue;

    final top = thumbDiameter / 2 - trackHeight / 2 + 10;

    assert(trackHeight < thumbDiameter,
        'trackHeight: $trackHeight must be less than thumbDiameter : $thumbDiameter');
    assert(currentPosition <= maxValue,
        'Currentposition : $currentPosition is greater than the maxValue');

    return GestureDetector(
      onTapDown: (details) {
        onChanged(((details.localPosition.dx ~/ partition)
                    .clamp(0, maxValue)
                    .toDouble())
                .isFinite
            ? (details.localPosition.dx ~/ partition)
                .clamp(0, maxValue)
                .toDouble()
            : 0.0);
      },
      onHorizontalDragStart: (details) {
        if (onChangeStart != null) {
          onChangeStart!((details.localPosition.dx ~/ partition)
              .clamp(0, maxValue)
              .toDouble());
        }
      },
      onHorizontalDragEnd: (details) {
        if (onChangeEnd != null) {
          onChangeEnd!((details.localPosition.dx ~/ partition)
              .clamp(0, maxValue)
              .toDouble());
        }
      },
      onHorizontalDragUpdate: (details) {
        onChanged((details.localPosition.dx ~/ partition)
            .clamp(0, maxValue)
            .toDouble());
      },
      child: Container(
        width: double.infinity,
        height: thumbDiameter + 20,
        color: Colors.transparent,
        child: Center(
          child: Stack(
            children: [
              Positioned(
                top: top,
                left: 0,
                child: Container(
                  width: width,
                  height: trackHeight,
                  decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(trackHeight / 2)),
                ),
              ),
              if (bufferedPosition != null)
                Positioned(
                  top: top,
                  left: 0,
                  child: Container(
                    width: bufferedPosition! * partition,
                    height: trackHeight,
                    decoration: BoxDecoration(
                        color: bufferedColor,
                        borderRadius: BorderRadius.circular(trackHeight / 2)),
                  ),
                ),
              Positioned(
                top: top,
                left: 0,
                child: Container(
                  width: currentPosition * partition,
                  height: trackHeight,
                  decoration: BoxDecoration(
                      color: progressColor,
                      borderRadius: BorderRadius.circular(trackHeight / 2)),
                ),
              ),
              Positioned(
                top: 10,
                left: currentPosition.isFinite && partition.isFinite
                    ? currentPosition * partition - thumbDiameter / 2
                    : 0.0,
                child: Container(
                  width: thumbDiameter,
                  height: thumbDiameter,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: thumbColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
