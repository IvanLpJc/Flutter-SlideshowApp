import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:slideshow_app/providers/slider_provider.dart';

class SlidersPage extends StatelessWidget {
  const SlidersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider(
        create: (_) => SliderProvider(),
        child: Scaffold(
          body: Center(
            child: Column(
              children: [
                const Expanded(child: _Slides()),
                _Dots(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int page = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Dot(0),
            _Dot(1),
            _Dot(2),
            _Dot(3),
            _Dot(4),
          ]),
    );
  }
}

class _Dot extends StatelessWidget {
  int index = 0;
  _Dot(this.index);

  @override
  Widget build(BuildContext context) {
    final pageViewIndex = Provider.of<SliderProvider>(context).currentPage;
    return AnimatedContainer(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (pageViewIndex >= index - 0.5 && pageViewIndex < index + 0.5)
            ? Colors.pink[700]
            : Colors.grey,
      ),
      duration: const Duration(milliseconds: 200),
    );
  }
}

class _Slides extends StatefulWidget {
  const _Slides({
    super.key,
  });

  @override
  State<_Slides> createState() => _SlidesState();
}

class _SlidesState extends State<_Slides> {
  final pageViewController = PageController();

  @override
  void initState() {
    pageViewController.addListener(() {
      Provider.of<SliderProvider>(context, listen: false).currentPage =
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
    return PageView(
        controller: pageViewController,
        physics: const BouncingScrollPhysics(),
        children: const [
          _Slide(svg: 'assets/slide-1.svg'),
          _Slide(svg: 'assets/slide-2.svg'),
          _Slide(svg: 'assets/slide-3.svg'),
          _Slide(svg: 'assets/slide-4.svg'),
          _Slide(svg: 'assets/slide-5.svg'),
        ]);
  }
}

class _Slide extends StatelessWidget {
  final String svg;
  const _Slide({super.key, required this.svg});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(30),
        width: double.infinity,
        height: double.infinity,
        child: SvgPicture.asset(svg));
  }
}
