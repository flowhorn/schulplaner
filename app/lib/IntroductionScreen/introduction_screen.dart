library introduction_screen;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:schulplaner8/IntroductionScreen/intro_button.dart';
import 'package:schulplaner8/IntroductionScreen/intro_content.dart';
import 'package:schulplaner8/IntroductionScreen/intro_page.dart';
import 'package:schulplaner8/IntroductionScreen/page_view_model.dart';

class IntroductionScreen extends StatefulWidget {
  static const Size kProgressSize = Size.fromRadius(5.0);
  static const EdgeInsets kDotsSpacing = EdgeInsets.all(4.0);

  final List<PageViewModel> pages;
  final bool showSkipButton;
  final VoidCallback onDone;
  final ValueChanged<int> onChange;
  final Size progressSizes;
  final EdgeInsets dotsSpacing;
  final bool isProgress;
  final bool freeze;
  final Widget next;
  final Widget done;
  final Widget skip;
  final int animationDuration;
  final int initialPage;

  const IntroductionScreen({
    Key key,
    @required this.pages,
    @required this.onDone,
    @required this.done,
    this.next,
    this.skip,
    this.showSkipButton = false,
    this.onChange,
    this.progressSizes = kProgressSize,
    this.dotsSpacing = kDotsSpacing,
    this.isProgress = true,
    this.freeze = false,
    this.animationDuration = 350,
    this.initialPage = 0,
  })  : assert(pages != null),
        assert(onDone != null),
        assert(done != null),
        assert((skip != null && showSkipButton) || !showSkipButton),
        super(key: key);

  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  PageController _pageController;
  int _currentPage = 0;
  bool _isSkipPressed = false;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    if (widget.pages.isEmpty) {
      throw Exception('You provide at least one page on introduction screen !');
    }
    _currentPage = min(widget.initialPage, widget.pages.length - 1);
    _pageController = PageController(initialPage: _currentPage);
  }

  List<Widget> _buildPages() {
    return widget.pages.map((page) {
      if (page.isDetailed) {
        return IntroPageDetailed(
          bgColor: page.pageColor,
          content: IntroContent(
            title: page.title,
            bodytext: page.bodytext,
            body: page.body,
            footer: page.footer,
            titleStyle: page.titleTextStyle,
            bodyStyle: page.bodyTextStyle,
          ),
        );
      }
      return IntroPage(
        bgColor: page.pageColor,
        image: Center(child: page.image),
        content: IntroContent(
          title: page.title,
          bodytext: page.bodytext,
          body: page.body,
          footer: page.footer,
          titleStyle: page.titleTextStyle,
          bodyStyle: page.bodyTextStyle,
        ),
      );
    }).toList();
  }

  void _onNext() {
    animateScroll(min(_currentPage + 1, widget.pages.length - 1));
  }

  Future<void> _onSkip() async {
    setState(() => _isSkipPressed = true);
    await animateScroll(widget.pages.length - 1);
    setState(() => _isSkipPressed = false);
  }

  Future<void> animateScroll(int page) async {
    setState(() => _isScrolling = true);
    await _pageController.animateToPage(
      page,
      duration: Duration(milliseconds: widget.animationDuration),
      curve: Curves.easeIn,
    );
    setState(() => _isScrolling = false);
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = (_currentPage == widget.pages.length - 1);
    bool isSkipBtn = (!_isSkipPressed && !isLastPage && widget.showSkipButton);
    final page = widget.pages[_currentPage];

    final skipBtn = Opacity(
      opacity: isSkipBtn ? 1.0 : 0.0,
      child: IntroButton(child: widget.skip, onPressed: _onSkip),
    );

    final nextBtn = IntroButton(
      child: widget.next,
      onPressed: _isScrolling ? null : _onNext,
    );

    final doneBtn = IntroButton(
      child: widget.done,
      onPressed: widget.onDone,
    );

    return Scaffold(
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: (widget.freeze)
                    ? const NeverScrollableScrollPhysics()
                    : BouncingScrollPhysics(),
                children: _buildPages(),
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                  if (widget.onChange != null) widget.onChange(index);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Row(
                children: [
                  skipBtn,
                  Expanded(
                    child: Center(
                      child: widget.isProgress
                          ? DotsIndicator(
                              dotsCount: widget.pages.length,
                              position: _currentPage.toDouble(),
                              decorator: DotsDecorator(
                                spacing: widget.dotsSpacing,
                                activeSize: page.progressSize,
                                size: widget.progressSizes,
                                activeColor: page.progressColor,
                              ))
                          : const SizedBox(),
                    ),
                    flex: 36,
                  ),
                  isLastPage ? doneBtn : nextBtn,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
