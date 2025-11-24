import 'dart:io';
import 'dart:convert';

void main() {
  final file = File('numbers_1000000-7k.json');
  if (!file.existsSync()){
    print('\x1b[38;2;255;99;99m Number List has not been found \n Exiting.\x1b[0m');
    return;
  }

  final List<dynamic> data = jsonDecode(file.readAsStringSync());
  final List<int> original = data.map((e) => e as int).toList();

  // number of times to run each algorithm (can be passed as first CLI arg)
  final runs = 25;

  // run benchmark and write results
  final result = runBenchmark(original, runs);

  // final outName = 'benchmark_size_${original.length}_runs_${runs}.json';
  // File(outName).writeAsStringSync(jsonEncode(result));
  // print('Wrote benchmark summary to $outName');

  final outTxt = 'benchmark_size_${original.length}_${runs}r_${result['max_digits']}k.txt';
  final buf = StringBuffer();
  buf.writeln('Benchmark report');
  buf.writeln('  Array size: ${result['size']}');
  buf.writeln('  Runs: ${result['runs']}');
  buf.writeln('  Max Key Length: ${result['max_digits']}');
  buf.writeln('');
  buf.writeln('  Radix Sort:');
  buf.writeln('    avg_ms: ${result['radix']['avg_ms']}ms');
  buf.writeln('    times_ms: ${(result['radix']['times_ms'] as List).join('ms - ')}ms');
  buf.writeln('');
  buf.writeln('  Quick Sort:');
  buf.writeln('    avg_ms: ${result['quick']['avg_ms']}ms');
  buf.writeln('    times_ms: ${(result['quick']['times_ms'] as List).join('ms - ')}ms');
  buf.writeln('');
  buf.writeln('  Merge Sort:');
  buf.writeln('    avg_ms: ${result['merge']['avg_ms']}ms');
  buf.writeln('    times_ms: ${(result['merge']['times_ms'] as List).join('ms - ')}ms');
  buf.writeln('');
  buf.writeln('  Heap Sort:');
  buf.writeln('    avg_ms: ${result['heap']['avg_ms']}ms');
  buf.writeln('    times_ms: ${(result['heap']['times_ms'] as List).join('ms - ')}ms');
  File(outTxt).writeAsStringSync(buf.toString());
  print('\x1b[38;2;100;255;100mWrote plain-text report to $outTxt\x1b[0m');

  // final List<int> oneList = List.from(original);
  // final List<int> twoList = List.from(original);

  // print('\x1b[38;2;255;224;240mSorting ${original.length} integers...\x1b[0m');
  // print('\x1b[38;2;255;224;240m--------------------------------------\x1b[0m');

  // // timing system
  // final radixStart = DateTime.now();
  // radixSort(oneList);
  // final radixEnd = DateTime.now();
  // final radixDuration = radixEnd.difference(radixStart).inMilliseconds;

  // final mergeStart = DateTime.now();
  // mergeSort(twoList);
  // final mergeEnd = DateTime.now();
  // final mergeDuration = mergeEnd.difference(mergeStart).inMilliseconds;

  // print('\x1b[38;2;227;166;255mRadix Sort took: ${radixDuration} ms\x1b[0m');
  // print('\x1b[38;2;255;175;150mMerge Sort took: ${mergeDuration} ms\x1b[0m');

  // if (radixDuration > mergeDuration) {
  //   print('\x1b[38;2;255;175;150mMerge Sort is faster.\x1b[0m');
  // } else if (radixDuration < mergeDuration) {
  //   print('\x1b[38;2;227;166;255mRadix Sort is faster.\x1b[0m');
  // } else {
  //   print('\x1b[38;2;190;255;255mBoth took the same time.\x1b[0m');
  // }
}

Map<String, dynamic> runBenchmark(List<int> original, int runs) {
  final radixTimes = <int>[], quickTimes = <int>[], mergeTimes = <int>[], heapTimes = <int>[];

  for (var i = 0; i < runs; i++) {
    final r = List<int>.from(original);
    final q = List<int>.from(original);
    final m = List<int>.from(original);
    final h = List<int>.from(original);


    final s1 = DateTime.now();
    radixSort(r);
    radixTimes.add(DateTime.now().difference(s1).inMilliseconds);

    final s2 = DateTime.now();
    quickSort(q);
    quickTimes.add(DateTime.now().difference(s2).inMilliseconds);

    final s3 = DateTime.now();
    mergeSort(m);
    mergeTimes.add(DateTime.now().difference(s3).inMilliseconds);
    
    final s4 = DateTime.now();
    heapSort(h);
    heapTimes.add(DateTime.now().difference(s4).inMilliseconds);

    print('run ${i + 1}/$runs: radix=${radixTimes.last}ms, quick=${quickTimes.last}ms, merge=${mergeTimes.last}ms, heap=${heapTimes.last}ms');
  }

  double avg(List<int> t) => t.isEmpty ? 0 : t.reduce((a, b) => a + b) / t.length;

  final maxDigits = getMax(original).toString().length;
  return {
    'size': original.length,
    'runs': runs,
    'max_digits': maxDigits,
    'radix': {'avg_ms': avg(radixTimes), 'times_ms': radixTimes},
    'quick': {'avg_ms': avg(quickTimes), 'times_ms': quickTimes},
    'merge': {'avg_ms': avg(mergeTimes), 'times_ms': mergeTimes},
    'heap': {'avg_ms': avg(heapTimes), 'times_ms': heapTimes},
  };
}

// ---------------------- Radix Sort ----------------------
void radixSort(List<int> list) {
  if(list.length <= 1){
    return;
  }

  int place = 1;
  int biggest = getMax(list);
  final numberOfDigits = biggest.toString().length;

  for(int i = 0; i < numberOfDigits; i++){
    final buckets = List<List<int>>.generate(10, (_) => []);
    for (int value in list){
      final digit = (value ~/ place) % 10;
      buckets[digit].add(value);
    }
    list.clear();
    for(final bucket in buckets){
      list.addAll(bucket);
    }

    place = place * 10;
  }
}

int getMax(List<int> list){
  int max = list[0];

  for(final i in list){
    if(i > max){
      max = i;
    }
  }
  return max;
}

// ---------------------- Quick Sort ----------------------
void quickSort(List<int> list){
  _quicksort(list, 0, list.length - 1);

}

void _quicksort(List<int> list, int low, int high){
  if (low >= high) return;
  final pivotIndex = _lomutoPartition(list, low, high);
  _quicksort(list, low, pivotIndex - 1);
  _quicksort(list, pivotIndex + 1, high);
}

int _lomutoPartition(List<int> list, int low, int high){
  int pivot = list[high];
  int smaller = low -1;
  for(int current = low; current < high; current++){
    if(list[current] <= pivot){
      smaller++;
      _swap(list, smaller, current);
    }
  }
  smaller++;
  _swap(list, smaller, high);
  return smaller;
}

void _swap(List<int> myList, int firstIndex, int secondIndex) {
  if (firstIndex == secondIndex) return;
  final tempValue = myList[firstIndex];
  myList[firstIndex] = myList[secondIndex];
  myList[secondIndex] = tempValue;
}

// ---------------------- Merge Sort ----------------------
void mergeSort(List<int> list) {
  if (list.length <= 1){
    return;
  }

  int middle = list.length ~/2;
  List<int> leftHalf = list.sublist(0, middle);
  List<int> rightHalf = list.sublist(middle);

  mergeSort(leftHalf);
  mergeSort(rightHalf);

  _merge(list, leftHalf, rightHalf);
}

void _merge(List<int> list, List<int> left, List<int> right) {
  int i = 0;
  int j = 0;
  int k = 0;
  
  while (i < left.length && j < right.length) {
    if (left[i] <= right[j]) {
      list[k] = left[i];
      i++;
    }else{
      list[k] = right[j];
      j++;
    }
    k++;
  }

  while (i < left.length) {
    list[k] = left[i];
    i++;
    k++;
  }

  while (j < right.length) {
    list[k] = right[j];
    j++;
    k++;
  }
}

// ---------------------- Heap Sort ----------------------
void heapSort(List<int> list) {
  // Build max heap (in-place)
  for (int i = list.length ~/ 2 - 1; i >= 0; i--) {
    _heapify(list, list.length, i);
  }

  // Extract elements from heap one by one
  for (int i = list.length - 1; i > 0; i--) {
    // Move current root (max) to end
    final temp = list[0];
    list[0] = list[i];
    list[i] = temp;

    // Heapify reduced heap
    _heapify(list, i, 0);
  }
}

void _heapify(List<int> list, int heapSize, int parentIndex) {
  int currentIndex = parentIndex;
  
  while (true) {
    int largestIndex = currentIndex;
    final leftChildIndex = 2 * currentIndex + 1;
    final rightChildIndex = 2 * currentIndex + 2;

    // Check left child
    if (leftChildIndex < heapSize && list[leftChildIndex] > list[largestIndex]) {
      largestIndex = leftChildIndex;
    }

    // Check right child
    if (rightChildIndex < heapSize && list[rightChildIndex] > list[largestIndex]) {
      largestIndex = rightChildIndex;
    }

    // Swap and continue if needed
    if (largestIndex != currentIndex) {
      final temp = list[currentIndex];
      list[currentIndex] = list[largestIndex];
      list[largestIndex] = temp;
      currentIndex = largestIndex;
    } else {
      break;
    }
  }
}