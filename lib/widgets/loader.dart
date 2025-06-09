import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/spacers.dart';

Widget loader = ListView.builder(
  itemCount: 3,
  itemBuilder: (context, index) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: container,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: double.infinity,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    w10,
                    Container(
                      width: 45,
                      height: 45,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: appBarColor),
                    ),
                    w10,
                  ],
                ),
              )),
          const Divider(
            color: bgColor,
            thickness: 1,
          ),
          Container(
            width: double.infinity,
            height: 230,
            color: appBarColor,
          )
        ],
      ),
    ),
  ),
);
