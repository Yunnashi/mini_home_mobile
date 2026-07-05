import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_route_observer.g.dart';

@Riverpod(keepAlive: true)
RouteObserver routeObserver(Ref ref) => RouteObserver();
