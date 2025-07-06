import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants.dart';
import '../../../theme.dart';
import '../../../models/venue.dart';
import '../../../styles/ui_styles.dart';
import '../../../view_models/action_view_model.dart';

class VenueChoicer extends ConsumerStatefulWidget {
  const VenueChoicer({super.key, required this.venueList});
  final List<Venue> venueList;

  @override
  ConsumerState<VenueChoicer> createState() => _VenueChoicerState();
}

class _VenueChoicerState extends ConsumerState<VenueChoicer> with AutomaticKeepAliveClientMixin{
  String selectedVenue = '';
  List<MenuItemButton> miList = [];

  @override
  void initState() {
    selectedVenue = ref.read(asyncActionProvider).value!.selectedVenue.venueName;
    for (var venue in widget.venueList){
      miList.add(MenuItemButton(
        onPressed: (){
        selectedVenue = venue.venueName;
        ref.read(asyncActionProvider.notifier).selectVenue(venue);
        setState(() {});}, child: Text(venue.venueName,
          style: customTextStyle(null, 18.0, 'Light')),));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // ???
    final size = MediaQuery.of(context).size;
    return MenuAnchor(
      menuChildren: miList,
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return TextButton(
          style:  OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(5),
            backgroundColor: size.width > 700
                ? Colors.white
                : MaterialTheme.lightScheme().primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            side: BorderSide(width: 1.2, color: MaterialTheme.lightScheme().primary),
          ),
          onPressed: /*miList.length > 1 ? () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          } :*/ null,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
            child: Row(
              spacing: 5,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(child: Text(selectedVenue,
                    textAlign:TextAlign.left,
                    maxLines: 2,
                    style: customTextStyle(size.width > 700
                        ? MaterialTheme.lightScheme().primary
                        : Colors.white, 16.0, 'Regular'))),
                /*if (miList.length > 1)
                  Icon(Icons.arrow_drop_down_sharp,
                    color: size.width > 700
                        ? MaterialTheme.lightScheme().primary
                        : Colors.white, size: 20,)*/
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class ActionEventCalendar extends ConsumerStatefulWidget {
  const ActionEventCalendar({super.key, required this.venue});
  final Venue venue;

  @override
  ConsumerState<ActionEventCalendar> createState() => _ActionEventCalendarState();
}

class _ActionEventCalendarState extends ConsumerState<ActionEventCalendar> {
  late int? _value;
  late int index;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _value = ref.read(asyncActionProvider).value!.selectedActionEvent!.actionEventId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        if (widget.venue.actionEventList.length > 4) SizedBox(
          width: 40.0, height: 48.0,
          child: IconButton(
              onPressed: (){scrollController.animateTo(scrollController.offset - 300,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);},
              icon: Icon(Icons.arrow_back_ios_new_rounded, size: 24,
                color: MaterialTheme.lightScheme().tertiary,)),
        ),
        Flexible(
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                stops: [0.0, 0.005, 0.995, 1.0],
                colors: <Color>[Colors.transparent, Colors.white,
                  Colors.white, Colors.transparent,],).createShader(bounds);
            },
            child: SizedBox(
              height: 70,
              child: ListView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: List<Widget>.generate(widget.venue.actionEventList.length,
                      (int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ChoiceChip(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: MaterialTheme.lightScheme().tertiary, width: 1.2),
                          borderRadius: BorderRadius.circular(12),),
                        showCheckmark: false,
                        //avatar: Icon(CupertinoIcons.calendar_today, color: MaterialTheme.lightScheme().tertiary, size: 18),
                        checkmarkColor: MaterialTheme.lightScheme().onTertiary,
                        selectedColor: MaterialTheme.lightScheme().tertiary,
                        label: date == 'off' ? Text(widget.venue.actionEventList[index].currency,
                          style: customTextStyle(_value == widget.venue.actionEventList[index].actionEventId
                              ? Colors.white : null, null, 'Regular'),)
                            : ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 70),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(widget.venue.actionEventList[index].monthDay,
                                style: customTextStyle(_value == widget.venue.actionEventList[index].actionEventId
                                    ? MaterialTheme.lightScheme().onTertiary : MaterialTheme.lightScheme().tertiary, 16, 'Regular'),),
                              Text(widget.venue.actionEventList[index].weekDay
                                  + " "+ widget.venue.actionEventList[index].time,
                                style: customTextStyle(_value == widget.venue.actionEventList[index].actionEventId
                                    ? MaterialTheme.lightScheme().onTertiary : MaterialTheme.lightScheme().tertiary, 16, 'Regular'),),
                            ],
                          ),
                        ),
                        selected: _value == widget.venue.actionEventList[index].actionEventId,
                        onSelected: (bool selected) {
                          setState(() {
                            _value = widget.venue.actionEventList[index].actionEventId;
                            if (selected){
                              ref.read(asyncActionProvider.notifier)
                                  .selectActionEvent(widget.venue.actionEventList[index]);
                            }
                          });
                        },
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ),
        if (widget.venue.actionEventList.length > 4) SizedBox(
          width: 40.0, height: 48.0,
          child: IconButton(
              onPressed: (){
                scrollController.animateTo(scrollController.offset + 300,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);},
              icon: Icon(Icons.arrow_forward_ios_rounded, size: 24,
                color: MaterialTheme.lightScheme().tertiary,)),
        )
      ],
    );
  }
}

class ActionEventMobileCalendar extends ConsumerStatefulWidget {
  const ActionEventMobileCalendar({super.key, required this.venue});
  final Venue venue;

  @override
  ConsumerState<ActionEventMobileCalendar> createState() => _ActionEventMobileCalendarState();
}

class _ActionEventMobileCalendarState extends ConsumerState<ActionEventMobileCalendar>  {
  late int? _value;
  late int index;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _value = ref.read(asyncActionProvider).value!.selectedActionEvent!.actionEventId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55.0,
      child: ListView(
        shrinkWrap: true,
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        children: List<Widget>.generate(widget.venue.actionEventList.length,
              (int index) {
            return Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: ChoiceChip(
                showCheckmark: false,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color:  MaterialTheme.lightScheme().tertiary, width: 1.2),
                  borderRadius: BorderRadius.circular(15),),
                checkmarkColor: Colors.white,
                selectedColor: MaterialTheme.lightScheme().tertiary,
                label: date == 'off' ? Text(widget.venue.actionEventList[index].currency,
                  style: customTextStyle(_value == widget.venue.actionEventList[index].actionEventId
                      ? Colors.white : null, null, 'Regular'),)
                    : ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 70),
                      child: Column(
                        children: [
                          Text(widget.venue.actionEventList[index].monthDay,
                            style: customTextStyle(_value == widget.venue.actionEventList[index].actionEventId
                            ? MaterialTheme.lightScheme().onTertiary : MaterialTheme.lightScheme().tertiary, null, 'Regular'),),
                          Text(widget.venue.actionEventList[index].weekDay
                              + " "+ widget.venue.actionEventList[index].time,
                            style: customTextStyle(_value == widget.venue.actionEventList[index].actionEventId
                                ? MaterialTheme.lightScheme().onTertiary : MaterialTheme.lightScheme().tertiary, null, 'Regular'),),
                        ],
                      ),
                    ),
                selected: _value == widget.venue.actionEventList[index].actionEventId,
                onSelected: (bool selected) {
                  setState(() {
                    _value = widget.venue.actionEventList[index].actionEventId;
                    if (selected){
                      ref.read(asyncActionProvider.notifier)
                          .selectActionEvent(widget.venue.actionEventList[index]);
                    }
                  });
                },
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}