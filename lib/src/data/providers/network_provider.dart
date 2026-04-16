import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_provider.g.dart';

/// Provides a global reactive stream of network connection states.
/// Returns a [List<ConnectivityResult>] mapping current active connections.
@Riverpod(keepAlive: true)
Stream<List<ConnectivityResult>> connectivityStream(ConnectivityStreamRef ref) {
  return Connectivity().onConnectivityChanged;
}

/// A simplified synchronous provider mapping [ConnectivityResult] to a boolean.
/// Evaluates true if network is online (WiFi, Mobile, Vpn, Ethernet), false if entirely none.
@Riverpod(keepAlive: true)
class NetworkStatus extends _$NetworkStatus {
  @override
  bool build() {
    // Determine the initial synchronous state if feasible, defaulting to true to prevent premature flash
    // Let the stream handle updates. We subscribe to connectivityStream
    ref.listen(connectivityStreamProvider, (_, next) {
      if (next.hasValue) {
        final results = next.value!;
        final isOnline = !results.contains(ConnectivityResult.none) || 
                          results.any((r) => r != ConnectivityResult.none);
        if (state != isOnline) {
          state = isOnline;
        }
      }
    });
    
    return true; 
  }
}
