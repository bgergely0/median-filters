#include "defs.h"
#include "func.h"

void median_filter(int imgHeight, int imgWidth, int imgWidthF,
	unsigned char* imgSrcExt, unsigned char* imgDst)

{
	for (int row = 0; row < imgHeight; row++)
	{
		for (int col = 0; col < imgWidth; col++)
		{

			short output_pixel[3] = { 0,0,0 };
			short buffer[75] = {0};

			for (int rgb = 0; rgb < 3; rgb++)
			{
				for (int fy = 0; fy < FILTER_H; fy++)
				{
					for (int fx = 0; fx < FILTER_W; fx++)
					{
						int filter_idx = (fy * FILTER_W + fx) * 3 + rgb;
						
						// fill 5x5 filter input
						buffer[filter_idx]
							= imgSrcExt[((row + fy) * imgWidthF + col + fx) * 3 + rgb];
					}
				}
			}
			

			int n = 32;

			for (int rgb = 0; rgb < 3; rgb++)
			{
				for(int p = 1; p < n; p = p*2) {
					for(int k = p; k >= 1; k = k/2) {
						for(int j = k % p; j < n-k-1; j += 2*k) {
							for(int i = 0; i < k; i++){
								if( ((i+j) / (2*p)) == ((i+j+k) / (2*p)) ){ // floor op is implicit for integer types
									if( i + j + k < 25) // dont index out of the array
									{
										// sort i+j, i+j+k
										int a = (i + j)*3 + rgb;
										int b = (i + j + k)*3 + rgb;

										if (buffer[a] > buffer[b]) {
											short helper = buffer[a];
											buffer[a] = buffer[b];
											buffer[b] = helper;
										}
									}
								}
							}
						}
					}
				}
			}

			// Write to output picture
			for (int rgb = 0; rgb < 3; rgb++)
			{
				imgDst[(row * imgWidth + col)*3 + rgb] = buffer[12*3 + rgb];
			}
		}
	}
	return;
}