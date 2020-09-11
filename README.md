# Nonlinear-Unsharp-Masking

## Summary
This source code is a MATLAB implementation of a nonlinear unsharp masking method, published in the proceeding of ICEIC 2020, Barcelona, Spain. The algorithm was implemented by means of generalized operators, therein lies the underlying cause of its robustness against out-of-range issue.

The block diagram of the proposed algorithm is as follows:
![Block-Diagram](/imgs/fig-2.tif)

The input image ***x*** undergoes the **edge-preserving filtering** step to produce the background signal ***y***, which in turn undergoes the **optional contrast enhancement** step before arriving at the final ***generalized adder***. The detail signal ***d*** is the generalized subtraction of ***y*** from ***x***, and the proposed algorithm adaptively scales it up before adding back to the optinally enhanced ***y***. As a result, the output image ***z*** can exhibit a significant improvement in both contrast and sharpness.

## Run the code
Run the file "*NUM_demo.m*" in **MATLAB R2019a** to view the result. The source code is in the *soucre_code* folder, and the detailed explanation of input parameters can be found in the published paper.

## Result
![Background-Extraction](/imgs/background-extraction.tif)
The modified hybrid median filter (mHMF) that constitutes the **edge-preserving filtering** step accelerated the background extraction procedure, as depicted in the figure above. Given the pre-determined threshold, the **edge-preserving filtering** step iteratively applied the mHMF to the input image until the difference between two consecutive results was less than the threshold. 

## Reference
In any publication related to the use of the source code, you are kindly requested to cite the following paper:

D. Ngo, S. Lee and B. Kang, "Nonlinear Unsharp Masking Algorithm," *2020 International Conference on Electronics, Information, and Communication (ICEIC)*, Barcelona, Spain, 2020, pp. 1-6, [doi: 10.1109/ICEIC49074.2020.9051376.](https://ieeexplore.ieee.org/abstract/document/9051376)
