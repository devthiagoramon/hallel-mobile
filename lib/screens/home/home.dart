import 'package:flutter/material.dart';

class HomeContainer extends StatelessWidget {
  const HomeContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "HomePage",
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }
}