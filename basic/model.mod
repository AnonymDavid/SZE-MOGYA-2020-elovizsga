
param nRows >=0, integer;
param cashierCount >=0, integer;
param cashierLength >=0;

set Rows := 1..nRows;

set ProductGroups;

param space {ProductGroups} >= 0;

var productPlacement {Rows, ProductGroups} >=0, binary;
var rowLength {Rows};
var longestRow;

s.t. EveryProductHasExactlyOneLine {p in ProductGroups}:
	sum {r in Rows} productPlacement[r,p] = 1;

s.t. SetRowLength {r in Rows:r>cashierCount}:
	rowLength[r] = sum{p in ProductGroups} productPlacement[r,p]*space[p];

s.t. SetRowLengthWithCashier {r in Rows:r<=cashierCount}:
	rowLength[r] = cashierLength + (sum{p in ProductGroups} productPlacement[r,p]*space[p]);

s.t. FindLongestRow {r in Rows}:
	longestRow >= rowLength[r];


minimize BuildingLength: longestRow;

solve;

printf "%f\n",BuildingLength;
