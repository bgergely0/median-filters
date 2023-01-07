#!/bin/python3

import math
n = 32
p = 1
sortnum = 1
while p < n:
    k = p
    while k >= 1:
        j = k % p
        while j < n - k - 1:
            i = 0
            while i < k:
                if math.floor(float(i+j)/float(2*p))==math.floor(float(i+j+k)/float(2*p)):
                    if (i+j+k < 25):
                        print("\t\t\tsort_two_vectors(filterbuffer["+ str(int(i+j+k))+"],filterbuffer["+str(int(i+j))+"], tmp); // sort #" + str(sortnum))
                        sortnum += 1
                i = i+1
            j = j + 2*k
        k = k/2
    p = p * 2
