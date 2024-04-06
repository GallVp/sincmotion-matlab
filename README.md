# SincMotion MATLAB

[![cite](https://img.shields.io/badge/DOI-10.3390/s22010124-0f5fa5.svg)](https://doi.org/10.3390/s22010124)

A MATLAB implementation of algorithms for gait and balance assessment using an inertial measurement unit. This library is a reference implementation of the [SincMotion](https://github.com/GallVp/sincmotion) Kotlin Multiplatform library.

## Library Structure

- [core](./core):
  - [Gait estimator](./core/estimateGaitOutcomes.m) based on inverted-pendulum gait model<sup>[1](#references)</sup> and wavelet-based time-of-contact estimator<sup>[2](#references)</sup> for continuous inertial measurement gait data. It estimates,
    - Gait symmetry index<sup>[3](#references)</sup>
    - Step lengths
    - Left step lengths
    - Right step lengths
    - Step times
    - Left step times
    - Right step times
  - [Postural stability estimator](./core/estimatePosturalStability.m) for continuous inertial measurement data from static standing tasks such as standing on firm surface with eyes closed. It estimates:
    - Stability
    - Stability mediolateral
    - Stability anterior posterior
- [gaitandbalance](./gaitandbalance): Reference implementation of the motion analysis algorithms of the Gait&Balance app.<sup>[4](#references)</sup>

## Quick Start

Try the [gaitandbalance](./gaitandbalance) algorithms on [example data](./example_data/) using [InspectGnBComfortableGaitFile.m](./gaitandbalance/InspectGnBComfortableGaitFile.m) and [InspectGnBStaticTaskFile.m](./gaitandbalance/InspectGnBStaticTaskFile.m) functions.

## Dependencies

This library uses [rafat/wavelib](https://github.com/rafat/wavelib) for wavelet-based denoising. rafat/wavelib is implemented in C and must be compiled before usage. See [provisioning `diff_cwtft`](./diff_cwtft/README.md) for compilation instructions.

## References

1. Zhao Q, Zhang B, Wang J, Feng W, Jia W, Sun M. Improved method of step length estimation based on inverted pendulum model. International Journal of Distributed Sensor Networks. 2017;13(4). doi:[10.1177/1550147717702914](https://doi.org/10.1177/1550147717702914)
2. McCamley J, Donati M, Grimpampi E, Mazzà C. An enhanced estimate of initial contact and final contact instants of time using lower trunk inertial sensor data. Gait Posture. 2012 Jun;36(2):316-8. doi: [10.1016/j.gaitpost.2012.02.019](https://doi.org/10.1016/j.gaitpost.2012.02.019). Epub 2012 Mar 31. PMID: 22465705.
3. Zhang, W.; Smuck, M.; Legault, C.; Ith, M.A.; Muaremi, A.; Aminian, K. Gait Symmetry Assessment with a Low Back 3D Accelerometer in Post-Stroke Patients. Sensors 2018, 18, 3322. doi: [10.3390/s18103322](https://doi.org/10.3390/s18103322)
4. Rashid, U.; Barbado, D.; Olsen, S.; Alder, G.; Elvira, J.L.L.; Lord, S.; Niazi, I.K.; Taylor, D. Validity and Reliability of a Smartphone App for Gait and Balance Assessment. Sensors 2022, 22, 124. [10.3390/s22010124](https://doi.org/10.3390/s22010124)
