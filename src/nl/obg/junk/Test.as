/*package  
{
	public class Test
	{
		
		public function Test() 
		{
			int heapSize = 10;
			void print(int a[]) {
			  for (int i = 0; i <= 9; i++) {
				cout << a[i] << "-";
			  }
			  cout << endl;
			}

int parent(int i) {
if(i==1)
return 0;

if(i%2==0)
    return ( (i / 2)-1);
else
    return ( (i / 2));
}

int left(int i) {
  return (2 * i) + 1;
}

int right(int i) {
  return (2 * i) + 2;
}

void heapify(int a[], int i) {
  int l = left(i), great;
  int r = right(i);
  if ( (a[l] > a[i]) && (l < heapSize)) {
    great = l;
  }
  else {
    great = i;
  }
  if ( (a[r] > a[great]) && (r < heapSize)) {
    great = r;
  }
  if (great != i) {
    int temp = a[i];
    a[i] = a[great];
    a[great] = temp;
    heapify(a, great);
  }
}

void BuildMaxHeap(int a[]) {
  for (int i = (heapSize - 1) / 2; i >= 0; i--) {
    heapify(a, i);
    print(a);
  }
}

void HeapSort(int a[]) {
  BuildMaxHeap(a);
  for (int i = heapSize; i > 0; i--) {
    int temp = a[0];
    a[0] = a[heapSize - 1];
    a[heapSize - 1] = temp;
    heapSize = heapSize - 1;
    heapify(a, 0);
  }

}

void main() {

  int arr[] = {
      2, 9, 3, 6, 1, 4, 5, 7, 0, 8};
  HeapSort(arr);
  print(arr);
}

		}
		
	}

}*/