# Essential Matrix Estimation and Optimization

## Introduction
This project implements essential matrix estimation and non-linear optimization in MATLAB for calibrated stereo cameras. It covers computing calibration matrices, estimating the essential matrix, resolving its ambiguity, and optimizing the geometric error for accurate epipolar geometry visualization.

## Features
- **Calibration Matrix Computation**: Calculates camera calibration matrices from given image points.
- **Essential Matrix Estimation**: Estimates the essential matrix based on calibration matrices.
- **Ambiguity Resolution**: Selects the plausible solution from the essential matrix's fourfold ambiguity.
- **Non-linear Optimization**: Optimizes the solution with respect to geometric error using algorithms like Levenberg-Marquardt.

## Technologies
- **MATLAB**: Used for matrix computations, image processing, and implementing optimization algorithms.
