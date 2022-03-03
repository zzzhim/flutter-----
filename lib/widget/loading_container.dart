// lottie动画加载进度条
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool cover;

  const LoadingContainer({
    Key? key,
    required this.isLoading,
    required this.child,
    this.cover = false,
  }) : super(key: key);

  Widget get _loadingView {
    return Center(
      child: Lottie.asset('lottie/loading.json'),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cover) {
      return Stack(
        children: [
          child,
          isLoading ? _loadingView : Container(),
        ],
      );
    } else {
      return isLoading ? _loadingView : child;
    }
  }
}
