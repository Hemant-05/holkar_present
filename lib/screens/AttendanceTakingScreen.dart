import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:holkar_present/utils/Coolers.dart';
import 'package:holkar_present/utils/Custom/StudentCard.dart';

class AttendanceTakingScreen extends StatefulWidget {
  const AttendanceTakingScreen({super.key, required this.map});

  final Map<String, dynamic> map;

  @override
  State<AttendanceTakingScreen> createState() => _AttendanceTakingScreenState();
}

class _AttendanceTakingScreenState extends State<AttendanceTakingScreen> {
  final CardSwiperController controller = CardSwiperController();
  List cards = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.map['title']),
      ),
      body: Stack(
        children: [
          Container(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.green, Colors.green, white],
                      ),
                    ),
                    alignment: Alignment.topCenter,
                    child: const Text('Present'),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.red, Colors.red, white],
                      ),
                    ),
                    alignment: Alignment.bottomCenter,
                    child: const Text('Absent'),
                  ),
                ),
              ],
            ),
          ),

          Flexible(
            child: CardSwiper(
              controller: controller,
              cardsCount: 5,
              allowedSwipeDirection: const AllowedSwipeDirection.only(up: true,down: true),
              numberOfCardsDisplayed: 2,
              backCardOffset: const Offset(320, 0),
              scale: 0.9,
              cardBuilder: (context, index, horizontalOffsetPercentage, verticalOffsetPercentage) {
                return StudentCard();
              },
            ),
          ),
        ],
      ),
    );
  }

}
