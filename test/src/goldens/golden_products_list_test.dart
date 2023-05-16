import 'dart:ui';

import 'package:ecommerce_app/src/app.dart';
import 'package:flutter_test/flutter_test.dart';

import '../features/robot.dart';

void main() {
  final sizeVariant = ValueVariant<Size>(
      {const Size(300, 600), const Size(600, 800), const Size(1000, 1000)});
  testWidgets('Golden - product list', (tester) async {
    final r = Robot(tester);
    final currentSize = sizeVariant.currentValue!;
    await r.golden.setSurfaceSize(currentSize);
    await r.golden.loadRobotoFont();
    await r.golden.loadMaterialIconFont();
    await r.pumpMyApp();
    await r.golden.precacheImages();
    await expectLater(
        //Render the content of MyApp() then compare them with a golden file that we have generated in advance.
        find.byType(MyApp),
        matchesGoldenFile(
            'products_list${currentSize.width.toInt()}x${currentSize.height.toInt()}.png'));
  }, variant: sizeVariant, tags: ['golden'], skip: true);
}
