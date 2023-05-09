import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';

class DecidedWidget extends StatefulWidget {
  const DecidedWidget(
      {super.key,
      required this.onTitle,
      required this.onLink,
      required this.onDate,
      required this.title,
      required this.link,
      required this.date});
  final Function(String?) onTitle;
  final Function(String?) onLink;
  final Function(int) onDate;
  final String title;
  final String link;
  final int date;
  @override
  State<DecidedWidget> createState() => _DecidedWidgetState();
}

class _DecidedWidgetState extends State<DecidedWidget> {
  int date = DateTime.now().millisecondsSinceEpoch;
  @override
  void initState() {
    super.initState();
    date = widget.date;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Input(onChange: widget.onTitle, labelText: 'Гарчиг'),
        space16,
        GestureDetector(
          onTap: () async {
            DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1970),
                lastDate: DateTime.now());
            if (picked != null) {
              widget.onDate(picked.millisecondsSinceEpoch);

              setState(() {
                date = picked.millisecondsSinceEpoch;
              });
            }
          },
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: gray)),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: Text(
                'Огноо: ${DateTime.fromMillisecondsSinceEpoch(date).year}-${DateTime.fromMillisecondsSinceEpoch(date).month < 10 ? 0 : ''}${DateTime.fromMillisecondsSinceEpoch(date).month}-${DateTime.fromMillisecondsSinceEpoch(date).day < 10 ? 0 : ''}${DateTime.fromMillisecondsSinceEpoch(date).day}',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: gray),
              )),
        ),
        space16,
        Input(onChange: widget.onLink, labelText: 'Линк'),
      ],
    );
  }
}
