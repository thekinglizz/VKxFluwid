import 'package:flapp_widget/view_models/ga_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'package:flapp_widget/styles/ui_styles.dart';
import 'package:flapp_widget/ui/screens/error_screen.dart';
import 'package:flapp_widget/ui/widgets/action_mode_screen_widgets/auth_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import '../../i18n/app_localizations.dart';
import '../../theme.dart';
import '../../lib_color_schemes.g.dart';
import '../../models/action_event.dart';
import '../../models/venue.dart';
import '../../services/router.dart';
import '../../view_models/action_view_model.dart';
import '../../view_models/scheme_view_model.dart';
import '../widgets/action_mode_screen_widgets/access_code_area.dart';
import '../widgets/action_mode_screen_widgets/choicers.dart';
import '../widgets/ga_widgets/category_card.dart';
import '../widgets/action_mode_screen_widgets/widget_builders.dart';
import '../widgets/scheme_widgets/scheme_widget.dart';
import 'm_action_mode_screen.dart';

class KeepPageAlive extends StatefulWidget {
  const KeepPageAlive({Key? key, this.child,}) : super(key: key);
  final Widget? child;
  @override
  KeepPageAliveState createState() => KeepPageAliveState();
}

class KeepPageAliveState extends State<KeepPageAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child!;
  }

  @override
  bool get wantKeepAlive => true;
}

class _CartBadgeForDesktop extends StatefulWidget {
  const _CartBadgeForDesktop({Key? key});

  @override
  State<_CartBadgeForDesktop> createState() => _CartBadgeForDesktopState();
}

class _CartBadgeForDesktopState extends State<_CartBadgeForDesktop> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: (){buildShowModalCart(context);},
          child: CartWidgetIcon(iconData: CupertinoIcons.shopping_cart, size: 45.0,
              color: MaterialTheme.lightScheme().onSurfaceVariant),
        )
    );
  }
}

class Fluwid extends StatelessWidget {
  const Fluwid({super.key} );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale(Intl.shortLocale(Intl.defaultLocale!)),
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Fluwid',
      routes: {
        '/': (context) => const SizedBox.shrink(),
      },
      //initialRoute: '/',
      onGenerateInitialRoutes: (route) {
        if (Uri.parse(route).queryParameters.isNotEmpty){
          setGlobalUriParams(Uri.parse(route));
        }
        return RouteGenerator.generateHomePage(route);
      },
    );
  }
}

class _AccessCodeVerification extends StatelessWidget {
  const _AccessCodeVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MaterialTheme.lightScheme().surfaceContainer,
      body: Center(
        child: Card.filled(
          elevation: 0,
          margin: const EdgeInsets.all(0),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text('Введите код доступа к представлению:',
                  style: customTextStyle(MaterialTheme.lightScheme().onSurfaceVariant,
                      screenWidth > 900 ? 22 : 18, 'Regular'),),
                const AccessCodeInput()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FluwidHome extends ConsumerStatefulWidget {
  const FluwidHome({super.key});

  @override
  ConsumerState<FluwidHome> createState() => _FluwidHomeState();
}

class _FluwidHomeState extends ConsumerState<FluwidHome> {
  @override
  Widget build(BuildContext context) {
    final action = ref.watch(asyncActionProvider);
    bool isDesktop = MediaQuery.of(context).size.width >= 700;
    if (isDesktop) {tabIndex.value = 0;}
    return action.when(
        data: (data){
          return ValueListenableBuilder<int>(
            builder: (BuildContext context, int value, Widget? child) {
              return Scaffold(
                backgroundColor: const Color(0xfff2f3f5),
                extendBody: true,
                appBar: value == 0 ? AppBar(
                  shadowColor: Theme.of(context).colorScheme.shadow,
                  backgroundColor: const Color(0xfff2f3f5),
                  surfaceTintColor: MaterialTheme.lightScheme().surfaceContainerLow,
                  toolbarHeight: 80,
                  centerTitle: true,
                  title: DefaultSelectionStyle(
                    mouseCursor: SystemMouseCursors.basic,
                    child: SelectableRegion(
                      selectionControls: materialTextSelectionControls,
                      child: Row(
                        spacing: 20,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(data.actionExt.actionName, maxLines: 2,
                              textAlign: TextAlign.center,
                              style: customTextStyle(MaterialTheme.lightScheme().onSurfaceVariant,
                                  isDesktop ? 30 : 20, 'Light')
                                  .copyWith(fontWeight: FontWeight.bold),),
                          ),
                          if (isDesktop) const _CartBadgeForDesktop(),
                        ],
                      ),
                    ),
                  ),
                ) : null,
                bottomNavigationBar: !isDesktop ? NavigationBar(
                  height: 50,
                  backgroundColor: darken(const Color(0xfff2f3f5), 0.07),
                  onDestinationSelected: (int index) {setState(() {tabIndex.value = index;});},
                  selectedIndex: value,
                  indicatorColor: MaterialTheme.lightScheme().outlineVariant,
                  destinations: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 22.0),
                      child: NavigationDestination(
                        selectedIcon: Icon(CupertinoIcons.house_fill,
                          size: 30.0, color: MaterialTheme.lightScheme().onSurfaceVariant,),
                        icon: Icon(CupertinoIcons.house,
                          color: MaterialTheme.lightScheme().onSurfaceVariant, size: 30.0,),
                        label: '',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 22.0),
                      child: NavigationDestination(
                        selectedIcon: CartWidgetIcon(iconData: CupertinoIcons.cart_fill,
                            size: 30.0,  color: MaterialTheme.lightScheme().onSurfaceVariant),
                        icon: CartWidgetIcon(iconData: CupertinoIcons.cart,
                            size: 30.0, color: MaterialTheme.lightScheme().onSurfaceVariant),
                        label: '',
                      ),
                    ),
                  ],
                ) : null,
                body: <Widget>[_ContentPreBuilder(kdpRequired: data.actionExt.kdp), const Center(child: CartBuilder())][value],
              );
            }, valueListenable: tabIndex,
          );
        },
        error: (error, trace){
          return  error.toString().contains('empty')
              ?  const ErrorScreen(error: 'Актуальных сеансов нет')
              : const ErrorScreen(error: 'Error');
        },
        loading: (){
          return Center(
            child: CircularProgressIndicator(
              color: MaterialTheme.lightScheme().primary,
            ),
          );
        }
    );
  }
}

class _ContentPreBuilder extends StatelessWidget {
  const _ContentPreBuilder({super.key, required this.kdpRequired});
  final bool kdpRequired;

  @override
  Widget build(BuildContext context) {
    if (kdpRequired == false){
      return const _Content();
    } else {
      return ValueListenableBuilder<int>(
          valueListenable: accessCodeNotifier,
          builder: (BuildContext context, int value, Widget? child) {
            if (value != 0){return const _Content();}
            else {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: _AccessCodeVerification(),
              );
            }
          }
      );
    }
  }
}

class _Content extends ConsumerWidget {
  const _Content({super.key,});

  @override
  Widget build(BuildContext context, ref) {
    final ScrollController scrollController = ScrollController();
    final schemeType = ref.read(asyncActionProvider).value!.selectedActionEvent!.schemeType;
    return Theme(
      data: Theme.of(context).copyWith(
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.
            all(Theme.of(context).colorScheme.outline),
          )),
      child: MediaQuery.of(context).size.width < 700 ? _MobileHeader(sc: scrollController)
          : Scrollbar(
        controller: scrollController,
        thumbVisibility: screenWidth > 1200 ? true : false,
        child: ValueListenableBuilder(
          valueListenable: physics,
          builder: (BuildContext context, ScrollPhysics value, Widget? child) {
            return  SingleChildScrollView(
              controller: scrollController,
              physics: value,
              child: Padding(padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  spacing: 50,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: schemeType == SchemeType.mixed ? const Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          _Header(),
                          _Body()
                        ],
                      ) : const Column(
                        spacing: 16,
                        children: [
                          _Header(),
                          _Body()
                        ],
                      ),
                    ),
                  ],
                ),
              )
            );
          },
        ),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    Venue venue = ref.watch(asyncActionProvider.select((avm)=>avm.value!.selectedVenue));
    ActionEvent aEvent = ref.watch(asyncActionProvider).value!.selectedActionEvent!;

    List<Venue> vList = ref.read(asyncActionProvider).value!.actionExt.venueList;
    String actionImage = ref.read(asyncActionProvider).value!.actionExt.smallPosterUrl;
    String actionAge = ref.read(asyncActionProvider).value!.actionExt.age;
    String fullName = ref.read(asyncActionProvider).value!.actionExt.fullActionName;
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800, minWidth: 800),
          child: Container(
            decoration: const BoxDecoration(
              //border:  Border.all(color: Colors.white, width: 1.2),
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(40,0,40, 32 ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 22,
                children: <Widget>[
                  // Зона данных о площадке и орге
                  /*Row(
                    spacing: 16,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            child: Container(
                                color: MaterialTheme.lightScheme().surfaceContainer,
                                child: Image(image: NetworkImage(actionImage),
                                  fit: BoxFit.cover, height: 220, width: 220,
                                    errorBuilder: (context, object, st) {
                                      return Image.asset('images/noposter.png',
                                          height: 220, width: 220, fit: BoxFit.cover);},)),
                          ),
                          if (actionAge.length <=3) Positioned(
                            bottom: 16,
                            left: 16,
                            child: Container(
                              height: 40,
                              width: 50,
                              decoration: BoxDecoration(
                                color: MaterialTheme.lightScheme().primary,
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                              ),
                              child: Center(
                                child: Text(actionAge,
                                  style: customTextStyle(MaterialTheme.lightScheme().onPrimary, 20, 'Regular'),),
                              ),
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: Container(
                          height: 220,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,//MaterialTheme.lightScheme().surfaceContainer,
                            border: Border.all(color:  Colors.grey.shade300, width: 1.5),
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: DefaultSelectionStyle(
                              mouseCursor: SystemMouseCursors.basic,
                              child: SelectableRegion(
                                selectionControls: materialTextSelectionControls,
                                child: Column(
                                  spacing: 16,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(fullName, maxLines: 2,
                                        style: customTextStyle(MaterialTheme.lightScheme()
                                            .onSurfaceVariant, 18, 'Light').copyWith(fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left, overflow: TextOverflow.ellipsis, ),
                                    VenueChoicer(venueList: vList,),
                                    if (venue.address.isNotEmpty && MediaQuery.of(context).size.width > 750)
                                      Text.rich(
                                         TextSpan(
                                            style: customTextStyle(MaterialTheme.lightScheme()
                                                .onSurfaceVariant, 16, 'Light').copyWith(height:1.5),
                                            children:[
                                              WidgetSpan(
                                                child: Icon(Icons.location_on_outlined, size: 16,
                                                    color: MaterialTheme.lightScheme().onSurfaceVariant),
                                              ),
                                              TextSpan(
                                                text: " ${venue.address}",),
                                            ]
                                          ),
                                        maxLines: 2, textAlign: TextAlign.justify,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),*/
                  SizedBox(height: 10,),
                  // Зона регистрации
                  AuthorisationArea(),
                ],
              ),
            ),
          ),
        ),
        /*ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800, minWidth: 800),
          child: Container(
            decoration: const BoxDecoration(
              //border: Border.all(color: MaterialTheme.lightScheme().outlineVariant, width: 1.2),
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ActionEventCalendar(venue:  venue, key: ObjectKey(venue),),
            ),
          ),
        ),*/
        if (aEvent.schemeType == SchemeType.mixed) ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child:  Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                //border:  Border.all(color: MaterialTheme.lightScheme().outlineVariant, width: 1.2),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              margin: const EdgeInsets.all(0),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: GeneralAdmissionArea(actionEvent: aEvent,),
              )),
        ),
      ],
    );
  }
}

class _MobileHeader extends ConsumerWidget {
  const _MobileHeader({Key? key, required this.sc}) : super(key: key);
  final ScrollController sc;

  @override
  Widget build(BuildContext context, ref) {
    Venue venue = ref.watch(asyncActionProvider.select((avm)=>avm.value!.selectedVenue));
    ActionEvent aEvent = ref.watch(asyncActionProvider).value!.selectedActionEvent!;

    List<Venue> vList = ref.read(asyncActionProvider).value!.actionExt.venueList;
    String actionAge = ref.read(asyncActionProvider).value!.actionExt.age;
    return SafeArea(
      child: DefaultSelectionStyle(
        mouseCursor: SystemMouseCursors.basic,
        child: SelectableRegion(
          selectionControls: materialTextSelectionControls,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              controller: sc,
              children: [
                const SizedBox(height: 8,),
                Card(
                  color: Colors.white, margin: const EdgeInsets.all(0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: 5,
                            children: [
                              Expanded(child: VenueChoicer(venueList: vList,)),
                              if (actionAge.length <=3) Container(
                                width: 40,
                                height: 35,
                                decoration: BoxDecoration(
                                  border: Border.all(color: MaterialTheme.lightScheme().primary, width: 1.5),
                                  color: MaterialTheme.lightScheme().primary,
                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                ),
                                child: Center(
                                  child: Text(actionAge,
                                    style: customTextStyle(MaterialTheme
                                        .lightScheme().onPrimary, 16, 'Regular'),),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (venue.address.isNotEmpty) Row(
                          spacing: 5,
                          children: [
                            Icon(Icons.location_on_outlined, size: 22,
                                color: MaterialTheme.lightScheme().onSurfaceVariant),
                            Flexible(
                              child: Text(venue.address,
                                style: customTextStyle(MaterialTheme.lightScheme()
                                    .onSurfaceVariant, 16, 'Light').copyWith(fontWeight: FontWeight.w600), maxLines: 3,
                                overflow:TextOverflow.fade, textAlign: TextAlign.left,),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8,),
                const Card(
                  color: Colors.white, margin: EdgeInsets.all(0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0,16.0,0,16),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: AuthorisationArea(),
                    ),
                  ),
                ),
                if (aEvent.schemeType == SchemeType.assignedSeats ||
                    aEvent.schemeType == SchemeType.mixed)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Card(
                      color: Colors.white, margin: const EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 32,
                          children: [
                            //ActionEventMobileCalendar(venue: venue, key: ObjectKey(venue),),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 12,
                              children: [
                                if (aEvent.schemeType == SchemeType.assignedSeats)
                                  if (date !="off") Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(CupertinoIcons.calendar, size: 22,
                                        color: MaterialTheme.lightScheme().onSurfaceVariant),
                                    Text(aEvent.date,
                                      style: customTextStyle(MaterialTheme.lightScheme()
                                          .onSurfaceVariant, 22, 'Regular'),),
                                  ],
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: FloatingActionButton.extended(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15)),
                                    backgroundColor:  MaterialTheme.lightScheme().tertiary,//MaterialTheme.lightScheme().tertiaryContainer,
                                    label: Text(AppLocalizations.of(context)!.selectSeatsLabel,
                                        style: customTextStyle(MaterialTheme.lightScheme().onTertiary, 18, 'Regular')),
                                    icon: Icon(CupertinoIcons.hand_draw_fill,
                                      color: MaterialTheme.lightScheme().onTertiary,),
                                    onPressed: (){Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => const MobileSchemeScreen()),);
                                    },),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                                    ),
                  ),
                const SizedBox(height: 8,),
                if (aEvent.categoryLimitList.isNotEmpty) Card(
                    margin: const EdgeInsets.all(0),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: GeneralAdmissionArea(actionEvent: aEvent,),
                    )
                ),
                const SizedBox(height: 8,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({Key? key,});

  @override
  Widget build(BuildContext context, ref) {
    ActionEvent aEvent = ref.watch(asyncActionProvider).value!.selectedActionEvent!;
    //Map<String, List<dynamic>> dateMap = ref.read(asyncActionProvider).value!.actionEventsGroupedByDate;
    //DateTime? selectedDate = ref.read(asyncActionProvider).value!.selectedDate;
    return  SizedBox(
      width: 800,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              //border: Border.all(color: MaterialTheme.lightScheme().outlineVariant, width: 1.2),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            margin: const EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildBodyEventData(aEvent, context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Image(image: AssetImage('images/logo2_on_white.png'),
                  width: 30, height: 30,),
                Text(version),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GeneralAdmissionArea extends ConsumerWidget {
  const GeneralAdmissionArea({super.key, required this.actionEvent});
  final ActionEvent actionEvent;

  @override
  Widget build(BuildContext context, ref) {
    List<CategoryCard> cList = [];
    for (var category in ref.read(categoriesProvider)[actionEvent.actionEventId]!){
      cList.add(CategoryCard(actionEventId:actionEvent.actionEventId,
        category: category, key: UniqueKey(), currency: actionEvent.currency,));
    }
    return cList.isNotEmpty ? Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (date !="off") Row(
                children: [
                  Icon(CupertinoIcons.calendar, size: 22,
                      color: MaterialTheme.lightScheme().onSurfaceVariant),
                  Text(actionEvent.date,
                    style: customTextStyle(MaterialTheme.lightScheme().onSurfaceVariant, 22, 'Regular'),),
                ],
              ),
              if (hint != "off") SizedBox(
                width: screenWidth < 700 ? screenWidth : null,
                child: Text(AppLocalizations.of(context)!.hint1,
                  textAlign: TextAlign.justify,
                  style: customTextStyle(MaterialTheme
                      .lightScheme().onSurfaceVariant,screenWidth < 700 ? 17 : 20, 'Light'),),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: darken(const Color(0xfff2f3f5)),
            borderRadius: BorderRadius.circular(screenWidth > 700 ? 20 : 12),),
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width > 700 ? 16 : 10),
            child: Column(spacing: screenWidth > 900 ? 16 : 10, children: cList.toList()),
          ),
        ),
      ],
    ) : const SizedBox.shrink();
    /*Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(AppLocalizations.of(context)!.emptyGA,
        style: customTextStyle(MaterialTheme.lightScheme().onSurfaceVariant, 20.0, 'Light'),),
    );*/
  }
}

class SchemeArea extends ConsumerWidget {
  const SchemeArea({super.key,});
  @override
  Widget build(BuildContext context, ref) {
    final scheme = ref.watch(asyncSchemeProvider);
    final ScrollController scrollController = ScrollController();
    return scheme.when(
        data: (data){
          if (scheme.isRefreshing){
            return SizedBox(width: 800.0,
                child: Center(child: CircularProgressIndicator(
                  color: MaterialTheme.lightScheme().primary,)));
          }
          return Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: [
              //Категории
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (data.schemeData.categoryInfoWidgetList.length > 5)
                      IconButton(onPressed: (){
                        scrollController.animateTo(scrollController.offset - 200,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                        }, icon: Icon(Icons.arrow_back_ios_new,
                        color: MaterialTheme.lightScheme().onSurfaceVariant,)),
                    Flexible(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height : 50.0,
                          child: ListView(
                            controller: scrollController, shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: data.schemeData.categoryInfoWidgetList,
                          ),
                        ),
                      ),
                    ),
                    if (data.schemeData.categoryInfoWidgetList.length > 5)
                      IconButton(onPressed: (){
                        scrollController.animateTo(scrollController.offset + 300,
                            duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                        }, icon: Icon(Icons.arrow_forward_ios,
                        color: MaterialTheme.lightScheme().onSurfaceVariant,)),
                  ],
                ),
              ),
              //Схема
              Stack(
                children: [
                  SchemeViewer(size: data.schemeData.ivSize, siData: data.schemeData.siData,
                     sectorList: data.schemeData.sectorList, schemeCoef: data.schemeData.schemeCoef),
                  //Кнопка перехода к корзине
                  if (data.selectedSeats.isNotEmpty && totalSum.value > 0)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: SizedBox(
                        child: Card(
                          elevation: 4,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${data.selectedSeats
                                        .where((seat)=>data.selectedTariffSeats.containsKey(seat) ||
                                        seat.category.tariffIdMap.isEmpty).length} '
                                        '${AppLocalizations.of(context)!.numberOfTickets}',
                                      style: customTextStyle(null, 18, 'Light'),),
                                    Text('${totalSum.value} ${data.schemeData.currency}',
                                      style: customTextStyle(null, 18, 'Light'),)
                                  ],
                                ),
                                const SizedBox(width: 10.0,),
                                SizedBox(
                                  height: 40,
                                  child: FloatingActionButton.extended(
                                    elevation: 0,
                                    backgroundColor: Colors.green,
                                    onPressed: (){buildShowModalCart(context);},
                                    label: Text(AppLocalizations.of(context)!.goToCartLabel,
                                        style: customTextStyle(Colors.white, 16, 'Regular')),),
                                )
                              ],),
                          ),
                        ),
                      ),
                    ),

                ],
              ),
            ],
          );
        },
        error: (error, trace){
          return const ErrorScreen(error: 'Error');
        },
        loading: (){
          return SizedBox(width: 800.0, height: 100.0,
              child: Center(child: CircularProgressIndicator(
                  color:MaterialTheme.lightScheme().primary)));
        });
  }
}
