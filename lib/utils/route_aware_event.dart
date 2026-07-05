import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// 画面遷移を検知したいときに利用する
class RouteAwareEvent extends RouteAware {
  VoidCallback? onDidPopNext;
  VoidCallback? onDidPop;
  VoidCallback? onDidPushNext;
  VoidCallback? onDidPush;

  @override
  // 一度、別の画面に遷移したあとで、再度この画面に戻ってきた時にコールされる
  void didPopNext() => onDidPopNext?.call();
  @override
  // この画面から別の画面に遷移する (Pop) 場合にコールされる
  void didPop() => onDidPop?.call();
  @override
  // この画面から別の画面をPushする場合にコールされる (この画面はPopされずにそのまま残る場合)
  void didPushNext() => onDidPushNext?.call();
  @override
  // 画面が初めて表示 (Push) される時にコールされる
  void didPush() => onDidPush?.call();
}

// hooks の返り値
enum RouteAwareType {
  didPush,
  didPop,
  didPopNext,
  didPushNext,
}

RouteAwareType? useRouteAwareEvent(RouteObserver routeObserver) {
  return use(_RouteAwareHook(routeObserver));
}

class _RouteAwareHook extends Hook<RouteAwareType?> {
  const _RouteAwareHook(this.routeObserver) : super();
  final RouteObserver routeObserver;

  @override
  __RouteAwareState createState() => __RouteAwareState();
}

class __RouteAwareState extends HookState<RouteAwareType?, _RouteAwareHook> {
  RouteAwareType? _state;
  final aware = RouteAwareEvent();

  @override
  void initHook() {
    super.initHook();
    aware.onDidPop = () => _state = RouteAwareType.didPop;
    aware.onDidPopNext = () => _state = RouteAwareType.didPopNext;
    aware.onDidPush = () => _state = RouteAwareType.didPush;
    aware.onDidPushNext = () => _state = RouteAwareType.didPushNext;
  }

  var firstBuild = true;
  @override
  RouteAwareType? build(BuildContext context) {
    // initHook で context を触るとエラーになるので、ここで初期化する
    // また、ここでは useEffect が使えないので、firstBuild を利用し初回のみ subscribe する
    if (firstBuild) {
      firstBuild = false;
      hook.routeObserver.subscribe(aware, ModalRoute.of(context)!);
    }
    return _state;
  }

  @override
  void dispose() {
    super.dispose();
    hook.routeObserver.unsubscribe(aware);
  }
}
