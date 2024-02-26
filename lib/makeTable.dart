import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MakeTable extends StatefulWidget {
  MakeTable({
    super.key,
    // 컬럼 길이
    required this.columnLenght,
    // 행 길이
    required this.rowLenght,
    // 컬럼 타이틀
    required this.columnTitleBuilder,
    // 행 타이틀
    required this.rowTitleBuilder,
    // 셀 데이터
    required this.cellData,
    // index
    this.indexCell = const Text('')
  });

  final int columnLenght;
  final int rowLenght;

  // 함수 변수. widget 반환
  final Widget Function(int columnIndex) columnTitleBuilder;
  final Widget Function(int rowIndex) rowTitleBuilder;
  final Widget Function(int columnIndex, int rowIndex) cellData;
  final Widget indexCell;

//body: StickyHeadersTable(

//         columnsLength: ColumnTitle.length,
//         rowsLength: RowTitle.length,
//         ColumnTitleBuilder: (i) => Text(ColumnTitle[i]),
//         RowTitleBuilder: (i) => Text(RowTitle[i]),
//         CellData: (i, j) => Text(data[i][j]),
//         legendCell: Text('Sticky Legend'),
//       ),

  @override
  State<MakeTable> createState() => _MakeTableState();
}

class _MakeTableState extends State<MakeTable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Container(
              width: 100,
              height: 50,
              child: widget.indexCell,
            ),
            Expanded(child: Scrollbar(child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:Row(
                children: List.generate(widget.columnLenght, (i) => Container(width: 100,height: 50,child: widget.columnTitleBuilder(i),)) ,
              )

            ),))
          ],
        ),
        Expanded(child: Row(
          children: <Widget> [
            Scrollbar(child:SingleChildScrollView(scrollDirection: Axis.vertical,
            child: Column(children: List.generate(widget.rowLenght, (i) => Container(width: 100,height: 50,child: widget.rowTitleBuilder(i),)),),),),
            Expanded(child: SingleChildScrollView(scrollDirection: Axis.horizontal,child:SingleChildScrollView(scrollDirection: Axis.vertical,child:Row(
              children: List.generate(widget.columnLenght, (int columnIdx) => Column(children: List.generate(widget.rowLenght, (int rowIdx) => Container(width: 100,height: 50,child:widget.cellData(columnIdx, rowIdx),),),)),
            ))))
          ],
        ))

      ],
    );
  }
}
