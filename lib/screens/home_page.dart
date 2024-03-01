import 'dart:async';
import 'dart:math';

import 'package:flml_internet_checker/flml_internet_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/api/controller/weather_controller.dart';
import 'package:weather/providers/error_text.dart';
import 'package:weather/providers/loader.dart';
import 'package:weather/utils.dart';

import '../constants/image_constants.dart';
import '../main.dart';

final clickedProvider = StateProvider((ref) {
  return false;
});

final currentPlaceProvider = StateProvider((ref) {
  return currentLocation;
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  TextEditingController placeController = TextEditingController();

  late String image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    image = imageList[Random().nextInt(3)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.all(w * 0.04),
        width: w,
        height: h,
        decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
        child: ref
            .watch(
                fetchDataProvider(ref.watch(currentPlaceProvider).toString()))
            .when(
              data: (data) {
                return data == null
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: h * 0.3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: w * 0.15,
                                  width: w * 0.6,
                                  // color: Colors.red,
                                  child: TextFormField(
                                    controller: placeController,
                                    style: TextStyle(color: Colors.white),
                                    textInputAction: TextInputAction.search,
                                    decoration: const InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white))),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    print(11111111111111);
                                    ref
                                        .read(currentPlaceProvider.notifier)
                                        .state = placeController.text.trim();
                                  },
                                  child: const Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Lottie.asset("assets/img/empty.json")
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: h * 0.15,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                        ),
                                        SizedBox(
                                          width: w * 0.03,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ref
                                                          .read(
                                                              currentPlaceProvider)
                                                          .toString() ==
                                                      ""
                                                  ? currentLocation
                                                  : ref
                                                      .read(
                                                          currentPlaceProvider)
                                                      .toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: w * 0.045),
                                            ),
                                            StreamBuilder(
                                                stream: Stream.periodic(
                                                    const Duration(seconds: 1)),
                                                builder: (context, snapshot) {
                                                  return Text(
                                                    DateFormat(
                                                            "MMM d yyyy hh:mm aaa")
                                                        .format(DateTime.now()
                                                            .toUtc()
                                                            .add(Duration(
                                                                seconds: data
                                                                    .timezone!
                                                                    .toInt()))),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: w * 0.045),
                                                  );
                                                })
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      ref.read(clickedProvider.notifier).state =
                                          !ref.read(clickedProvider);
                                      print("clicked");
                                    },
                                    child: Container(
                                      // color: Colors.red,
                                      width: w * 0.2,
                                      // height: 30,
                                      child: IconButton(
                                        onPressed: () {
                                          ref
                                                  .read(clickedProvider.notifier)
                                                  .state =
                                              !ref.read(clickedProvider);
                                          print("clicked");
                                        },
                                        icon: Icon(Icons.search),
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ref.watch(clickedProvider) == true
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: w * 0.15,
                                        width: w * 0.6,
                                        // color: Colors.red,
                                        child: TextFormField(
                                          controller: placeController,
                                          style: TextStyle(color: Colors.white),
                                          textInputAction:
                                              TextInputAction.search,
                                          decoration: const InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white)),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.white))),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          ref
                                                  .read(currentPlaceProvider
                                                      .notifier)
                                                  .state =
                                              placeController.text.trim();
                                        },
                                        child: const Icon(
                                          Icons.search,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  )
                                : const SizedBox.shrink(),
                            Image.network(
                              "https://openweathermap.org/img/wn/${data!.weather![0].icon}@2x.png",
                            ),
                            SizedBox(
                              height: h * 0.2,
                              width: w * 0.4,
                              // color: Colors.red,
                              child: Column(
                                children: [
                                  Text(
                                    // ("${weatherData?.main?.temp ?? ""}°C").toString(),
                                    " ${data!.main!.temp?.toStringAsFixed(0)}°C",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: w * 0.07,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    data.weather![0].main.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: w * 0.05,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  StreamBuilder(
                                      stream: Stream.periodic(
                                          const Duration(seconds: 1)),
                                      builder: (context, snapshot) {
                                        return Text(
                                          DateFormat("hh:mm:ss a").format(
                                              DateTime.now().toUtc().add(
                                                  Duration(
                                                      seconds: data.timezone!
                                                          .toInt()))),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: w * 0.05,
                                              fontWeight: FontWeight.bold),
                                        );
                                      }),
                                ],
                              ),
                            ),
                            Container(
                              height: h * 0.19,
                              width: w * 0.8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(w * 0.03),
                                  color: Colors.black.withOpacity(0.4)),
                              // color: Colors.red,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: w * 0.15,
                                        width: w * 0.4,
                                        // color: Colors.black,
                                        child: Row(
                                          children: [
                                            Image.asset(
                                                ImageConstants.tempHigh),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Temp Max",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: w * 0.04),
                                                ),
                                                Text(
                                                  "${data.main?.tempMax?.toStringAsFixed(0)}°C",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: w * 0.06),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: w * 0.15,
                                        width: w * 0.4,
                                        // color: Colors.black,
                                        child: Row(
                                          children: [
                                            Image.asset(ImageConstants.tempLow),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Temp Min",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: w * 0.04),
                                                ),
                                                Text(
                                                  "${data.main?.tempMin?.toStringAsFixed(0)}°C",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: w * 0.06),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 1.4,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: w * 0.15,
                                        width: w * 0.4,
                                        // color: Colors.black,
                                        child: Row(
                                          children: [
                                            Container(
                                                width: w * 0.1,
                                                child: Image.asset(
                                                    ImageConstants.sun)),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Sunrise",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: w * 0.04),
                                                ),
                                                Text(
                                                  DateFormat("hh:mm a").format(
                                                      DateTime
                                                          .fromMillisecondsSinceEpoch(
                                                              data.sys!
                                                                      .sunrise! *
                                                                  1000)),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: w * 0.04),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: w * 0.15,
                                        width: w * 0.4,
                                        // color: Colors.black,
                                        child: Row(
                                          children: [
                                            Container(
                                                width: w * 0.1,
                                                child: Image.asset(
                                                    ImageConstants.moon)),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Sunset",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: w * 0.04),
                                                ),
                                                Text(
                                                  DateFormat("hh:mm a").format(
                                                      DateTime
                                                          .fromMillisecondsSinceEpoch(
                                                              data.sys!
                                                                      .sunset! *
                                                                  1000)),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: w * 0.04),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
              },
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => Center(child: Loader()),
            ),
      ),
    );
  }
}
