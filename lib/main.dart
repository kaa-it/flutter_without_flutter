import 'dart:ui';

void main() {
  window.onBeginFrame = beginFrame;
  window.scheduleFrame();
}

void beginFrame(Duration duration) {
  final pixelRatio = window.devicePixelRatio;
  final size = window.physicalSize / pixelRatio;
  final physicalBounds = Offset.zero & size * pixelRatio;

  final recorder = PictureRecorder();
  final canvas = Canvas(recorder, physicalBounds);
  canvas.scale(pixelRatio, pixelRatio);

  final paint = Paint()..color = Color(0xFFF44336);
  final center = size.center(Offset.zero);
  canvas.drawCircle(center, size.shortestSide / 4, paint);

  final picture = recorder.endRecording();
  final sceneBuilder = SceneBuilder()
  ..pushClipRect(physicalBounds)
  ..addPicture(Offset.zero, picture)
  ..pop();

  window.render(sceneBuilder.build());
}


