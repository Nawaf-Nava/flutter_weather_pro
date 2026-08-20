import 'dart:async';
import 'dart:math';

enum ServerConnectionStatus { connected, reconnecting, slow, offline }

class MockServerGateway {
  static final MockServerGateway _instance = MockServerGateway._internal();
  factory MockServerGateway() => _instance;
  MockServerGateway._internal();

  ServerConnectionStatus _status = ServerConnectionStatus.connected;
  int _latencyMs = 24;
  final _random = Random();

  final _statusController = StreamController<ServerConnectionStatus>.broadcast();
  final _latencyController = StreamController<int>.broadcast();

  Stream<ServerConnectionStatus> get statusStream => _statusController.stream;
  Stream<int> get latencyStream => _latencyController.stream;
  ServerConnectionStatus get currentStatus => _status;
  int get currentLatency => _latencyMs;

  /// بدء محاكاة فحص الاتصال التلقائي الدوري (Heartbeat Ping)
  void startHeartbeat() {
    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_status != ServerConnectionStatus.offline) {
        _latencyMs = 20 + _random.nextInt(15);
        _latencyController.add(_latencyMs);
      }
    });
  }

  /// اختبار سرعة استجابة السيرفر فوراً
  Future<int> testPing() async {
    if (_status == ServerConnectionStatus.offline) return -1;

    final stopwatch = Stopwatch()..start();
    await Future.delayed(Duration(milliseconds: 100 + _random.nextInt(120)));
    stopwatch.stop();

    _latencyMs = (stopwatch.elapsedMilliseconds * 0.25).toInt() + 18;
    _latencyController.add(_latencyMs);
    return _latencyMs;
  }

  /// تبديل حالة الاتصال (محاكاة الانقطاع والاتصال)
  void toggleConnection() {
    if (_status == ServerConnectionStatus.offline) {
      _status = ServerConnectionStatus.connected;
    } else {
      _status = ServerConnectionStatus.offline;
    }
    _statusController.add(_status);
  }

  void dispose() {
    _statusController.close();
    _latencyController.close();
  }
}