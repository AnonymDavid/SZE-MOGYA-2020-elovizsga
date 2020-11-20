
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

data;

param nRows        :=   3;
param cashierCount :=   1;
param cashierLength := 2.5;

set ProductGroups :=  Group1 Group2 Group3 Group4 Group5 Group6 Group7 Group8;


param space :=
Group1	0.04
Group2	0.62
Group3	0.13
Group4	1.28
Group5	0.56
Group6	0.21
Group7	1.39
Group8	1.47
;