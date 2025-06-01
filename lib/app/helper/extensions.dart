import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ThemeExtension on BuildContext{
  TextTheme textTheme() =>Theme.of(this).textTheme;
  
}

extension SizeExtension  on BuildContext {
  double heightPercent(double value) => MediaQuery.of(this).size.height * value; 
  double widthPercent(double value) => MediaQuery.of(this).size.width * value; 
}

extension NumberExtension on double {
   
   String toFixed() => NumberFormat('##,###.00', 'pt_BR').format(this);
  
}