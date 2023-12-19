import 'package:flutter/material.dart';

import '../flutter_flow/flutter_flow_util.dart';

class PagesBox extends StatelessWidget {
  final String pageName;
  final String iconPath;
  final String routeName;

  const PagesBox({
    Key? key,
    required this.pageName,
    required this.iconPath,
    required this.routeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        GoRouter.of(context).go(routeName);
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[200]
                : Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  iconPath,
                  height: 65,
                ),
                Text(
                  pageName,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey.shade800
                        : Colors.grey.shade200,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
