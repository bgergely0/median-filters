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
			short filterbuffer_r[32] = {0};
			short filterbuffer_g[32] = {0};
			short filterbuffer_b[32] = {0};

			for (int fy = 0; fy < FILTER_H; fy++)
			{
				for (int fx = 0; fx < FILTER_W; fx++)
				{
					int filter_idx = fy * FILTER_W + fx;
					//5x5 filter filled with elements at every pixel
					filterbuffer_r[filter_idx]
						= imgSrcExt[((row + fy) * imgWidthF + col + fx) * 3 + 0];

					filterbuffer_g[filter_idx]
						= imgSrcExt[((row + fy) * imgWidthF + col + fx) * 3 + 1];

					filterbuffer_b[filter_idx]
						= imgSrcExt[((row + fy) * imgWidthF + col + fx) * 3 + 2];
				}
			}

			//int n = FILTER_W * FILTER_H;
			int n = 32;

			for(int p = 1; p < n; p = p*2) {
				for(int k = p; k >= 1; k = k/2) {
					for(int j = k % p; j < n-k; j += 2*k) {
						for(int i = 0; i < k; i++){
							if( ((i+j) / (2*p)) == ((i+j+k) / (2*p)) ){ // floor op is implicit for integer types
									// RED
									if (filterbuffer_r[i + j] > filterbuffer_r[i + j + k]) {
										short helper = filterbuffer_r[i + j];
										filterbuffer_r[i + j] = filterbuffer_r[i + j + k];
										filterbuffer_r[i + j + k] = helper;
									}
									// GREEN
									if (filterbuffer_g[i + j] > filterbuffer_g[i + j + k]) {
										short helper = filterbuffer_g[i + j];
										filterbuffer_g[i + j] = filterbuffer_g[i + j + k];
										filterbuffer_g[i + j + k] = helper;
									}
									// BLUE
									if (filterbuffer_b[i + j] > filterbuffer_b[i + j + k]) {
										short helper = filterbuffer_b[i + j];
										filterbuffer_b[i + j] = filterbuffer_b[i + j + k];
										filterbuffer_b[i + j + k] = helper;
									}
							}
						}
					}
				}
			}

			output_pixel[0] = filterbuffer_r[13+7];
			output_pixel[1] = filterbuffer_g[13+7];
			output_pixel[2] = filterbuffer_b[13+7];

			// Write to output picture
			for (int rgb = 0; rgb < 3; rgb++)
			{
				imgDst[(row * imgWidth + col)*3 + rgb] = output_pixel[rgb];
			}
		}
	}
	return;
}
