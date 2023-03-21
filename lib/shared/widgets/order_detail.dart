import 'package:flutter/material.dart';
import 'package:frontend/modules/modules.dart';
import 'package:frontend/shared/index.dart';
import 'package:get/get.dart';

class OrderDetailView extends GetView<PrimeController> {
  const OrderDetailView({
    super.key,
    required this.name,
    required this.profession,
    required this.status,
    required this.type,
    required this.onTap,
  });
  final String name;
  final String profession;
  final Function() onTap;
  final String status;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(origin), color: Colors.white),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                      width: 66,
                      height: 66,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: NetworkImage(
                              "https://images.unsplash.com/photo-1605664041952-4a2855d9363b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80",
                            ),
                            fit: BoxFit.cover,
                          )),
                      child: SizedBox()),
                  space16,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      space8,
                      Text(
                        profession,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      space8,
                      Text(
                        status,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(color: success),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialogView(
                                  icon: Icons.recycling,
                                  title: 'Захиалгын цаг өөрчлөх',
                                  text:
                                      'Та захиалгын цагийг өөрчлөхдөө итгэлтэй байна уу?',
                                  approve: () {},
                                  color: warning);
                            });
                      },
                      icon: Icon(Icons.recycling)),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialogView(
                                  icon: Icons.delete,
                                  title: 'Захиалга цуцлах',
                                  text:
                                      'Та захиалгаа цуцлахдаа итгэлтэй байна уу?',
                                  approve: () {},
                                  color: error);
                            });
                      },
                      icon: Icon(Icons.delete))
                ],
              )
            ],
          ),
          space16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                type,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              MainButton(
                height: 40,
                padding: const EdgeInsets.symmetric(
                    vertical: small, horizontal: origin),
                borderRadius: 40,
                onPressed: onTap,
                child: Row(
                  children: [
                    Icon(Icons.camera),
                    space8,
                    Text(
                      'start',
                      style: Theme.of(context).textTheme.labelMedium,
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
