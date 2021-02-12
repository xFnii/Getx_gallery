

import 'package:flutter/material.dart';

abstract class Buffer{
  final int size;
  final data;
  final Function onOverflow;

  factory Buffer({@required int size, @required data, @required Function(dynamic) onOverflow}){
    if(data is List){
      return BufferList(size: size, data: data as List, onOverflow: onOverflow);
    }
  }

  add(dynamic elememnt);

}


class BufferList implements Buffer{
  @override
  final int size;
  @override
  final List data;
  @override
  final Function(List) onOverflow;

  BufferList({@required this.size, @required this.data, @required this.onOverflow}):super();

  @override
  void add(dynamic element){
    if (data.length >= size) {
      onOverflow(data);
      data.clear();
    } else {
      data.add(element);
    }
  }
}