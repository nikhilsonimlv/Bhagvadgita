import 'dart:math';

import 'package:bhagavadgita/src/bloc/all_chapters_bloc.dart';
import 'package:bhagavadgita/src/bloc/all_chapters_event.dart';
import 'package:bhagavadgita/src/bloc/all_chapters_state.dart';
import 'package:bhagavadgita/src/bloc/token_bloc.dart';
import 'package:bhagavadgita/src/resources/model/all_chapters_model.dart';
import 'package:bhagavadgita/src/resources/repository/common_repository.dart';
import 'package:bhagavadgita/src/ui_util/animated_background.dart';
import 'package:bhagavadgita/src/ui_util/animated_wave.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  final CommonRepository commonRepository;

  HomePage({this.commonRepository});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TokenBloc _tokenBloc;
  AllChaptersBloc _allChaptersBloc;

  @override
  void initState() {
    super.initState();
    _tokenBloc = TokenBloc(commonRepository: widget.commonRepository);
    _allChaptersBloc =
        AllChaptersBloc(commonRepository: widget.commonRepository);
    _allChaptersBloc.dispatch(AllChaptersTestEvent());
  }

  @override
  void dispose() {
    super.dispose();
    _tokenBloc.dispose();
    _allChaptersBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //as bloc provider expect bloc and child(widget)
    return BlocProviderTree(
      blocProviders: [
        BlocProvider<TokenBloc>(bloc: _tokenBloc),
        BlocProvider<AllChaptersBloc>(bloc: _allChaptersBloc),
      ],
      child: SafeArea(child: ShowChapters()),
    );
  }
}

class ShowChapters extends StatefulWidget {
  @override
  _ShowChaptersState createState() => _ShowChaptersState();
}

class _ShowChaptersState extends State<ShowChapters> {
  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    AllChaptersBloc allChaptersBloc = BlocProvider.of<AllChaptersBloc>(context);

    return BlocListener(
        bloc: BlocProvider.of<AllChaptersBloc>(context),
        listener: (context, state) {
          if (state is AllChaptersFetchedState) {
            print("Hello***************************************************");
          }
        },
        child: BlocBuilder(
            bloc: BlocProvider.of<AllChaptersBloc>(context),
            builder: (context, state) {
              print("Current State is  " + state.toString());
              if (state is AllChaptersUnInitializedState) {
                return Text("AllChaptersUnInitializedState");
              } else if (state is AllChaptersEmptyState) {
                return Text("AllChaptersEmptyState");
              } else if (state is AllChaptersErrorState) {
                return Text("AllChaptersErrorState");
              } else if (state is AllChaptersFetchingState) {
                return Center(child: CircularProgressIndicator());
              } else {
                final allChaptersGetState = state as AllChaptersFetchedState;
                print("Fetched data is " +
                    allChaptersGetState
                        .allChaptersModel.chapterList[0].chapterSummary);
                print("Fetched length is " +
                    allChaptersGetState.allChaptersModel.chapterList.length
                        .toString());
                print("***************************************");
                /* return Text(allChaptersGetState
            .allChaptersModel.chapterList[0].chapterSummary);*/

                return AnimatedHorizontalScrollView(
                  allChaptersModel: allChaptersGetState.allChaptersModel,
                );
              }
            }));
  }
}

class AnimatedHorizontalScrollView extends StatefulWidget {
  AllChaptersModel allChaptersModel;

  AnimatedHorizontalScrollView({this.allChaptersModel});

  @override
  _AnimatedHorizontalScrollViewState createState() =>
      _AnimatedHorizontalScrollViewState();
}

class _AnimatedHorizontalScrollViewState
    extends State<AnimatedHorizontalScrollView> {
  PageController _pageController;

  int currentPage = 0;

  @override
  void initState() {
    _pageController = PageController(
        initialPage: currentPage, keepPage: false, viewportFraction: 0.8);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(child: AnimatedBackground()),
          onBottom(AnimatedWave(
            height: 180,
            speed: 1.0,
          )),
          onBottom(AnimatedWave(
            height: 120,
            speed: 0.9,
            offset: pi,
          )),
          onBottom(AnimatedWave(
            height: 220,
            speed: 1.2,
            offset: pi / 2,
          )),
          /*Container(
            // color: Colors.yellowAccent,
            child: CustomPaintDesign(),
          ),*/
          Container(
            child: PageView.builder(
              itemBuilder: (context, index) {
                return itemBuilder(index);
              },
              itemCount: widget.allChaptersModel.chapterList.length,
              controller: _pageController,
              pageSnapping: true,
              onPageChanged: _onPageChanged,
              physics: ClampingScrollPhysics(),
            ),
          )
        ],
      ),
    );
  }

  Widget itemBuilder(int index) {
    return Container(
      child: AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          double value = 1.0;
          if (_pageController.position.haveDimensions) {
            value = _pageController.page - index;
            value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
            return Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: Curves.easeIn.transform(value) * 500.0,
                width: 500.0,
                margin: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
                child: child,
              ),
            );
          } else {
            return Align(
              alignment: Alignment.topCenter,
              child: Container(
                height:
                    Curves.easeIn.transform(index == 0 ? value : value * 0.5) *
                        500.0,
                width: 500.0,
                margin: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
                child: child,
              ),
            );
          }
        },
        child: Material(
          color: Colors.deepOrange[200],
          elevation: 6.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0)),
          ),
          borderOnForeground: true,
          child: internalCard(widget.allChaptersModel, index),
        ),
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      print(index);
      currentPage = index;
    });
  }
}

Widget internalCard(AllChaptersModel allChapterModel, int index) {
  return Padding(
    padding: const EdgeInsets.only(
      left: 8.0,
      right: 8.0,
      bottom: 8.0,
    ),
    child: Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0)),
      ),
      borderOnForeground: true,
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    FittedBox(fit: BoxFit.fitWidth,alignment: Alignment.center,
                      child: Text(
                        allChapterModel.chapterList[index].name,
                        style: TextStyle(fontSize: 30.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Text(
                      allChapterModel.chapterList[index].nameMeaning,
                      style: TextStyle(fontSize: 20.0),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0,),

                    Text(
                      allChapterModel.chapterList[index].chapterSummary,
                      textAlign: TextAlign.justify,
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

onBottom(Widget child) => Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: child,
      ),
    );
