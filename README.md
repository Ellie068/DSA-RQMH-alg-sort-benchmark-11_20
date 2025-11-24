From my Analysis of the Sorting Algorithm Benchmark  
The Quick Sort dominates - 2x faster than Merge/Radix  
Radix vs Merge - Close call, but Radix slightly edges out (on 7 key length)  
Heap Sort - As expected. It's the slowest for comparison-based sorting  

[Click Here!](https://ellie068.github.io/DSA-RQMH-alg-sort-benchmark-11_20/ "This Repo's page deployment") to check out the somewhat interactive, friendly UI to see the Benchmark results in Graphs and Charts.  

### 1 Million Array list with 7 keys max length, and 25 runs.

Radix Sort: Avg: 206.52ms  
Quick Sort: Avg: 109.96ms  
Merge Sort: Avg: 217.88ms  
Heap Sort: Avg: 290.76ms  

### 1-Mil Array with 10 keys, and 25 runs.

Radix Sort: Avg: 309.36ms  
Quick Sort: Avg: 112.88ms  
Merge Sort: Avg: 222.56ms  
Heap Sort: Avg: 283.92ms  

### 1-Mil Array with 12 keys, and 25 runs.

Radix Sort: Avg: 355.12ms  
Quick Sort: Avg: 113.24ms  
Merge Sort: Avg: 234.88ms  
Heap Sort: Avg: 294.68ms  

### 1-Mil Array with 18 keys, and 25 runs.

Radix Sort: Avg: 509.80ms  
Quick Sort: Avg: 110.68ms  
Merge Sort: Avg: 220.72ms  
Heap Sort: Avg: 252.52ms  

## Image
Average Execution Time by Key Length  
![Graph ScreenShot-1](/Graph-Chart_img/screenshot1.png)  
Algorithm Scaling with Key Length  
![Graph ScreenShot-2](/Graph-Chart_img/screenshot2.png)  
Individual Run Times Distribution  
![Graph ScreenShot-3](/Graph-Chart_img/screenshot3.png)  
  
# DSA-RQMH-alg-sort-benchmark-11_20
Radix, Quick, Merge, Heap sort algorithm benchmarking results for homework of Data Structure &amp; Algorithm course, Nov-20th
