import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/rendering.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/presentation/widgets/widgets.dart';


class HistoryView extends StatelessWidget {
  final bool isAdmin;
  const HistoryView({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    var student = {
      'schedule': [
        {
          'dateDuration': 'Lunes 20 al Viernes 24 de Mayo del 2024',
          'attendanceRecord': [
            {'day': 'Miércoles', 'input': '08:00', 'output': '12:00', 'coffee': true},
            {'day': 'Jueves', 'input': '08:00', 'output': '12:00', 'coffee': false},
            {'day': 'Viernes', 'input': '08:00', 'output': '12:00', 'coffee': true},
          ],
          'totalAttendance': 3,
          'totalRecords': 3,
        },
        {
          'dateDuration': 'Lunes 27 al Viernes 31 de Mayo del 2024',
          'attendanceRecord': [
            {'day': 'Lunes', 'input': '08:00', 'output': '12:00', 'coffee': true},
            {'day': 'Martes', 'input': '08:00', 'output': '12:00', 'coffee': false},
            {'day': 'Miércoles', 'input': '08:00', 'output': '12:00', 'coffee': true},
            {'day': 'Jueves', 'input': 'No registrada', 'output': 'No registrada', 'coffee': false},
            {'day': 'Viernes', 'input': '', 'output': '', 'coffee': null},
          ],
          'totalAttendance': 3,
          'totalRecords': 5,
        },
        {
          'dateDuration': 'Lunes 03 al Viernes 08 de Junio del 2024',
          'attendanceRecord': [
            {'day': 'Lunes', 'input': '08:00', 'output': '12:00', 'coffee': true},
            {'day': 'Martes', 'input': '08:00', 'output': '12:00', 'coffee': false},
            {'day': 'Miércoles', 'input': '08:00', 'output': '12:00', 'coffee': true},
            {'day': 'Jueves', 'input': 'No registrada', 'output': 'No registrada', 'coffee': false},
            {'day': 'Viernes', 'input': '', 'output': '', 'coffee': null},
          ],
          'totalAttendance': 3,
          'totalRecords': 5,
        },
        {
          'dateDuration': 'Lunes 11 al Viernes 16 de Junio del 2024',
          'attendanceRecord': [
            {'day': 'Lunes', 'input': '08:00', 'output': '12:00', 'coffee': true},
            {'day': 'Martes', 'input': '08:00', 'output': '12:00', 'coffee': false},
          ],
          'totalAttendance': 2,
          'totalRecords': 2,
        },
      ]
    };
    
    var admin = {
      'schedule': [
        {
          'dateDuration': 'Lunes 20 de Mayo del 2024',
          'attendanceRecord': [
            {'name': 'Francisco González', 'input': '08:00', 'output': '12:00', 'coffee': true},
            {'name': 'María Pérez', 'input': '08:00', 'output': '12:00', 'coffee': false},
            {'name': 'Juan López', 'input': '08:00', 'output': '12:00', 'coffee': true},
            {'name': 'Francisco González', 'input': '08:00', 'output': '12:00', 'coffee': true},
            {'name': 'María Pérez', 'input': '08:00', 'output': '12:00', 'coffee': false},
            {'name': 'Juan López', 'input': '08:00', 'output': '12:00', 'coffee': true},
          ],
          'totalAttendance': 6,
        },
        {
          'dateDuration': 'Martes 21 de Mayo del 2024',
          'attendanceRecord': [
            {'name': 'Francisco González', 'input': '08:00', 'output': '12:00', 'coffee': true},
            {'name': 'María Pérez', 'input': '08:00', 'output': '12:00', 'coffee': false},
            {'name': 'Juan López', 'input': '08:00', 'output': '12:00', 'coffee': true},
            {'name': 'Francisco González', 'input': '08:00', 'output': '12:00', 'coffee': true},
            {'name': 'María Pérez', 'input': '08:00', 'output': '12:00', 'coffee': false},
            {'name': 'Juan López', 'input': '08:00', 'output': '12:00', 'coffee': true},
          ],
          'totalAttendance': 6,
        },
        {
          'dateDuration': 'Miércoles 22 de Mayo del 2024',
          'attendanceRecord': [
            {'name': 'Francisco González', 'input': '08:00', 'output': '12:00', 'coffee': true},
            {'name': 'María Pérez', 'input': '08:00', 'output': '12:00', 'coffee': false},
            {'name': 'Juan López', 'input': '08:00', 'output': '12:00', 'coffee': true},
            {'name': 'Francisco González', 'input': '08:00', 'output': '12:00', 'coffee': true},
            {'name': 'María Pérez', 'input': '08:00', 'output': '12:00', 'coffee': false},
            {'name': 'Juan López', 'input': '08:00', 'output': '12:00', 'coffee': true},
          ],
          'totalAttendance': 6,
        },
      ],
      'totalRecords': 6
    };

    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;

    if (admin['totalRecords'] as int > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: responsive.hp(2)),
            child: Text('Registro de asistencias:', style: texts.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
          ),
          _ExpandableList(
            isAdmin: isAdmin,
            data: isAdmin ? admin : student,
          ),
        ],
      );
    } else {
      return const Center(
        child: Text('No hay inscripciones registradas', style: TextStyle(fontWeight: FontWeight.bold)),
      );
    }
  }
}

class _ExpandableList extends StatefulWidget {
  final bool isAdmin;
  final Map<String, dynamic> data;

  const _ExpandableList({
    required this.isAdmin,
    required this.data,
  });

  @override
  State<_ExpandableList> createState() => _ExpandableListState();
}

class _ExpandableListState extends State<_ExpandableList> {
  late ScrollController scrollController;
  late List<ExpandableController> controllers;
  final List<GlobalKey> keys = [];

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    controllers = List.generate(widget.data['schedule'].length,  (_) => ExpandableController());
    keys.addAll(List.generate(widget.data['schedule'].length, (_) => GlobalKey()));
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    scrollController.dispose();
    super.dispose();
  }

  void scrollToWidget(int index) async {
    // Esperar a que el expandable haya terminado la animación de expansión
    await Future.delayed(const Duration(milliseconds: 350));

    final RenderObject? renderObject = keys[index].currentContext?.findRenderObject();
    final RenderAbstractViewport viewport = RenderAbstractViewport.of(renderObject);
    final RevealedOffset offsetToReveal = viewport.getOffsetToReveal(renderObject!, 0.0);
    final double offset = offsetToReveal.offset;

    scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final List<Map<String, dynamic>> schedule = widget.data['schedule'];

    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        padding: EdgeInsets.only(bottom: responsive.hp(2)),
        itemCount: schedule.length,
        itemBuilder: (context, index) {
          final bool isExpanded = controllers[index].expanded;
          final bool isFirst = index == 0;
          final bool isLast = index == schedule.length - 1;
          final int totalAttendance = schedule[index]['totalAttendance'];
          final int totalRecords = widget.data['totalRecords'] ?? schedule[index]['totalRecords'];
          const TextStyle textStyle = TextStyle(fontWeight: FontWeight.bold);


          return ExpandableNotifier(
            child: Container(
              key: keys[index],
              decoration: buildBoxDecoration(context, isFirst, isLast),
              child: CustomExpandable(
                controller: controllers[index],
                theme: const ExpandableThemeData(
                  crossFadePoint: 0,
                ),
                collapsed: Collapsed(
                  decoration: buildDecorationCollapsed(context, isExpanded, isFirst, isLast),
                  title: schedule[index]['dateDuration'],
                  titleStyle: textStyle,
                  trailing: Text('$totalAttendance/$totalRecords', style: textStyle),
                  onExpansionChanged: (isExpanded) => setState(() {
                    for (int i = 0; i < controllers.length; i++) {
                      controllers[i].expanded = (i == index) ? isExpanded : false;
                    }
                    if (isExpanded) scrollToWidget(index);
                  }),
                ),
                expanded: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {3: FlexColumnWidth(0.5)},
                  border: const TableBorder.symmetric(inside: BorderSide()),
                  children: [
                    buildTableHeader(context),
                    ...schedule[index]['attendanceRecord'].map((attendanceRecord) => buildTableBody(context, attendanceRecord: attendanceRecord))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  TableRow buildTableBody(BuildContext context, {required Map<String, dynamic> attendanceRecord}) {
    final responsive = Responsive(context);

    return TableRow(
      children: [
        TableCell(
          child: Container(
            height: responsive.hp(5),
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
            alignment: Alignment.centerLeft,
            child: Text(widget.isAdmin ? attendanceRecord['name'] : attendanceRecord['day']),
          ),
        ),
        TableCell(child: Text(attendanceRecord['input'], textAlign: TextAlign.center)),
        TableCell(child: Text(attendanceRecord['output'], textAlign: TextAlign.center)),
        TableCell(
          child: attendanceRecord['coffee'] == null 
            ? const SizedBox()
            : attendanceRecord['coffee']
              ? const Icon(Icons.check)
              : const Icon(Icons.close),
        )
      ],
    );
  }

  TableRow buildTableHeader(BuildContext context) {
    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;

    return TableRow(
      decoration: BoxDecoration(color: Colors.grey.shade300),
      children: [
        TableCell(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: responsive.hp(1), horizontal: responsive.wp(2)),
            child: Text(widget.isAdmin ? 'Nombre' : 'Día', style: texts.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
          ),
        ),
        TableCell(
          child: Text('Entrada', style: texts.bodyMedium!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ),
        TableCell(
          child: Text('Salida', style: texts.bodyMedium!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ),
        TableCell(
          child: Text('Café', style: texts.bodyMedium!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ),
      ],
    );
  }

  BoxDecoration buildDecorationCollapsed(BuildContext context, bool isExpanded, bool isFirst, bool isLast) {
    final responsive = Responsive(context);

    return BoxDecoration(
      color: Theme.of(context).colorScheme.primaryContainer.withAlpha(100),
      border: isExpanded ? Border(bottom: BorderSide(width: responsive.ip(0.2))) : null,
      borderRadius: BorderRadius.vertical(
      /*
        El valor del Radius.circular debe ser igual al que se construye en el buildBoxDecoration,
        pero se le debe restar el tamaño del Border.
      */
        top: isFirst ? Radius.circular(responsive.ip(0.3)) : Radius.zero,
        bottom: isLast && !isExpanded ? Radius.circular(responsive.ip(0.3)) : Radius.zero,
      )
    );
  } 
  BoxDecoration buildBoxDecoration(BuildContext context, bool isFirst, bool isLast) {
    final responsive = Responsive(context);

    return BoxDecoration(
      border: Border(
        left: BorderSide(width: responsive.ip(0.2)),
        top: BorderSide(width: responsive.ip(0.2)),
        right: BorderSide(width: responsive.ip(0.2)),
        bottom: isLast ? BorderSide(width: responsive.ip(0.2)) : BorderSide.none,
      ),
      borderRadius: BorderRadius.vertical(
        top: isFirst ? Radius.circular(responsive.ip(0.5)) : Radius.zero,
        bottom: isLast ? Radius.circular(responsive.ip(0.5)) : Radius.zero,
      )
    );
  }
}