import 'package:flutter/material.dart';

class TextAndButton extends StatelessWidget {
  const TextAndButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "assets/images/pablo_empty_cart.PNG",
                height: 200,
              )),
          // Image.asset("assets/images/cart_empty.png", height: 200),
          const SizedBox(height: 5),
          const Text("Oops, Looks like the cart is Empty",
              textAlign: TextAlign.center, style: TextStyle(fontSize: 25)),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                primary: Colors.black, minimumSize: const Size(80, 50)),
            child: const Text(
              "Continue Shopping",
              style: TextStyle(color: Colors.white),
            ),
          )
        ]);
  }
}
