import 'dart:math';
import 'dart:ui';

void main() {
  window.onBeginFrame = beginFrame;
  window.onPointerDataPacket = pointerDataPacket;
  window.scheduleFrame();
}

Offset? center;
late Offset velocity;
Duration? lastDuration;

void beginFrame(Duration duration) {
  final pixelRatio = window.devicePixelRatio;
  final size = window.physicalSize / pixelRatio;
  final physicalBounds = Offset.zero & size * pixelRatio;

  final recorder = PictureRecorder();
  final canvas = Canvas(recorder, physicalBounds);
  canvas.scale(pixelRatio, pixelRatio);

  final radius = size.shortestSide / 4;

  if (center == null) {
    center = size.center(Offset.zero);
    velocity = Offset(3, 5);
  } else {
    if (center!.dx < radius || center!.dx > size.width - radius) {
      velocity = velocity.scale(-1, 1);
    }

    if (center!.dy < radius || center!.dy > size.height - radius) {
      velocity = velocity.scale(1, -1);
    }

    if (lastDuration != null ) {
      final delta = (duration - lastDuration!).inMilliseconds / 1000;
      center = center! + velocity * delta;
    } else {
      center = center! + velocity;
    }

    lastDuration = duration;
  }

  final paint = Paint()..color = Color(0xFFF44336);

  canvas.drawCircle(center!, radius, paint);

  final picture = recorder.endRecording();
  final sceneBuilder = SceneBuilder()
  ..pushClipRect(physicalBounds)
  ..addPicture(Offset.zero, picture)
  ..pop();

  window.render(sceneBuilder.build());

  window.scheduleFrame();
}

final _random = Random();

void pointerDataPacket(PointerDataPacket packet) {
  for (final data in packet.data) {
    if (data.change == PointerChange.up) {
      velocity = Offset.fromDirection(
        _random.nextDouble() * pi * 2,
        _random.nextDouble() * 800 - 400,
      );
    }
  }
}

