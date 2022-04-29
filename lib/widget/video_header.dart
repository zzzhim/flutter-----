// 详情页面
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/model/home_mo.dart';
import 'package:untitled/util/color.dart';
import 'package:untitled/util/format_urli.dart';

class VideoHeader extends StatelessWidget {
  final Owner owner;

  const VideoHeader({Key? key, required this.owner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, right: 15, left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  owner.face ?? '',
                  width: 30,
                  height: 30,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      owner.name ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        color: primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${countFormat(owner.fans ?? 0)}粉丝',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          MaterialButton(
            color: primary,
            height: 24,
            minWidth: 50,
            child: const Text(
              '+ 关注',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
            onPressed: () {
              print('关注');
            },
          )
        ],
      ),
    );
  }
}
