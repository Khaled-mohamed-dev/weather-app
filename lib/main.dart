import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/home_provider.dart';
import 'package:weather_app/widgets/day_details.dart';
import 'package:weather_app/widgets/hero_widget.dart';
import 'package:weather_app/widgets/search_delegate.dart';

import 'constants.dart';
import 'models.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      lazy: false,
      create: (BuildContext context) => HomeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeProvider>(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "${provider.location.name},${provider.location.country}",
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomeSearchDelegate(provider.changeLocation),
              );
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: provider.future,
        builder: (context, AsyncSnapshot<ApiHit?> snapshot) {
          ApiHit? data = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done &&
              data != null) {
            Daily daily = data.daily!;
            var color =
                Color(colorsForDay[daily.time?[0].weekday] ?? 0xff5D50FE);
            var indexOfCurrentHour = data.hourly?.time?.indexWhere((element) =>
                DateTime.parse(element.replaceFirstMapped(
                    RegExp("(\\.\\d{6})\\d+"), (m) => m[1]!)).hour ==
                DateTime.now().hour);
            var temprature =
                data.hourly?.apparentTemperature?[indexOfCurrentHour ?? 0] ?? 0;
            return Padding(
              padding: const EdgeInsets.all(32.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: size.height * .5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
                        color: color,
                      ),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          const Positioned(
                            top: 30,
                            child: Text(
                              "Today",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 48,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Image.asset(
                              "assets/${imagePerWeathercode[daily.weathercode?[0]]}",
                              height: 150,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "$tempratureº\n",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 64,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "${weatherode[daily.weathercode?[0]]}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * .02,
                    ),
                    SizedBox(
                      height: size.height * .25,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        itemBuilder: ((context, index) {
                          return DayCard(
                            daily: daily,
                            provider: provider,
                            index: index,
                          );
                        }),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/no-connection.png",
                    width: size.width * .5,
                  ),
                  const Text("Check your connection"),
                  SizedBox(height: size.height * .05),
                  MaterialButton(
                    onPressed: () {
                      provider.reload();
                    },
                    padding: const EdgeInsets.all(18),
                    color: Colors.blueAccent,
                    child: const Text(
                      "Reload",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class DayCard extends StatelessWidget {
  const DayCard({
    super.key,
    required this.provider,
    required this.daily,
    required this.index,
  });

  final HomeProvider provider;
  final Daily daily;
  final int index;
  @override
  Widget build(BuildContext context) {
    var color =
        Color(colorsForDay[daily.time?[index + 1].weekday] ?? 0xff5D50FE);
    var day = "${weekdayName[daily.time?[index + 1].weekday]} ";
    var minTemp = "${daily.apparentTemperatureMin?[index + 1]}º ";
    var maxTemp = "${daily.apparentTemperatureMax?[index + 1]}º ";
    var image = "assets/${imagePerWeathercode[daily.weathercode?[index + 1]]}";
    var description = "${weatherode[daily.weathercode?[index + 1]]}";

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            reverseTransitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) {
              final curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: const Interval(0, 0.5),
              );
              return FadeTransition(
                opacity: curvedAnimation,
                child: DayDetails(
                  index: index,
                  color: color,
                  maxTemp: maxTemp,
                  minTemp: minTemp,
                  dayName: day,
                  image: image,
                  description: description,
                  location:
                      "${provider.location.name},${provider.location.country}",
                ),
              );
            },
          ),
        );
      },
      child: Stack(
        children: [
          HeroWidget(
            tag: "tag$index",
            child: Container(
              height: height * .25,
              width: width * .4,
              margin: const EdgeInsetsDirectional.only(end: 0),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: SizedBox(
              width: width * .4,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    HeroWidget(
                      tag: "day$index",
                      child: FittedBox(
                        child: Text(
                          day,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * .02),
                    HeroWidget(
                        tag: "icon$index",
                        child: Image.asset(
                          image != "assets/null" ? image : "assets/sunny.png",
                          height: height * .25 * .3,
                        )),
                    SizedBox(height: height * .02),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          HeroWidget(
                            tag: "min$index",
                            child: Text(
                              minTemp,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          HeroWidget(
                            tag: "max$index",
                            child: Text(
                              maxTemp,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          index == 5
              ? const SizedBox()
              : SizedBox(
                  width: width * .45,
                ),
        ],
      ),
    );
  }
}
