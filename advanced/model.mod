param nRows >= 0, integer;
param cashierCount >= 0, integer;
param cashierLength;
param maxRowLength >= 0, integer;

set Rows := 1..nRows;

set ProductGroups;

param space {ProductGroups} >= 0;
param averagePrice {ProductGroups} >= 0;

set MustBeTogether within {ProductGroups, ProductGroups};
set MustBeSeparated within {ProductGroups, ProductGroups};

set CustomerGroups;

param count {CustomerGroups} >= 0, integer;
param probabilityToBuy {CustomerGroups} >= 0;

param buys {CustomerGroups,ProductGroups} binary;

param M := 100;

var productPlacement {Rows, ProductGroups} >=0, binary;
var buysExtra {Rows, CustomerGroups};


s.t. EveryProductHasExactlyOneLine {p in ProductGroups}:
	sum {r in Rows} productPlacement[r,p] = 1;

s.t. DontExceedMaxRowLength {r in Rows:r>cashierCount}:
	sum {p in ProductGroups} productPlacement[r,p]*space[p] <= maxRowLength;

s.t. DontExceedMaxRowLengthWithCashier {r in Rows:r<=cashierCount}:
	cashierLength + (sum {p in ProductGroups} productPlacement[r,p]*space[p]) <= maxRowLength;

s.t. SeparatedProductsCantBeOnSameRow {r in Rows, (p1,p2) in MustBeSeparated}:
	productPlacement[r,p1] + productPlacement[r,p2] <= 1;

s.t. SomeProductsMustBeOnSameRow {r in Rows,(p1,p2) in MustBeTogether}:
	productPlacement[r,p1] = productPlacement[r,p2];

s.t. BuyExtraIfTheRowHasSomethingTheCustomerWantsToBuy {r in Rows, c in CustomerGroups, p1 in ProductGroups:buys[c,p1]=1}:
	buysExtra[r, c] <= sum{p2 in ProductGroups:p1!=p2 && buys[c,p2]=0} productPlacement[r,p2]*probabilityToBuy[c]*averagePrice[p2] + M * (1-productPlacement[r,p1]);

s.t. BuyExtraIfTheRowHasSomethingTheCustomerWantsToBuy2 {r in Rows, c in CustomerGroups, p1 in ProductGroups:buys[c,p1]=1}:
	buysExtra[r, c] >= sum{p2 in ProductGroups:p1!=p2 && buys[c,p2]=0} productPlacement[r,p2]*probabilityToBuy[c]*averagePrice[p2] - M * (1-productPlacement[r,p1]);


maximize ManipulatedIncome: sum{r in Rows, c in CustomerGroups} buysExtra[r,c]*count[c];
solve;

printf "%f\n",ManipulatedIncome;
