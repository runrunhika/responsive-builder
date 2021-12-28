import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

final lstPic =
    List.generate(24, (index) => 'https://picsum.photos/300/300?random=$index');

void main() {
  runApp(DevicePreview(enabled: !kReleaseMode, builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: ResponsiveBuilder(
        builder: (context, sizeInfo) {
          return gridViewBaseOnDeviceType(sizeInfo);
        },
      ),
    ));
  }
}

class gridViewBaseOnDeviceType extends StatelessWidget {
  late SizingInformation sizeInfo;
  gridViewBaseOnDeviceType(this.sizeInfo);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemBuilder: (context, index) => CachedNetworkImage(
        imageUrl: lstPic[index],
        imageBuilder: (context, provider) => Container(
          decoration: BoxDecoration(
              image: DecorationImage(image: provider, fit: BoxFit.cover)),
        ),
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, err) => Icon(Icons.error),
      ),
      itemCount: lstPic.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: sizeInfo.deviceScreenType == DeviceScreenType.desktop
              ? 6
              : sizeInfo.deviceScreenType == DeviceScreenType.tablet
                  ? 3
                  : sizeInfo.deviceScreenType == DeviceScreenType.watch
                      ? 1
                      : 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<SizingInformation>('sizeInfo', sizeInfo));
    properties
        .add(DiagnosticsProperty<SizingInformation>('sizeInfo', sizeInfo));
  }
}
