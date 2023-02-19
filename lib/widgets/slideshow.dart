import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Slideshow extends StatelessWidget {
  final List<Widget> slides;
  final bool? dotsOnTop;
  final Color? selectedPageColor;
  final Color? unselectedPageColor;
  final double? primaryBullet, secondaryBullet;

  const Slideshow(
      {super.key,
      required this.slides,
      this.dotsOnTop = false,
      this.selectedPageColor,
      this.unselectedPageColor,
      this.primaryBullet = 12,
      this.secondaryBullet = 12});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _SlideshowProvider(),
      child: SafeArea(
        child: Builder(builder: (context) {
          Provider.of<_SlideshowProvider>(context).primaryBullet =
              primaryBullet!;
          Provider.of<_SlideshowProvider>(context).secondaryBullet =
              secondaryBullet!;
          Provider.of<_SlideshowProvider>(context).selectedPageColor =
              selectedPageColor ?? Theme.of(context).colorScheme.primary;
          Provider.of<_SlideshowProvider>(context).unselectedPageColor =
              unselectedPageColor ?? Theme.of(context).colorScheme.primary;

          return _MainBody(
            dotsOnTop: dotsOnTop,
            slides: slides,
          );
        }),
      ),
    );
  }
}

class _MainBody extends StatelessWidget {
  const _MainBody({
    super.key,
    required this.dotsOnTop,
    required this.slides,
  });

  final bool? dotsOnTop;
  final List<Widget> slides;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (dotsOnTop!)
          _Dots(
            slides.length,
          ),
        Expanded(child: _Slides(slides)),
        if (!dotsOnTop!)
          _Dots(
            slides.length,
          ),
      ],
    );
  }
}

class _Slides extends StatefulWidget {
  final List<Widget> slides;
  const _Slides(this.slides);

  @override
  State<_Slides> createState() => _SlidesState();
}

class _SlidesState extends State<_Slides> {
  final pageViewController = PageController();

  List<Widget> get slides => widget.slides;

  @override
  void initState() {
    pageViewController.addListener(() {
      Provider.of<_SlideshowProvider>(context, listen: false).currentPage =
          pageViewController.page!;
    });
    super.initState();
  }

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: pageViewController,
        physics: const BouncingScrollPhysics(),
        itemCount: slides.length,
        itemBuilder: (_, index) {
          return _Slide(slides[index]);
        });
  }
}

class _Slide extends StatelessWidget {
  final Widget slide;
  const _Slide(this.slide);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(30),
        width: double.infinity,
        height: double.infinity,
        child: slide);
  }
}

class _Dots extends StatelessWidget {
  final int totalDots;

  _Dots(this.totalDots);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(totalDots, (index) => _Dot(index))),
    );
  }
}

class _Dot extends StatelessWidget {
  int index = 0;
  _Dot(this.index);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<_SlideshowProvider>(context);
    double size;
    Color color;

    if ((provider.currentPage >= index - 0.5 &&
        provider.currentPage < index + 0.5)) {
      size = provider.primaryBullet;
      color = provider.selectedPageColor;
    } else {
      size = provider.secondaryBullet;
      color = provider.unselectedPageColor;
    }
    return AnimatedContainer(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: size,
      width: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      duration: const Duration(milliseconds: 200),
    );
  }
}

class _SlideshowProvider extends ChangeNotifier {
  double _currentPage = 0;

  double _primaryBullet = 12, _secondaryBullet = 12;

  late Color _selectedPageColor = Colors.pink,
      _unselectedPageColor = Colors.grey;

  double get currentPage => _currentPage;

  set currentPage(double page) {
    _currentPage = page;
    notifyListeners();
  }

  double get primaryBullet => _primaryBullet;
  set primaryBullet(double size) {
    _primaryBullet = size;
  }

  double get secondaryBullet => _secondaryBullet;
  set secondaryBullet(double size) {
    _secondaryBullet = size;
  }

  Color get selectedPageColor => _selectedPageColor;
  set selectedPageColor(Color color) {
    _selectedPageColor = color;
  }

  Color get unselectedPageColor => _unselectedPageColor;
  set unselectedPageColor(Color color) {
    _selectedPageColor = color;
  }
}
