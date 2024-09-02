import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/presentation/providers/providers.dart';
import 'package:rieu/presentation/widgets/widgets.dart';


class HistoryView extends StatelessWidget {
  final String courseId;

  const HistoryView({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;
    final courseProvider = context.read<CourseProvider>();
    final userProvider = context.read<UserProvider>();

    if (courseProvider.coursesMap[courseId]!.totalAuthorizedUsers > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: responsive.hp(2)),
            child: Text('Registro de asistencias:', style: texts.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
          ),
          _ExpandableList(
            isAdmin: userProvider.user.isAdmin,
            attendanceData: userProvider.user.courses[courseId]!,
            totalAuthorizedUsers: courseProvider.coursesMap[courseId]!.totalAuthorizedUsers,
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
  final List<AttendanceData> attendanceData;
  final int totalAuthorizedUsers;

  const _ExpandableList({
    this.isAdmin = false,
    required this.attendanceData,
    required this.totalAuthorizedUsers,
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
    controllers = List.generate(widget.attendanceData.length,  (_) => ExpandableController());
    keys.addAll(List.generate(widget.attendanceData.length, (_) => GlobalKey()));
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

    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        padding: EdgeInsets.only(bottom: responsive.hp(2)),
        itemCount: widget.attendanceData.length,
        itemBuilder: (context, index) {
          final bool isExpanded = controllers[index].expanded;
          final bool isFirst = index == 0;
          final bool isLast = index == widget.attendanceData.length - 1;
          final AttendanceData attendanceRecord = widget.attendanceData[index];
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
                  title: attendanceRecord.dateDuration,
                  titleStyle: textStyle,
                  trailing: widget.isAdmin
                    ? Text('${attendanceRecord.totalAttendance}/${widget.totalAuthorizedUsers}', style: textStyle)
                    : Text('${attendanceRecord.totalAttendance}/${attendanceRecord.records.length}', style: textStyle),
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
                    ...attendanceRecord.records.map((record) => buildTableBody(context, record: record)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  TableRow buildTableBody(BuildContext context, {required Record record}) {
    final responsive = Responsive(context);

    return TableRow(
      children: [
        TableCell(
          child: Container(
            height: responsive.hp(5),
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
            alignment: Alignment.centerLeft,
            child: Text(record.name),
          ),
        ),
        TableCell(child: Text(record.input, textAlign: TextAlign.center)),
        TableCell(child: Text(record.output, textAlign: TextAlign.center)),
        TableCell(
          child: record.coffee == null 
            ? const SizedBox()
            : record.coffee!
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