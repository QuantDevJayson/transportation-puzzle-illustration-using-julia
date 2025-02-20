###
Q.1
A company supplies products from three warehouses to four retail stores. 
Each warehouse has a limited supply, and each store has a specific demand.
 The transportation cost between each warehouse and store varies. 
 The objective is to minimize the total transportation cost while
 ensuring all supply and demand constraints are met.


###
using JuMP, GLPK

# Define warehouses (supply) and stores (demand)
supply = [50, 60, 75]  # Warehouse capacities
demand = [30, 40, 35, 50]  # Store demands
cost = [  # Cost matrix (rows: warehouses, columns: stores)
    [8, 6, 10, 9],
    [9, 12, 7, 8],
    [14, 9, 16, 5]
]

# Number of warehouses and stores
num_warehouses = length(supply)
num_stores = length(demand)

# Create the optimization model
model = Model(GLPK.Optimizer)

# Define decision variables
@variable(model, x[1:num_warehouses, 1:num_stores] >= 0)

# Objective function: Minimize total transportation cost
@objective(model, Min, sum(cost[i, j] * x[i, j] for i in 1:num_warehouses, j in 1:num_stores))

# Supply constraints: Each warehouse cannot exceed its capacity
@constraint(model, supply_constraints[i=1:num_warehouses], sum(x[i, j] for j in 1:num_stores) <= supply[i])

# Demand constraints: Each store must receive at least its demand
@constraint(model, demand_constraints[j=1:num_stores], sum(x[i, j] for i in 1:num_warehouses) >= demand[j])

# Solve the optimization problem
optimize!(model)

# Display results
println("Optimal Transportation Plan:")
for i in 1:num_warehouses
    for j in 1:num_stores
        println("Ship ", value(x[i, j]), " units from Warehouse ", i, " to Store ", j)
    end
end

println("Minimum Transportation Cost: ", objective_value(model))


####
Q.2. 
Imagine a logistics company that delivers products from a central 
warehouse to multiple locations in a city. The company wants to
 reduce delivery costs, optimize truck routes, and ensure all
  products arrive on time.

###


using JuMP, Gurobi

# Define locations and parameters
N = 5  # Number of locations (excluding warehouse)
distances = [  # Distance matrix (in km)
    [0, 10, 20, 30, 25],
    [10, 0, 15, 35, 40],
    [20, 15, 0, 25, 30],
    [30, 35, 25, 0, 20],
    [25, 40, 30, 20, 0]
]
time_windows = [(8, 12), (9, 13), (10, 14), (7, 11), (6, 10)]  # (Earliest, Latest)

# Create the optimization model
model = Model(Gurobi.Optimizer)

# Decision variables
@variable(model, x[1:N, 1:N], Bin)  # Binary route selection
@variable(model, t[1:N] >= 0)        # Arrival time
@variable(model, w[1:N] >= 0)        # Waiting time

# Objective function: Minimize travel and waiting costs
@objective(model, Min, sum(distances[i, j] * x[i, j] for i in 1:N, j in 1:N) + sum(w))

# Constraints
@constraint(model, [i=1:N], sum(x[i, j] for j in 1:N) == 1)  # Each location visited once
@constraint(model, [j=1:N], sum(x[i, j] for i in 1:N) == 1)  # Each location left once
@constraint(model, [i=2:N], t[i] >= t[i-1] + sum(distances[i-1, j] * x[i-1, j] for j in 1:N))  # Arrival time constraint
@constraint(model, [i=1:N], t[i] + w[i] >= time_windows[i][1])  # Time window constraint

# Solve
optimize!(model)

# Print results
println("Optimal Delivery Route:")
for i in 1:N
    for j in 1:N
        if value(x[i, j]) > 0.5
            println("Travel from location $i to $j")
        end
    end
end

println("Minimum Cost: ", objective_value(model))
