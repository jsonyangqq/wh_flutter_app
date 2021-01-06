
import 'package:flutter/material.dart';

class LoadingCircle {

    /**
     * 加载更多时显示的组件,给用户提示  显示圈圈
     */
     Widget getMoreWidget(double progressValue) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '加载中...',
                  style: TextStyle(fontSize: 16.0),
                ),
                CircularProgressIndicator(
                  value: progressValue,
                  strokeWidth: 1.0,
                )
              ],
            ),
          ),
        );
    }

}