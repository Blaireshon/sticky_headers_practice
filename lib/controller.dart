// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
//
// class realController extends GetxController{
//   late List<List<String>> cellDataList;
//   late List<List<String>> dataList;
//   late RxList<List> realData = [[]].obs;
//
//   realController({List<List<String>>? cellData}) {
//     cellDataList = cellData ?? [[]];
//     dataList = cellDataList;
//     realData = dataList.obs;
//   }
//
//   void updateCellValue(int rowIndex, int columnIndex, String newValue) {
//     print('여기');
//     print(realData[rowIndex][columnIndex]);
//     realData[rowIndex][columnIndex] = newValue;
//     print(realData[rowIndex][columnIndex]);
//   }
//
// }