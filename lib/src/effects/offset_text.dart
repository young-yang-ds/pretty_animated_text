import 'package:flutter/material.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';
import 'package:pretty_animated_text/src/constants/constants.dart';
import 'package:pretty_animated_text/src/dto/dto.dart';
import 'package:pretty_animated_text/src/utils/custom_curved_animation.dart';
import 'package:pretty_animated_text/src/utils/interval_step_by_overlap_factor.dart';
import 'package:pretty_animated_text/src/utils/offset_tween_by_slide_type.dart';
import 'package:pretty_animated_text/src/utils/spring_curve.dart';
import 'package:pretty_animated_text/src/utils/text_transformation.dart';
import 'package:pretty_animated_text/src/utils/wrap_alignment_by_text_align.dart';

class OffsetText extends StatefulWidget {
  final String text;

  final AnimationType type;
  final double overlapFactor;
  final TextAlignment textAlignment;
  final SlideAnimationType slideType;
  final Duration duration;
  final TextStyle? textStyle;

  const OffsetText({
    super.key,
    required this.text,
    this.overlapFactor = kOverlapFactor,
    this.textAlignment = TextAlignment.start,
    this.textStyle,
    this.type = AnimationType.word,
    this.slideType = SlideAnimationType.topBottom,
    this.duration = const Duration(milliseconds: 4000),
  });

  @override
  // ignore: library_private_types_in_public_api
  _OffsetTextState createState() => _OffsetTextState();
}

class _OffsetTextState extends State<OffsetText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _offsets;
  late List<Animation<double>> _opacities;
  late final List<EffectDto> _data;

  @override
  void initState() {
    super.initState();
    _data = switch (widget.type) {
      AnimationType.letter => widget.text.splittedLetters,
      _ => widget.text.splittedWords,
    };

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    final wordCount = _data.length;
    final double overlapFactor = widget.overlapFactor;

    final double intervalStep =
        intervalStepByOverlapFactor(wordCount, overlapFactor);

    // Creating the offset animations with staggered delays.
    _offsets = _data
        .map(
          (data) => offsetTweenBySlideType(
            widget.slideType,
            index: data.index,
          ).animate(
            curvedAnimation(
              _controller,
              data.index,
              intervalStep,
              overlapFactor,
              curve: SpringCurve(),
            ),
          ),
        )
        .toList();

    // Create opacity animations with staggered starts
    _opacities = _data.map((data) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            data.index *
                intervalStep *
                overlapFactor, // Start before the previous word animation finishes
            data.index * intervalStep * overlapFactor +
                intervalStep, // Finish at its own step
            curve: Curves.easeIn,
          ),
        ),
      );
    }).toList();

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: wrapAlignmentByTextAlign(widget.textAlignment),
      children: _data
          .map(
            (dto) => AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return _animatedBuilder(dto, child);
              },
              child: Text(
                dto.text,
                style: widget.textStyle,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _animatedBuilder(EffectDto data, Widget? child) {
    return Opacity(
      opacity: _opacities[data.index].value,
      child: Transform.translate(
        offset: _offsets[data.index].value,
        child: child,
      ),
    );
  }
}
