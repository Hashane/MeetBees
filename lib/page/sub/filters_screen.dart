import 'package:flutter/material.dart';
import 'package:meet_ceylon/model/gender.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';
import 'package:meet_ceylon/widget/active_perks_card_widget.dart';
import 'package:meet_ceylon/widget/buttons_and_labels/gradient_label.dart';
import 'package:meet_ceylon/widget/radio_btn_tiles_widget.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<Gender> genders = [];
  int age, distance = 0;

  @override
  void initState() {
    super.initState();
    genders.add(new Gender("Male", Icons.person, false));
    genders.add(new Gender("Female", Icons.person, false));
    genders.add(new Gender("Others", Icons.person, false));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("Filters", style: Theme.of(context).textTheme.headline4),
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.secondary,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GradientLabel(
                width: SizeConfig.safeBlockHorizontal * 80,
                child: Text("Interested in"),
              ),
              SizedBox(
                ///Custom Gender radio tiles
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: genders.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashColor: Colors.pinkAccent,
                      onTap: () {
                        setState(() {
                          genders
                              .forEach((gender) => gender.isSelected = false);
                          genders[index].isSelected = true;
                        });
                      },
                      child: CustomRadio(genders[index]),
                    );
                  },
                ),
              ),
              GradientLabel(
                width: SizeConfig.safeBlockHorizontal * 80,
                child: Text("Age"),
              ),
              SliderWidget(
                onValChanged: (newVal) {
                  setState(() {
                    age = newVal;
                  });
                },
                labelKeyword: "YRS",
                min: 0,
              ),
              GradientLabel(
                width: SizeConfig.safeBlockHorizontal * 80,
                child: Text("Distance"),
              ),
              SliderWidget(
                onValChanged: (newVal) {
                  setState(() {
                    distance = newVal;
                  });
                },
                labelKeyword: "KM",
                min: 0,
              ),
              GradientLabel(
                width: SizeConfig.safeBlockHorizontal * 80,
                child: Text("Visa mode"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SliderWidget extends StatefulWidget {
  ///ValueChanged callback to pass data between widgets in the same screen
  final ValueChanged<int> onValChanged;
  final String labelKeyword;
  final double min;
  final double max;

  const SliderWidget(
      {Key key,
      @required this.onValChanged,
      @required this.labelKeyword,
      @required this.min,
      this.max})
      : super(key: key);

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double _currentSliderValue = 26;
  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentSliderValue,
      min: widget.min,
      max: 100,
      divisions: 100,
      label: _currentSliderValue.round().toString() + widget.labelKeyword,
      onChanged: (double value) {
        setState(
          () {
            _currentSliderValue = value;
            widget.onValChanged(_currentSliderValue.toInt());
          },
        );
      },
    );
  }
}
