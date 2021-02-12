class Profiler{
  int milli=0;
  int count=0;


  void add(int milli){
    this.milli=this.milli*count/++count as int;
  }
}