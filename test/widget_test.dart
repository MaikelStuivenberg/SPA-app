import 'package:flutter_test/flutter_test.dart';
import 'package:spa_app/domain/entities/photo.dart';

void main() {
  test('Photo copyWith updates likes immutably', () {
    const photo = Photo(
      id: '1',
      url: 'url',
      thumbnailUrl: 'thumb',
      likes: 2,
      likedBy: ['a'],
    );

    final updated = photo.copyWith(likes: 3, likedBy: ['a', 'b']);

    expect(photo.likes, 2);
    expect(updated.likes, 3);
    expect(updated.likedBy, ['a', 'b']);
  });
}
