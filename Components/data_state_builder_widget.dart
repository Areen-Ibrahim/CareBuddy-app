import 'package:carebuddy/Core/Components/empty_widget.dart';
import 'package:carebuddy/Core/Components/failure_widget.dart';
import 'package:carebuddy/Core/Components/loading_widget.dart';
import 'package:flutter/material.dart';

class DataStateBuilderWidget extends StatelessWidget {
  final bool isError;
  final String? errorTxt;
  final bool isDataFound;
  final bool isLoading;
  final Widget widget;
  final String? emptyTxt;
  final Function()? failureTap;
  final Widget? shimmerWidget;
  final double? emptyTxtSize;
  const DataStateBuilderWidget({super.key,required this.isLoading,required this.isError,this.errorTxt, required this.isDataFound,required this.widget, this.shimmerWidget, this.emptyTxt, this.emptyTxtSize, this.failureTap});

  @override
  Widget build(BuildContext context) {
    if( isLoading )
      {
        return shimmerWidget ?? const LoadingWidget();
      }
    else if ( isError )
    {
      return FailureWidget(onTap: failureTap, message: errorTxt);
    }
    else     {
      if( isDataFound )
      {
        return widget;
      }
      else
      {
        return EmptyWidget(txt: emptyTxt,txtSize: emptyTxtSize);
      }
    }
  }
}
