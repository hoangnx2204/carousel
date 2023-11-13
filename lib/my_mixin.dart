import 'package:flutter/material.dart';

mixin MyMixin on FocusNode {
  void sayHello() {
    print('AppLog: hello');
  }
}

class WFocusNode extends FocusNode with MyMixin {}

class WFocusNode2 extends FocusNode with MyMixin {}

void myFunc(FocusNode node) {
  if (node is MyMixin) {
    node.sayHello();
  }
}
