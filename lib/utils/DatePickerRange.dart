import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:wh_flutter_app/pages/WorkOrderList.dart';
import 'package:wh_flutter_app/utils/ScreenAdapter.dart';

class DatePickerRange extends StatefulWidget {
  @override
  _DatePickerRangeState createState() => _DatePickerRangeState();
}

class _DatePickerRangeState extends State<DatePickerRange> {


  String startDate;
  String endDate;

  DateRangePickerSelectionChangedArgs _changedArgs;

  @override
  void initState() {
    startDate = '';
    startDate = '';
    super.initState();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        startDate =  DateFormat('yyyy-MM-dd').format(args.value.startDate).toString();
        endDate = DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate).toString();
        this._changedArgs = args;
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Text("日期插件"),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: 10,
            right: 0,
            bottom: 0,
            child: Container(
              child: SfDateRangePicker(
                  backgroundColor: Colors.white,
                  view: DateRangePickerView.month,
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.range,
                  navigationDirection: DateRangePickerNavigationDirection.horizontal,
                  showNavigationArrow: true,
//                toggleDaySelection: true,
                  allowViewNavigation: true,
                  enableMultiView: true,
                  monthViewSettings: DateRangePickerMonthViewSettings(
                      viewHeaderStyle: DateRangePickerViewHeaderStyle(
                      )
                  ),
                  initialSelectedRanges: [
                    PickerDateRange(
                        DateTime(2020,12,01),
                        DateTime(2021,01,30)
                    )
                  ]
              ),
            ),
          ),
          Positioned(
              right: 50,
              bottom: 50,
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: Text("确定",style: TextStyle(color: Colors.blue),),
                ),
                onTap: () {
                  if(!(startDate != '' && endDate != '')) {
                    Fluttertoast.showToast(
                      msg: '请选择一个时间段日期',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                    );
                  }else {
                    print('选择开始日期为：' + startDate);
                    print('选择结束日期为：' + endDate);
                    Map<String,String> mapObject = new Map();
                    mapObject.putIfAbsent("startDate", () => startDate);
                    mapObject.putIfAbsent("endDate", () => endDate);
                    Navigator.of(context).pop();
                    Navigator.of(context).popAndPushNamed("/workOrderList",arguments: {
                      "startDate": startDate,
                      "endDate": endDate
                    });
                  }

                },
              )
          )
        ],
      ),
    );
  }


}
