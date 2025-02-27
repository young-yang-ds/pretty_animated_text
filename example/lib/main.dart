import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

const _loremText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
const _style = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
);
const letterAnimationDuration = Duration(milliseconds: 500);
const wordAnimationDuration = Duration(milliseconds: 1000);

void main() {
  runApp(
    const MaterialApp(
      home: HomeWidget(),
    ),
  );
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final PageController letterController = PageController();
  final PageController wordController = PageController();
  final pageTransitionDuration = const Duration(milliseconds: 200);
  final curve = Curves.easeInOut;
  int selectedValue = 0;
  final int length = 12;
  final GlobalKey<SpringTextState> springTextKey = GlobalKey<SpringTextState>();
  final GlobalKey<ChimeBellTextState> chimbellTextKey =
      GlobalKey<ChimeBellTextState>();
  final GlobalKey<ScaleTextState> scaleTextKey = GlobalKey<ScaleTextState>();
  final GlobalKey<BlurTextState> blurTextKey = GlobalKey<BlurTextState>();
  final GlobalKey<RotateTextState> rotateTextKey = GlobalKey<RotateTextState>();
  final GlobalKey<RotateTextState> rotateTextAntiKey =
      GlobalKey<RotateTextState>();
  final GlobalKey<OffsetTextState> offsetTextTBKey =
      GlobalKey<OffsetTextState>();
  final GlobalKey<OffsetTextState> offsetTextBTKey =
      GlobalKey<OffsetTextState>();
  final GlobalKey<OffsetTextState> offsetTextAlternateTBKey =
      GlobalKey<OffsetTextState>();
  final GlobalKey<OffsetTextState> offsetTextLRKey =
      GlobalKey<OffsetTextState>();
  final GlobalKey<OffsetTextState> offsetTextRLKey =
      GlobalKey<OffsetTextState>();
  final GlobalKey<OffsetTextState> offsetTextAlternateLRKey =
      GlobalKey<OffsetTextState>();
  @override
  void dispose() {
    letterController.dispose();
    wordController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  void _previousPage() {
    if (selectedValue == 0) {
      letterController.previousPage(
        duration: pageTransitionDuration,
        curve: curve,
      );
    } else {
      wordController.previousPage(
        duration: pageTransitionDuration,
        curve: curve,
      );
    }
  }

  void _nextPage() {
    if (selectedValue == 0) {
      letterController.nextPage(
        duration: pageTransitionDuration,
        curve: curve,
      );
    } else {
      wordController.nextPage(
        duration: pageTransitionDuration,
        curve: curve,
      );
    }
  }

  int get currentLetterPage => letterController.page?.round() ?? 0;
  int get currentWordPage => wordController.page?.round() ?? 0;

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pretty Animated Text'),
          actions: [
            IconButton(
              key: const ValueKey('pub.dev'),
              onPressed: () => _launchUrl(
                'https://pub.dev/packages/pretty_animated_text',
              ),
              icon: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset('assets/pub.png')),
            ),
            const SizedBox(height: 8),
            IconButton(
              key: const ValueKey('github'),
              onPressed: () => _launchUrl(
                'https://github.com/YeLwinOo-Steve/pretty_animated_text',
              ),
              icon: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset('assets/github.png')),
            ),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  key: const ValueKey('repeat'),
                  onPressed: () => switch (selectedValue) {
                    0 => _restartAnimation(currentLetterPage),
                    _ => _restartAnimation(currentWordPage),
                  },
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(height: 4),
                FloatingActionButton(
                  key: const ValueKey('pause'),
                  onPressed: () => switch (selectedValue) {
                    0 => _pauseAnimation(currentLetterPage),
                    _ => _pauseAnimation(currentWordPage),
                  },
                  child: const Icon(Icons.pause),
                ),
                const SizedBox(height: 4),
                FloatingActionButton(
                  key: const ValueKey('play'),
                  onPressed: () => switch (selectedValue) {
                    0 => _playAnimation(currentLetterPage),
                    _ => _playAnimation(currentWordPage),
                  },
                  child: const Icon(Icons.play_arrow),
                ),
              ],
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _tabs(),
              if (selectedValue == 0) ...[
                Expanded(
                  flex: 9,
                  child: PageView(
                    controller: letterController,
                    children: [
                      SpringDemo(
                        springTextKey: springTextKey,
                      ),
                      ChimeBellDemo(
                        chimbellTextKey: chimbellTextKey,
                      ),
                      ScaleTextDemo(
                        scaleTextKey: scaleTextKey,
                      ),
                      RotateTextDemo(
                        rotateTextKey: rotateTextKey,
                      ),
                      RotateTextDemo(
                        rotateTextKey: rotateTextAntiKey,
                        direction: RotateAnimationType.anticlockwise,
                      ),
                      BlurTextDemo(
                        blurTextKey: blurTextKey,
                      ),
                      OffsetTextDemo(
                        offsetTextKey: offsetTextTBKey,
                      ),
                      OffsetTextDemo(
                        offsetTextKey: offsetTextBTKey,
                        slideType: SlideAnimationType.bottomTop,
                      ),
                      OffsetTextDemo(
                        offsetTextKey: offsetTextAlternateTBKey,
                        slideType: SlideAnimationType.alternateTB,
                      ),
                      OffsetTextDemo(
                        offsetTextKey: offsetTextLRKey,
                        slideType: SlideAnimationType.leftRight,
                      ),
                      OffsetTextDemo(
                        offsetTextKey: offsetTextRLKey,
                        slideType: SlideAnimationType.rightLeft,
                      ),
                      OffsetTextDemo(
                        offsetTextKey: offsetTextAlternateLRKey,
                        slideType: SlideAnimationType.alternateLR,
                      ),
                    ],
                  ),
                ),
                _pageIndicator(letterController),
              ] else ...[
                Expanded(
                  flex: 9,
                  child: PageView(
                    controller: wordController,
                    children: [
                      SpringDemo(
                        springTextKey: springTextKey,
                        type: AnimationType.word,
                        duration: wordAnimationDuration,
                      ),
                      ChimeBellDemo(
                        chimbellTextKey: chimbellTextKey,
                        type: AnimationType.word,
                        duration: wordAnimationDuration,
                      ),
                      ScaleTextDemo(
                        scaleTextKey: scaleTextKey,
                        type: AnimationType.word,
                        duration: wordAnimationDuration,
                      ),
                      RotateTextDemo(
                        rotateTextKey: rotateTextKey,
                        type: AnimationType.word,
                        duration: wordAnimationDuration,
                      ),
                      RotateTextDemo(
                        rotateTextKey: rotateTextAntiKey,
                        type: AnimationType.word,
                        direction: RotateAnimationType.anticlockwise,
                        duration: wordAnimationDuration,
                      ),
                      BlurTextDemo(
                        blurTextKey: blurTextKey,
                        type: AnimationType.word,
                        duration: wordAnimationDuration,
                      ),
                      OffsetTextDemo(
                        offsetTextKey: offsetTextTBKey,
                        type: AnimationType.word,
                        duration: wordAnimationDuration,
                      ),
                      OffsetTextDemo(
                        offsetTextKey: offsetTextBTKey,
                        type: AnimationType.word,
                        slideType: SlideAnimationType.bottomTop,
                        duration: wordAnimationDuration,
                      ),
                      OffsetTextDemo(
                        offsetTextKey: offsetTextAlternateTBKey,
                        type: AnimationType.word,
                        slideType: SlideAnimationType.alternateTB,
                        duration: wordAnimationDuration,
                      ),
                      OffsetTextDemo(
                        offsetTextKey: offsetTextLRKey,
                        type: AnimationType.word,
                        slideType: SlideAnimationType.leftRight,
                        duration: wordAnimationDuration,
                      ),
                      OffsetTextDemo(
                        offsetTextKey: offsetTextRLKey,
                        type: AnimationType.word,
                        slideType: SlideAnimationType.rightLeft,
                        duration: wordAnimationDuration,
                      ),
                      OffsetTextDemo(
                        offsetTextKey: offsetTextAlternateLRKey,
                        type: AnimationType.word,
                        slideType: SlideAnimationType.alternateLR,
                        duration: wordAnimationDuration,
                      ),
                    ],
                  ),
                ),
                _pageIndicator(wordController),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _playAnimation(int page) => switch (page) {
        0 => springTextKey.currentState?.playAnimation(),
        1 => chimbellTextKey.currentState?.playAnimation(),
        2 => scaleTextKey.currentState?.playAnimation(),
        3 => rotateTextKey.currentState?.playAnimation(),
        4 => rotateTextAntiKey.currentState?.playAnimation(),
        5 => blurTextKey.currentState?.playAnimation(),
        6 => offsetTextTBKey.currentState?.playAnimation(),
        7 => offsetTextBTKey.currentState?.playAnimation(),
        8 => offsetTextAlternateTBKey.currentState?.playAnimation(),
        9 => offsetTextLRKey.currentState?.playAnimation(),
        10 => offsetTextRLKey.currentState?.playAnimation(),
        11 => offsetTextAlternateLRKey.currentState?.playAnimation(),
        _ => () {},
      };

  void _pauseAnimation(int page) => switch (page) {
        0 => springTextKey.currentState?.pauseAnimation(),
        1 => chimbellTextKey.currentState?.pauseAnimation(),
        2 => scaleTextKey.currentState?.pauseAnimation(),
        3 => rotateTextKey.currentState?.pauseAnimation(),
        4 => rotateTextAntiKey.currentState?.pauseAnimation(),
        5 => blurTextKey.currentState?.pauseAnimation(),
        6 => offsetTextTBKey.currentState?.pauseAnimation(),
        7 => offsetTextBTKey.currentState?.pauseAnimation(),
        8 => offsetTextAlternateTBKey.currentState?.pauseAnimation(),
        9 => offsetTextLRKey.currentState?.pauseAnimation(),
        10 => offsetTextRLKey.currentState?.pauseAnimation(),
        11 => offsetTextAlternateLRKey.currentState?.pauseAnimation(),
        _ => () {},
      };
  void _restartAnimation(int page) => switch (page) {
        0 => springTextKey.currentState?.restartAnimation(),
        1 => chimbellTextKey.currentState?.restartAnimation(),
        2 => scaleTextKey.currentState?.restartAnimation(),
        3 => rotateTextKey.currentState?.restartAnimation(),
        4 => rotateTextAntiKey.currentState?.restartAnimation(),
        5 => blurTextKey.currentState?.restartAnimation(),
        6 => offsetTextTBKey.currentState?.restartAnimation(),
        7 => offsetTextBTKey.currentState?.restartAnimation(),
        8 => offsetTextAlternateTBKey.currentState?.restartAnimation(),
        9 => offsetTextLRKey.currentState?.restartAnimation(),
        10 => offsetTextRLKey.currentState?.restartAnimation(),
        11 => offsetTextAlternateLRKey.currentState?.restartAnimation(),
        _ => () {},
      };

  Widget _pageIndicator(PageController controller) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: SmoothPageIndicator(
              controller: controller,
              count: length,
              effect: ScrollingDotsEffect(
                activeDotColor: Colors.indigo,
                dotColor: Colors.indigo.withOpacity(0.42),
                dotHeight: 8,
                dotWidth: 8,
              ),
              onDotClicked: (index) {
                controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                key: const ValueKey('previous'),
                onPressed: _previousPage,
                child: const Icon(Icons.arrow_back_ios_new),
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                key: const ValueKey('next'),
                onPressed: _nextPage,
                child: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _tabs() {
    return SizedBox(
      width: double.maxFinite,
      child: CupertinoSegmentedControl<int>(
        children: const {
          0: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text('Letters'),
          ),
          1: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text('Words'),
          ),
        },
        groupValue: selectedValue,
        onValueChanged: (int value) {
          setState(() {
            selectedValue = value;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (selectedValue == 0) {
              letterController.jumpToPage(0);
            } else {
              wordController.jumpToPage(0);
            }
          });
        },
      ),
    );
  }
}

class ChimeBellDemo extends StatelessWidget {
  final AnimationType type;
  final Duration duration;
  final GlobalKey? chimbellTextKey;
  const ChimeBellDemo({
    super.key,
    this.chimbellTextKey,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ChimeBellText(
        key: chimbellTextKey,
        text: _loremText,
        duration: duration,
        type: type,
        textStyle: _style,
      ),
    );
  }
}

class SpringDemo extends StatelessWidget {
  final AnimationType type;
  final GlobalKey? springTextKey;
  final Duration duration;
  const SpringDemo({
    super.key,
    this.springTextKey,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpringText(
        key: springTextKey,
        text: _loremText,
        duration: duration,
        type: type,
        textStyle: _style,
      ),
    );
  }
}

class ScaleTextDemo extends StatelessWidget {
  final AnimationType type;
  final Duration duration;
  final GlobalKey? scaleTextKey;
  const ScaleTextDemo({
    super.key,
    this.scaleTextKey,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleText(
        key: scaleTextKey,
        text: _loremText,
        duration: duration,
        type: type,
        textStyle: _style,
      ),
    );
  }
}

class RotateTextDemo extends StatelessWidget {
  final AnimationType type;
  final GlobalKey? rotateTextKey;
  final RotateAnimationType direction;
  final Duration duration;
  const RotateTextDemo({
    super.key,
    this.rotateTextKey,
    this.direction = RotateAnimationType.clockwise,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotateText(
        key: rotateTextKey,
        text: _loremText,
        direction: direction,
        duration: duration,
        type: type,
        textStyle: _style,
      ),
    );
  }
}

class BlurTextDemo extends StatelessWidget {
  final AnimationType type;
  final Duration duration;
  final GlobalKey? blurTextKey;
  const BlurTextDemo({
    super.key,
    this.blurTextKey,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlurText(
        key: blurTextKey,
        text: _loremText,
        duration: duration,
        type: type,
        textStyle: _style,
      ),
    );
  }
}

class OffsetTextDemo extends StatelessWidget {
  final GlobalKey? offsetTextKey;
  final AnimationType type;
  final SlideAnimationType slideType;
  final Duration duration;
  const OffsetTextDemo({
    super.key,
    this.offsetTextKey,
    this.type = AnimationType.letter,
    this.slideType = SlideAnimationType.topBottom,
    this.duration = letterAnimationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OffsetText(
        key: offsetTextKey,
        text: _loremText,
        duration: duration,
        type: type,
        slideType: slideType,
        textStyle: _style,
      ),
    );
  }
}
