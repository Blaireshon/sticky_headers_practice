import 'dart:async';
import 'package:flutter/material.dart';

/// 좌우 상하 스크롤 테이블
/// required int [columnLength] 테이블 컬럼 개수
/// required int [rowLength] 테이블 행 개수
/// required Widget [columnHeaderBuilder] 테이블 column header 타이틀, for example) columnHeaderBuilder: (i) => Text(titleColumn[i]),
/// required Widget [rowHeaderBuilder] 테이블 row header 타이틀,  for example) rowHeaderBuilder: (i) => Text(titleRow[i]),
/// required Widget [cellData] 테이블 data, for example) cellData: (i, j) => Text(data[i][j]),
/// Widget [indexCell] 인덱스, for example) indexCell: Text('Index'),
/// double [columnHeaderWidth] 테이블 data table cell 넓이
/// double [rowHeaderHeight] 테이블 data table cell 높이
/// double [indexWidth] 테이블 row header 넓이
/// double [indexHeight] 테이블 column header 높이

final GlobalKey<_MakeTableState> makeTableKey = GlobalKey<_MakeTableState>();

class MakeTable extends StatefulWidget {
  const MakeTable({
    super.key,
    // 컬럼 개수
    required this.columnLength,
    // 행 개수
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
    this.indexHeight = 50,
  });

  final int columnLength;
  final int rowLength;

  // 함수 변수. widget 반환
  final Widget Function(int columnIndex) columnHeaderBuilder;
  final Widget Function(int rowIndex) rowHeaderBuilder;
  final List<List<String>> cellData;
  //final Widget Function(int columnIndex, int rowIndex) cellData;

  final Widget indexCell;
  final double columnHeaderWidth;
  final double rowHeaderHeight;
  final double indexWidth;
  final double indexHeight;

  @override
  State<MakeTable> createState() => _MakeTableState();
}

/// [_verticalHeaderController] row header 스크롤 컨트롤러
/// [_verticalController] data 영역 수직 스크롤 컨트롤러
/// [_horizontalHeadercontroller] column header 스크롤 컨트롤러
/// [_horizontalController] data 영역 수평 스크롤 컨트롤러
class _MakeTableState extends State<MakeTable> {
  /// 헤더와 데이터 스크롤컨트롤러
  // vertical header scroll controller
  final ScrollController _verticalHeaderController = ScrollController();

  // vertical data scroll controller
  final ScrollController _verticalController = ScrollController();

  // horizontal header scroll controller
  final ScrollController _horizontalHeadercontroller = ScrollController();

  // horizontal data scroll controller
  final ScrollController _horizontalController = ScrollController();

  /// 동기화 된 스크롤을 관리하기 위한 싱크스크롤컨트롤러
  //SyncScrollController(
  //     this._headerController,
  //     this._dataController,
  //   );

  // rowheader 스크롤과 data 수직 스크롤 동기화
  late SyncScrollController _verticalSyncController;

  // columnheader 스크롤과 data 수평 스크롤 동기화
  late SyncScrollController _horizontalSyncController;

  /// 데이터 update
  /// [rowIdx] update될 값의 row 위치
  /// [columnIdx] update될 값의 column 위치
  /// [newValue] update될 값
  void updateCellValue(int rowIdx, int columnIdx, String newValue) {
    setState(() {
      widget.cellData[rowIdx][columnIdx] = newValue;
    });
  }

  /// update된 데이터를 border flash로 표시하기 위해 timer 객체 선언
  Timer? borderTimer;

  @override
  void dispose() {
    borderTimer?.cancel();
    super.dispose();
  }

  /// border flash 관리하기 위한 변수
  List<List<bool>> cellBorders = List.generate(
    1000,
    (rowIdx) => List.generate(
      5,
      (columnIdx) => false,
    ),
  );

  /// 업데이트 된 데이터의 border style 변경(flash)
  /// [rowIdx] update될 값의 row 위치
  /// [columnIdx] update될 값의 column 위치
  void setCellBorderFlash(int rowIdx, int columnIdx) {
    setState(() {
      cellBorders[rowIdx][columnIdx] = true;
    });

    /// update된 값의 border가 500ms 동안 활성화 됨
    borderTimer = Timer(Duration(milliseconds: 500), () {
      setState(() {
        cellBorders[rowIdx][columnIdx] = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    /// 수직 스크롤 동기화 컨트롤러
    _verticalSyncController = SyncScrollController(
      _verticalHeaderController,
      _verticalController,
    );

    /// 수평 스크롤 동기화 컨트롤러
    _horizontalSyncController = SyncScrollController(
      _horizontalHeadercontroller,
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

            /// column header
            Expanded(
                child: NotificationListener<ScrollNotification>(
                    child: Scrollbar(
                      controller: _horizontalController,
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _horizontalHeadercontroller,
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
                            scrollInfo, _horizontalHeadercontroller))))
          ],
        ),
        Expanded(
            child: Row(
          children: <Widget>[
            /// row header
            NotificationListener<ScrollNotification>(
                child: Scrollbar(
                  controller: _verticalController,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    controller: _verticalHeaderController,
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
                        scrollInfo, _verticalHeaderController))),

            Expanded(

                /// data 영역
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
                                                decoration: BoxDecoration(
                                                  border: cellBorders[rowIdx]
                                                          [columnIdx]
                                                      ? Border.all(
                                                          color: Colors.red,
                                                          width: 2.0)
                                                      : null,
                                                ),
                                                child: Text(
                                                    widget.cellData[rowIdx]
                                                        [columnIdx]),
                                                // child: widget.cellData(
                                                //     rowIdx, columnIdx),
                                              ),
                                            ),
                                          )),
                                )),
                            onNotification: (ScrollNotification scrollInfo) =>
                                (_verticalSyncController.processNotification(
                                    scrollInfo, _verticalController)))),
                    onNotification: (ScrollNotification scrollInfo) =>
                        (_horizontalSyncController.processNotification(
                            scrollInfo, _horizontalController))))
          ],
        ))
      ],
    );
  }
}

/// 스크롤 동기화 컨트롤러
/// [_headerController] _verticalHeaderController, _horizontalHeadercontroller
/// [_dataController] _verticalController, _horizontalController
class SyncScrollController {
  SyncScrollController(
    this._headerController,
    this._dataController,
  );

  final ScrollController _headerController;
  final ScrollController _dataController;

  // 현재 스크롤 컨트롤러를 담을 변수
  ScrollController? _scrollingController;

  // 스크롤 동작 활성화 여부
  bool _scrollingActive = false;

  /// [notification] 스크롤 이벤트에 대한 알림
  /// [sender] 해당 알림을 보내는 스크롤 컨트롤러 (_verticalHeaderController, _verticalController, _horizontalHeadercontroller, _horizontalController)
  bool processNotification(
      ScrollNotification notification, ScrollController sender) {
    /// ScrollStartNotification이 발생하고 현재 스크롤 동작이 활성화되어 있지 않은 경우(_scrollingActive가 false인 경우)
    if (notification is ScrollStartNotification && !_scrollingActive) {
      // _scrollingController를 현재 스크롤 컨트롤러로 설정
      _scrollingController = sender;
      _scrollingActive = true;
      return false;
    }

    /// 현재 스크롤 컨트롤러가 _scrollingController와 동일하고 스크롤 동작이 활성화된 경우
    if (identical(sender, _scrollingController) && _scrollingActive) {
      /// ScrollEndNotification : 스크롤 동작이 끝났을 때 발생하는 알림. 스크롤 동작이 끝나면 사용자가 스크롤을 놓았거나 스크롤 애니메이션이 완료된 경우에 해당하는 이벤트
      if (notification is ScrollEndNotification) {
        _scrollingController = null;
        _scrollingActive = false;
        return true;
      }

      /// ScrollUpdateNotification : 스크롤이 업데이트될 때 발생하는 알림.
      if (notification is ScrollUpdateNotification) {
        // 스크롤이 업데이트되었을 때 다른 컨트롤러를 동기화
        // 컨트롤러들을 순회하면서 _scrollingController와 같지 않은 컨트롤러에 스크롤 오프셋을 _scrollingController의 오프셋으로 설정
        for (final controller in [_headerController, _dataController]) {
          if (identical(_scrollingController, controller)) continue;
          if (controller.positions.isEmpty) continue;
          final offset = _scrollingController?.offset;
          if (offset != null) {
            // 동기화된 스크롤 동작
            controller.jumpTo(offset);
          }
        }
      }
    }
    return false;
  }
}
