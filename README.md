This repository provides a framework for the assessment of higher-order interactions (HOIs) in dynamic network systems at different levels of resolution, as proposed in the paper  “Network Representation of Higher-Order Interactions Based on Information Dynamics” by G. Mijatovic, Y. Antonacci, M. Javorka, D. Marinazzo, S. Stramaglia, and  L. Faes (submitted to “IEEE Transactions on Network Science and Engineering”). The framework is grounded on the dynamic implementation of the O-information, O-information rate (OIR), a new measure assessing HOIs in dynamic networks, which is here used together with its local counterpart (local OIR) and its gradient (OIR-gradient) to quantify HOIs respectively for the network as a whole, for each link, and for each node. The integration of these measures into the conventional network representation results in a tool for the representation of HOIs as networks, which is defined formally using measures of information dynamics, implemented in its linear version by using vector regression models and statistical validation techniques.
The “HOIs as networks” toolbox includes the following functions:

For computing the dynamic HOI measures, as described in the subsect. 2.1 “Framework to Assess Higher-Order Interactions at Different Levels of Resolution”:
lrp_deltaOIR – Computes the OIR-gradient (Eq. 6),
lrp_localOIR – Computes the local OIR (Eq. 7),
lrp_OIR_H – Computes the OIR elaborating on entropies (Eq. 4),
lrp_OIR – Computes the OIR in an iterrative way (Eqs. 5 and 6).

For computing the static HOI measures, as explained in the Appendix of the paper:
lrp_deltaOI_H – Computes the OI-gradient (Eq. 21),
lrp_localOI_H – Computes the local OI (Eq. 22),
lrp_OI_H – Computes the OI (Eq. 20).
Additionally, the toolbox provides the following functions:
plot_graphs, bluewhitered – Visualization tools,
surr_bootstrap – Generates bootstrap pseudo-series to test the statistical significance of all measures.
The repository includes a script (demo_static_vs_dynamic_HOIs.m) that simulates N = 5 processes interacting in a star structure, as depicted in Fig. 2a-c, consistent with the first theoretical analysis described in the subsect. 3.1 “Comparison of Static and Dynamic HOIs Measures” of the paper, providing a comparison of static and dynamic HOI measures when applied to the analyzed star structure. Another script (demo_simulated.m) demonstrates the computation of the OIR-gradient when 5 processes are simulated with a fixed length of 1000, with the coefficient a31 set to 0 (further details are available in the paper in the subsect. 3.3 “Analysis on simulated time series”).
