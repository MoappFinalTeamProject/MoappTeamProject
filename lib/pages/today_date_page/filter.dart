import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moapp_team_project/src/app_state.dart';
import 'package:provider/provider.dart';

class FilterDatePartnerPage extends StatefulWidget {
  const FilterDatePartnerPage({super.key});

  @override
  State<FilterDatePartnerPage> createState() => _FilterDatePartnerPageState();
}

class _FilterDatePartnerPageState extends State<FilterDatePartnerPage> {
  double _currentSliderValue = 1;
  
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter page"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          appState.checkTime(),
          Row(
            children: [
              SizedBox(width: 20,),
              Expanded(
                child: Text(
                  '나의 선호도와 유사한 정도',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text(_currentSliderValue == 1? 
              "${appState.atLeastPerc}% 이상"  
              : _currentSliderValue == 0? 
                "제한 없음"
                :"${_currentSliderValue}% 이상",
                
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
              SizedBox(width: 20,),
            ],
          ),
          Slider(
            activeColor: Colors.pink[200],
            value: _currentSliderValue == 1? appState.atLeastPerc : _currentSliderValue,
            max: 100,
            divisions: 5,
            label: _currentSliderValue.round().toString(),
        onChanged: (double value) {
          setState(() {
            _currentSliderValue = value;
          });
        },
      ),
        ElevatedButton(onPressed: (){
          if(_currentSliderValue != 1.0){
            appState.setAtLeastPerc(_currentSliderValue);
            appState.addWishPercent(_currentSliderValue);
          }
          Navigator.pop(context, '/');
          }, child: Text("저장하기"))
        ],
      ),
    );
  }
}
