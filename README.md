# CEST-MPLF

**CEST processing using multipool Lorentzian fitting (MPLF) with inverse Z-spectrum analysis**

Author: Jianpan Huang

Email: jianpanhuang@outlook.com

Affiliation: Department of Diagnostic Radiology, The University of Hong Kong, Hong Kong, China

The demo data is a simulation data created using 5-pool Bloch-McConnell equation with amide fraction varied as 0.0009009, 0.0009009*2, 0.0009009*3, 0.0009009*4. Other parameters remained the same. Therefore, we can see a gradient change in amide (3.5 ppm) map, but not in other CEST maps below.

**You can change the data to your own CEST data, which must include CEST images (img), frequency offsets (offs) and ROI (roi).**

After running the code, you will see the following fitting process and results:

<img width="1051" alt="image" src="https://github.com/JianpanHuang/CEST-MPLF/assets/43700029/120ddc59-d5c4-49bf-97f9-aa8bbd890167">

If you use the code, please consider citing the references: 

[1] Huang J, Lai J H C, Tse K H, et al. Deep neural network based CEST and AREX processing: Application in imaging a model of Alzheimer’s disease at 3 T. Magnetic Resonance in Medicine, 2022, 87(3): 1529-1545.

