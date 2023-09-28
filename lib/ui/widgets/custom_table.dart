import 'package:flutter/material.dart';
import '/config/utils.dart';

class CostumTable extends StatelessWidget {
  final List<String>? cols;
  final List<DataRow>? data;

  const CostumTable({super.key, this.cols, this.data});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      showBottomBorder: true,
      headingRowColor: MaterialStateProperty.all(
        Colors.grey[300],
      ),
      sortAscending: true,
      columns: [
        ...cols!.map(
          (e) => DataColumn(
            label: Flexible(
              child: Text(
                e,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: defaultFont,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        )
      ],
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.1),
            blurRadius: 5,
            offset: const Offset(0, 1),
          )
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      rows: data!,
    );
  }
}
