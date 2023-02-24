import 'package:flutter/material.dart';
import 'hero_widget.dart';

class DayDetails extends StatefulWidget {
  const DayDetails({
    Key? key,
    required this.index,
    required this.color,
    required this.dayName,
    required this.maxTemp,
    required this.minTemp,
    required this.image,
    required this.description,
    required this.location,
  }) : super(key: key);
  final Color color;
  final int index;
  final String dayName, maxTemp, minTemp, image, description, location;
  @override
  State<DayDetails> createState() => _DayDetailsState();
}

class _DayDetailsState extends State<DayDetails> {
  @override
  Widget build(BuildContext context) {
    int index = widget.index;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          widget.location,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          HeroWidget(
            tag: 'tag$index',
            child: Container(
              height: double.infinity,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 50),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  HeroWidget(
                    tag: 'day$index',
                    child: Text(
                      widget.dayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .05,
                  ),
                  HeroWidget(
                    tag: 'icon$index',
                    child: Image.asset(
                      widget.image,
                      height: 200,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      HeroWidget(
                        tag: 'min$index',
                        child: Text(
                          widget.minTemp,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      HeroWidget(
                        tag: 'max$index',
                        child: Text(
                          widget.maxTemp,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .02,
                  ),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 25,
            child: MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              shape: const CircleBorder(),
              color: Colors.white,
              padding: const EdgeInsets.all(15),
              child: const Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }
}
