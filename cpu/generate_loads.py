#!/bin/python3

FILTER_H = 5
FILTER_W = 5

fy = 0
fx = 0
with open("unrolled_load_loop.txt", "w") as f:
    for fy in range(0, FILTER_H):
        for fx in range(0, FILTER_W):
            filter_idx = fy*FILTER_W + fx;
            f.write("pixel_addr = (imgSrcExt + (row + " + str(fy) + " ) * imgWidthF * 3 + col + " + str(fx) + " * 3);\n")
            f.write("filterbuffer[" + str(filter_idx) + "] = _mm256_lddqu_si256((__m256i*)(pixel_addr));\n")
