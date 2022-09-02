import 'package:flutter/material.dart';

class SelectCard extends StatelessWidget {
  const SelectCard({
    super.key,
    required this.title,
    required this.path,
    required this.count,
    required this.action,
  });
  final String title;
  final String path;
  final int count;
  final Widget action;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  const Text('path:'),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    path,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w200, fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('count:'),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    count.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w200, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  action,
                ],
              )
            ],
          )),
    );
  }
}
