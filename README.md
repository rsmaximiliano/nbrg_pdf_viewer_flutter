# NBRG PDF viewer for flutter

Android and iOS working pdf viewer!

```markdown
NOTE: This package is a fork of the package provided by [alveliu](https://pub.dev/packages?q=email%3Aalveliu93%40gmail.com) named flutter_full_pdf_viewer which is available [here](https://pub.dev/packages/flutter_full_pdf_viewer). Our package has a bit more features and null-safety along with support for Android Embedding V2. Thank you for using this package.
```

## Use this package as a library

### 1. Depend on it

Add this to your package's pubspec.yaml file:

```dart
dependencies:
  nbrg_pdf_viewer_flutter: ^2.0.0-nullsafety.2
```

### 2. Install it

You can install packages from the command line:

with Flutter:

```yaml
flutter packages get
```

Alternatively, your editor might support pub get or ```flutter packages get```. Check the docs for your editor to learn more.

### 3. Import it

Now in your Dart code, you can use:

```dart
import 'package:nbrg_pdf_viewer_flutter/nbrg_pdf_viewer_flutter.dart';
import 'package:nbrg_pdf_viewer_flutter/nbrg_pdf_viewer_flutter_plugin.dart';
import 'package:nbrg_pdf_viewer_flutter/nbrg_pdf_viewer_flutter_scaffold.dart';
```

### 4. Informations for Release on Android

You have to follow first these steps: <https://flutter.io/docs/deployment/android>
After that you have to add ndk filters to your release config:

```gradle
    buildTypes {

        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            useProguard true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'

            ndk {
                abiFilters 'armeabi-v7a'
            }
        }

        debug {
            minifyEnabled false
            useProguard false
        }
    }

```

Now your release app should work.
