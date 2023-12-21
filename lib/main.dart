import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => Counter(),
        child: const AppWidget(),
      ),
    );

class Counter with ChangeNotifier {
  int value = 0;
  var fpc = FlipCardController(); // Create a FlipCardController instance

  // Add a getter to expose the FlipCardController instance
  FlipCardController get flipCardController => fpc;

  void increment() {
    value += 1;
    print('Value is now: $value');

    notifyListeners();
  }

  void checkToogledAmount() {
    if (value == 3) {
      print('Value is 3 - toogle card');
      fpc.toggleCard(); // Use the FlipCardController instance to toggle the card
    }
  }
}

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    var counter = context.read<Counter>(); // Read the Counter instance

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        backgroundColor: const Color.fromARGB(172, 81, 187, 177),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlipCard(
                // Use the FlipCardController instance from the Counter instance
                controller: counter.flipCardController,
                back: const Image(
                  image: AssetImage('assets/images/coin-back.png'),
                  width: 200,
                ),
                front: const Image(
                  image: AssetImage('assets/images/coin-front.png'),
                  width: 200,
                ),
                onFlip: () {
                  print('Flipped');
                  counter.increment(); // Increment the counter
                  // counter.flipCardController.toggleCard(); // Toggle the card
                  counter.checkToogledAmount();
                  // if (counter.value == 3) {
                  //   counter.flipCardController.toggleCard();
                  // }
                },
                onFlipDone: (status) {
                  print('status: ${status}');
                  counter.checkToogledAmount();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('You have clicked...'),
              Consumer<Counter>(
                builder: (context, counter, child) =>
                    Text('Clicked: ${counter.value}'),
              ),
              IconButton(
                onPressed: () {
                  // Toggle the card if it's not front
                  if (!counter.flipCardController.state!.isFront) {
                    counter.flipCardController.toggleCard();
                  }
                },
                icon: const Icon(Icons.threesixty_rounded),
                iconSize: 70,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
