import 'dart:async';

import '../core/utils/app_logger.dart';

/// Mixin providing proper disposal patterns for singleton managers.
/// 
/// This mixin ensures that managers can be properly disposed of to prevent
/// memory leaks, especially in scenarios where singletons need to be reset
/// or when the app is being shut down.
mixin DisposableManagerMixin {
  bool _disposed = false;
  final List<StreamSubscription> _subscriptions = [];
  final List<Timer> _timers = [];
  
  /// Whether this manager has been disposed.
  bool get disposed => _disposed;
  
  /// Adds a stream subscription to be cancelled on disposal.
  void addSubscription(StreamSubscription subscription) {
    if (_disposed) {
      subscription.cancel();
      return;
    }
    _subscriptions.add(subscription);
  }
  
  /// Adds a timer to be cancelled on disposal.
  void addTimer(Timer timer) {
    if (_disposed) {
      timer.cancel();
      return;
    }
    _timers.add(timer);
  }
  
  /// Removes and cancels a stream subscription.
  void removeSubscription(StreamSubscription subscription) {
    if (_subscriptions.remove(subscription)) {
      subscription.cancel();
    }
  }
  
  /// Removes and cancels a timer.
  void removeTimer(Timer timer) {
    if (_timers.remove(timer)) {
      timer.cancel();
    }
  }
  
  /// Throws an error if the manager has been disposed.
  void checkNotDisposed(String managerName) {
    if (_disposed) {
      throw StateError('$managerName has been disposed and cannot be used');
    }
  }
  
  /// Disposes all resources managed by this mixin.
  /// 
  /// Subclasses should call this from their dispose() method.
  void disposeResources(String managerName) {
    if (_disposed) return;
    
    AppLogger.info('$managerName disposing resources...', context: managerName);
    
    _disposed = true;
    
    // Cancel all stream subscriptions
    for (final subscription in _subscriptions) {
      try {
        subscription.cancel();
      } catch (error) {
        AppLogger.warning('Error cancelling subscription: $error', context: managerName);
      }
    }
    _subscriptions.clear();
    
    // Cancel all timers
    for (final timer in _timers) {
      try {
        timer.cancel();
      } catch (error) {
        AppLogger.warning('Error cancelling timer: $error', context: managerName);
      }
    }
    _timers.clear();
    
    AppLogger.success('$managerName resources disposed', context: managerName);
  }
}