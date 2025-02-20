### Optimizing Delivery Routes and Product Scheduling in a City

#### Problem Scenario

A logistics company delivers products from a central warehouse to multiple locations in a city. The company aims to:

- Minimize total travel cost and time.
- Ensure deliveries occur within the designated time windows.
- Reduce waiting and storage costs.

Each location has a **time window** $$\( [t_i^{\text{early}}, t_i^{\text{late}}] \)$$ specifying the earliest and latest possible delivery times. The delivery truck must determine the **shortest path** while ensuring all deliveries occur **within their time windows**.

#### Mathematical Formulation

#### Decision Variables
$$
\min \sum_{i=1}^{N} \sum_{j=1}^{N} d_{ij} x_{ij} + \sum_{i=1}^{N} w_i
$$

where:


- \( d_{ij} \) is the distance (or time cost) from location \( i \) to \( j \).
- \( w_i \) represents waiting time at location \( i \).

 **Route constraints (Traveling Salesman Problem - TSP)**:

$$
\sum_{j=1}^{N} x_{ij} = 1, \quad \forall i
$$

$$
\sum_i=1}^{N} x_{ij} = 1, \quad \forall j
$$

   Each location must be visited exactly once.

#### Time Constraints

$$
t_i + w_i \geq t_i^{\text{early}}, \quad \forall i
$$

The truck cannot deliver before the store opens.

#### Subtour Elimination Constraint (Miller-Tucker-Zemlin)

$$
t_j \geq t_i + d_{ij} x_{ij}, \quad \forall i, j
$$

Ensuring logical sequencing of visits.

#### Non-Negativity

$$
w_i \geq 0
$$

