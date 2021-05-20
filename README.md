# GetX Gallery

GG is a Android Gallery based on GetX(woah). It is mostly training project.

## Core packages
- GetX
- Hive
- Photo View

## Feature
 - Indexing all images(gif, jpeg, jpg, tiff, png, webp, bmp) on device. Actualize them on every launch.
 - Horizontal folder structure(by now)
 - Image thumbnailing, sorting, different grid size

## Build
To build this properly you will need to comment assertion in [Hero] class.
```sh
context.findAncestorWidgetOfExactType<Hero>() == null
```
The error, that this assertion prevent, cant happening with current architecture. Hero keys on Folder and Image level will always be different.

[//]: #
   [GetX]: <https://pub.dev/packages/get>
   [Photo View]: <https://pub.dev/packages/photo_view>
   [Hive]: <https://pub.dev/packages/hive>
   [Hero]: <https://api.flutter.dev/flutter/widgets/Hero-class.html>
