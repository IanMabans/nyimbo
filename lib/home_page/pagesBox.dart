import 'package:flutter/material.dart';

class PagesBox extends StatelessWidget {
  final String pageName;
  final String iconPath;
  final String routeName; // Add routeName

  const PagesBox(
      {Key? key,
      required this.pageName,
      required this.iconPath,
      required this.routeName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(routeName); // Navigate to the respective screen
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon
                Image.asset(
                  iconPath,
                  height: 65,
                ),
                Text(pageName),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
