import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class Liquid_pull extends StatelessWidget {
  const Liquid_pull({super.key});

  Future<void> _handleRefresh() async {

    return await Future.delayed(const Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidPullToRefresh(
        color: Colors.deepPurple,
        height: 200,
        backgroundColor: Colors.deepPurple.shade100,
        onRefresh: _handleRefresh,
        animSpeedFactor: 5,
        showChildOpacityTransition: true,
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.deepPurple),
                title: Text("Item $index"),
                subtitle: const Text("Swipe down to refresh"),
              ),
            );
          },
        ),
      ),
    );
  }
}
