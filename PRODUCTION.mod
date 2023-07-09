/*********************************************
 * OPL 22.1.1.0 Model
 * Author: bshik
 * Creation Date: 09-Jul-2023 at 12:51:21 PM
 *********************************************/
{string} ToyTypes = ...;//Defining string for types of toys
{string} ComponentTypes = ...;//Defining string for types of components used to make toys
int NbPeriods = ...;
range Periods = 1..NbPeriods;//Defining the range for number of periods
int MaxBuildPerPeriod[Periods] = ...; // Maximum production per period
int MaxDemand[ToyTypes][Periods] = ...; // Maximum demand per toy type per period
int MinDemand[ToyTypes][Periods] = ...; // Minimum demand per toy type per period
tuple toysToBuild { // Tuple representing a toy to produce
{string} components;
int price;
int maxInventory;
}
toysToBuild Toys[ToyTypes] = ...;
float TotalBuild[ToyTypes] = ...; // Total production of each toy type
int MaxInventory = 25;
dvar float+ Build[ToyTypes][Periods]; // Decision variables for production
dvar float+ Sell[ToyTypes][Periods]; // Decision variables for sales
dvar float+ InStockAtEndOfPeriod[ToyTypes][Periods]; // Decision variables for inventory
subject to {
// Inventory capacity constraint
forall(p in Periods)
ctInventoryCapacity:
sum(t in ToyTypes) InStockAtEndOfPeriod[t][p] <= MaxInventory;
// Maximum demand constraint
forall(t in ToyTypes, p in Periods)
ctUnderMaxDemand: Sell[t][p] <= MaxDemand[t][p];
// Maximum inventory constraint
forall(t in ToyTypes, p in Periods)
ctToyTypeInventoryCapacity:InStockAtEndOfPeriod[t][p] <= Toys[t].maxInventory;
// Minimum demand constraint
forall(t in ToyTypes, p in Periods)
ctOverMinDemand: Sell[t][p] >= MinDemand[t][p];
// Initial inventory constraint
forall(t in ToyTypes)
Build[t][1] == Sell[t][1] + InStockAtEndOfPeriod[t][1];
// Production capacity constraint
forall(t in ToyTypes)
ctTotalToBuild:
sum(p in Periods) Build[t][p] == TotalBuild[t];
// Inventory balance constraint
forall(t in ToyTypes, p in 2..NbPeriods)
ctInventoryBalance:InStockAtEndOfPeriod[t][p-1] + Build[t][p] ==Sell[t][p] + InStockAtEndOfPeriod[t][p];
}

