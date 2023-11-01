import 'package:flutter/material.dart';

class ItemCountBar extends StatefulWidget {
  const ItemCountBar({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.onCountChanged,
    this.initialCount = 0,
  });
  final String imageUrl;
  final String title;
  final int initialCount;
  final Function(int) onCountChanged;

  @override
  State<ItemCountBar> createState() => _ItemCountBarState();
}

class _ItemCountBarState extends State<ItemCountBar> {
  int countItem = 0;
  @override
  void initState() {
    countItem = widget.initialCount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.network(
                widget.imageUrl,
                width: 64,
                height: 64,
              ),
              const SizedBox(width: 16),
              Text(widget.title),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (countItem == 0) return;
                  setState(() {
                    countItem--;
                    widget.onCountChanged(countItem);
                  });
                },
                icon: const Icon(Icons.remove),
              ),
              Text("$countItem"),
              IconButton(
                onPressed: () {
                  setState(() {
                    countItem++;
                    widget.onCountChanged(countItem);
                  });
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          // Text("Rp. 100.000"),
          // ElevatedButton(
          //   onPressed: () {},
          //   child: Text("Pesan"),
          // ),
        ],
      ),
    );
  }
}
