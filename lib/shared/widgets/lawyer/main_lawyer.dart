import 'package:flutter/material.dart';
import 'package:frontend/shared/constants/index.dart';

class MainLawyer extends StatelessWidget {
  const MainLawyer(
      {super.key,
      required this.name,
      this.image,
      required this.profession,
      required this.rating,
      required this.experience});
  final String? image;
  final String name;
  final String profession;
  final String experience;
  final String rating;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(small),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: 94,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      topLeft: Radius.circular(12)),
                  image: DecorationImage(
                      image: NetworkImage(
                        image ??
                            'https://images.unsplash.com/photo-1605664041952-4a2855d9363b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80',
                      ),
                      fit: BoxFit.cover)),
            ),
          ),
          space16,
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                space8,
                space4,
                Text(
                  name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                space4,
                Text(
                  profession,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                space8,
                Text(
                  "Ажлын туршлага: $experience жил",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
          space16,
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: origin),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: gold,
                      size: 15,
                    ),
                    space8,
                    Text(
                      rating,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
