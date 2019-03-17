# rating_bar

A customizable *Rating Bar* for flutter

<!--[![pub package](https://img.shields.io/pub/v/paging.svg?style=popout)](https://pub.dartlang.org/packages/paging)-->

## Installation

Add this to your package's pubspec.yaml file

```yaml
dependencies:
  ...
  paging: ^latest.version.here
```

## Usage
First import paging.dart

```dart
  import 'package:rating_bar/rating_bar.dart';
```
In the `RatingBar` widget `onRatingChanged` callback returns current 
rating which is a double whenever the rating has changed.

```dart
  RatingBar(
    onRatingChanged: (rating) => setState(() => _rating = rating),
    filledIcon: Icons.star,
    emptyIcon: Icons.star_border,
    halfFilledIcon: Icons.star_half,
    isHalfAllowed: true,
    filledColor: Colors.green,
    emptyColor: Colors.redAccent,
    halfFilledColor: Colors.amberAccent, 
    size: 48,
  ),
```

## Screenshots

![](/flutter_01.png)

## License
[MIT License](/LICENSE)