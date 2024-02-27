import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MakeTable extends StatefulWidget {
  MakeTable(
      {super.key,
      // 컬럼 길이
      required this.columnLength,
      // 행 길이
      required this.rowLength,
      // 컬럼 타이틀
      required this.columnHeaderBuilder,
      // 행 타이틀
      required this.rowHeaderBuilder,
      // 셀 데이터
      required this.cellData,
      // index
      this.indexCell = const Text(''),
      // 셀 넓이
      this.columnHeaderWidth = 100,
      // 셀 높이
      this.rowHeaderHeight = 50,
      // index 넓이
      this.indexWidth = 100,
      // index 높이
      this.indexHeight = 50});

  final int columnLength;
  final int rowLength;

  // 함수 변수. widget 반환
  final Widget Function(int columnIndex) columnHeaderBuilder;
  final Widget Function(int rowIndex) rowHeaderBuilder;
  final Widget Function(int columnIndex, int rowIndex) cellData;
  final Widget indexCell;
  final double columnHeaderWidth;
  final double rowHeaderHeight;
  final double indexWidth;
  final double indexHeight;


  @override
  State<MakeTable> createState() => _MakeTableState();
}

class _MakeTableState extends State<MakeTable> {
  // 헤더와 데이터 스크롤 동기화
  final ScrollController _Vcontroller = ScrollController();
  final ScrollController _verticalController = ScrollController();

  final ScrollController _Hcontroller = ScrollController();
  final ScrollController _horizontalController = ScrollController();
  late SyncScrollController _horizontalSyncController;
  late SyncScrollController _verticalSyncController;

  @override
  void initState() {
    // 스크롤 할때마다 호출
    // _Vcontroller.addListener(() {
    //   _verticalController.jumpTo(_Vcontroller.offset);
    // });
    // _verticalController.addListener(() {
    //   _Vcontroller.jumpTo(_verticalController.offset);
    // });
    //
    // _Hcontroller.addListener(() {
    //   _horizontalController.jumpTo(_Hcontroller.offset);
    // });
    // _horizontalController.addListener(() {
    //   _Hcontroller.jumpTo(_horizontalController.offset);
    // });

    super.initState();
  }

  // @override
  // void dispose() {
  //   _Vcontroller.dispose();
  //   _Hcontroller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    _verticalSyncController = SyncScrollController(
      _Vcontroller,
      _verticalController,
    );
    _horizontalSyncController = SyncScrollController(
      _Hcontroller,
      _horizontalController,
    );
    return Column(
      children: <Widget>[
        Row(
          children: [
            /// index
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black26, // border 색상
                    width: 1.0, // border 두께
                    style: BorderStyle.solid, // border 스타일
                  ),
                  right: BorderSide(
                    color: Colors.black26, // border 색상
                    width: 1.0, // border 두께
                    style: BorderStyle.solid, // border 스타일
                  ),
                ),
              ),
              width: widget.indexWidth,
              height: widget.indexHeight,
              alignment: Alignment.center,
              child: widget.indexCell,
            ),

            /// coloumn header
            Expanded(
                child: NotificationListener<ScrollNotification>(
                    child: Scrollbar(
                      controller: _Hcontroller,
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _Hcontroller,
                          //physics: const NeverScrollableScrollPhysics(),
                          child: Row(
                            children: List.generate(
                                widget.columnLength,
                                (i) => Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.black26, // border 색상
                                            width: 1.0, // border 두께
                                            style:
                                                BorderStyle.solid, // border 스타일
                                          ),
                                        ),
                                      ),
                                      width: widget.columnHeaderWidth,
                                      height: widget.indexHeight,
                                      alignment: Alignment.center,
                                      child: widget.columnHeaderBuilder(i),
                                    )),
                          )),
                    ),
                    onNotification: (ScrollNotification scrollInfo) =>
                        (_horizontalSyncController.processNotification(
                            scrollInfo, _Hcontroller))))
          ],
        ),
        Expanded(
            child: Row(
          children: <Widget>[
            /// row header
            NotificationListener<ScrollNotification>(
                child: Scrollbar(
                  //controller: _Vcontroller,
                  controller: _verticalController,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    controller: _Vcontroller,
                    //controller: _verticalController,
                    // physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: List.generate(
                          widget.rowLength,
                          (i) => Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Colors.black26, // border 색상
                                      width: 1.0, // border 두께
                                      style: BorderStyle.solid, // border 스타일
                                    ),
                                  ),
                                ),
                                width: widget.indexWidth,
                                height: widget.rowHeaderHeight,
                                alignment: Alignment.center,
                                child: widget.rowHeaderBuilder(i),
                              )),
                    ),
                  ),
                ),
                onNotification: (ScrollNotification scrollInfo) =>
                    (_verticalSyncController.processNotification(
                        scrollInfo, _Vcontroller))),

            Expanded(

                /// data
                child: NotificationListener<ScrollNotification>(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _horizontalController,
                        child: NotificationListener<ScrollNotification>(
                            child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                controller: _verticalController,
                                child: Row(
                                  children: List.generate(
                                      widget.columnLength,
                                      (int columnIdx) => Column(
                                            children: List.generate(
                                              widget.rowLength,
                                              (int rowIdx) => Container(
                                                width: widget.columnHeaderWidth,
                                                height: widget.rowHeaderHeight,
                                                alignment: Alignment.center,
                                                child: widget.cellData(
                                                    rowIdx, columnIdx),
                                              ),
                                            ),
                                          )),
                                  //children: generateTableWidgets(),
                                )),
                            onNotification: (ScrollNotification
                                    scrollInfo) => // HEY!! LISTEN!!
                                (_verticalSyncController.processNotification(
                                    scrollInfo, _verticalController)))),
                    onNotification:
                        (ScrollNotification scrollInfo) => // HEY!! LISTEN!!
                            (_horizontalSyncController.processNotification(
                                scrollInfo, _horizontalController))))
          ],
        ))
      ],
    );
  }
}

class SyncScrollController {
  SyncScrollController(
    this._headerController,
    this._dataController,
  );

  final ScrollController _headerController;
  final ScrollController _dataController;

  ScrollController? _scrollingController;
  bool _scrollingActive = false;

  bool processNotification(
      ScrollNotification notification, ScrollController sender) {
    if (notification is ScrollStartNotification && !_scrollingActive) {
      _scrollingController = sender;
      _scrollingActive = true;
      return false;
    }
    if (identical(sender, _scrollingController) && _scrollingActive) {
      if (notification is ScrollEndNotification) {
        _scrollingController = null;
        _scrollingActive = false;
        return true;
      }
      if (notification is ScrollUpdateNotification) {
        for (final controller in [_headerController, _dataController]) {
          if (identical(_scrollingController, controller)) continue;
          if (controller.positions.isEmpty) continue;
          final offset = _scrollingController?.offset;
          if (offset != null) {
            controller.jumpTo(offset);
          }
        }
      }
    }
    return false;
  }
}
