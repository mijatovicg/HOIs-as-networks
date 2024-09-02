This repository provides a framework for the assessment of higher-order interactions (HOIs) in dynamic network systems at different levels of resolution, as proposed in the paper  “Network Representation of Higher-Order Interactions Based on Information Dynamics” by G. Mijatovic, Y. Antonacci, M. Javorka, D. Marinazzo, S. Stramaglia, and  L. Faes (https://arxiv.org/abs/2408.15617). The framework is grounded on the dynamic implementation of the O-information (OIR), a new measure assessing HOIs in dynamic networks, which is here used together with its local counterpart (local OIR) and its gradient (OIR-gradient) to quantify HOIs respectively for the network as a whole, for each link, and for each node. The integration of these measures into the conventional network representation results in a tool for the representation of HOIs as networks, which is defined formally using measures of information dynamics, implemented in its linear version by using vector regression models and statistical validation techniques.

The “HOIs as networks” toolbox includes the following functions:
1.	lrp_deltaOIR – Computes the OIR-gradient,
2.	lrp_localOIR – Computes the local OIR,
3.	lrp_OIR – Computes the OIR,
4.	plot_graphs, bluewhitered – Visualization tools,
5.	surr_bootstrap – Generates Bootstrap pseudo-series to test the statistical significance of all three measures (local OIR, OIR-gradient, OIR).

Additionally, the repository includes a script (demo_theoretical.m) that simulates N = 5 processes interacting in a star structure as depicted in Fig. 1a-c, in line with the theoretical analysis described in Section III: VALIDATION ON SIMULATIONS of the paper. Another script (demo_simulated.m) demonstrates the computation of the OIR-gradient when 5 processes are simulated with a fixed length of 1000, with the coefficient a31 set to 0 (further details are available in the paper).
