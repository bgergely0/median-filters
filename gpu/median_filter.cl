typedef struct cuda_id_struct
{
    int x;
    int y;
} cuda_id;

#define max(a,b)             \
({                           \
    __typeof__ (a) _a = (a); \
    __typeof__ (b) _b = (b); \
    _a > _b ? _a : _b;       \
})

#define min(a,b)             \
({                           \
    __typeof__ (a) _a = (a); \
    __typeof__ (b) _b = (b); \
    _a < _b ? _a : _b;       \
})

#define sort_2(a, b, tmp) \
    (tmp) = min ((a), (b)); \
    (a) = max ((a), (b)); \
    (b) = (tmp);

__kernel void median_filter_ocl_int(__global unsigned char* gInput,
    __global unsigned char* gOutput,
    int imgWidth,
    int imgWidthF)
{
    cuda_id threadIdx, blockIdx, blockDim;
    threadIdx.x = get_local_id(0);
    threadIdx.y = get_local_id(1);
    blockIdx.x = get_group_id(0);
    blockIdx.y = get_group_id(1);
    blockDim.x = get_local_size(0);
    blockDim.y = get_local_size(1);

    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;


    int output_pixel[3] = { 0, 0, 0 };

  // shmem load
  __local unsigned char in_shmem[20][20][3];

  int thid_1d = threadIdx.y*blockDim.x + threadIdx.x;
  int ld_rgba = thid_1d%3;
  int ld_col  = (thid_1d/3)%20;
  int ld_row  = thid_1d / 60;
  int ld_base = (blockIdx.y * blockDim.y) * 3 * imgWidthF + (blockIdx.x * blockDim.x) * 3 + (ld_row * 3 * imgWidthF);
  if (thid_1d<(3*20*4))
  {
    #pragma unroll
    for (int ld=0; ld<5; ld++)
    {
      in_shmem[ld_row + ld * 4][ld_col][ld_rgba] = gInput[ld_base + (thid_1d % 60)];
      ld_base = ld_base + imgWidthF*3*4;
    }
  }
  barrier(CLK_LOCAL_MEM_FENCE);





    // median filtering
    int buffer[25] = {}, tmp;
    int sort_result[3] = {};
    
    #pragma unroll 3
    for(int rgb = 0; rgb < 3; rgb++)
    {
        #pragma unroll 5
        for(int fy = 0; fy<5; fy++)
        {
            #pragma unroll 5
            for(int fx = 0; fx<5; fx++)
            {
                buffer[fy*5 + fx] = (in_shmem[threadIdx.y + fy][threadIdx.x + fx][rgb]);  
            }
        }
    
            sort_2(buffer[1],buffer[0], tmp); // sort #1
            sort_2(buffer[3],buffer[2], tmp); // sort #2
            sort_2(buffer[5],buffer[4], tmp); // sort #3
            sort_2(buffer[7],buffer[6], tmp); // sort #4
            sort_2(buffer[9],buffer[8], tmp); // sort #5
            sort_2(buffer[11],buffer[10], tmp); // sort #6
            sort_2(buffer[13],buffer[12], tmp); // sort #7
            sort_2(buffer[15],buffer[14], tmp); // sort #8
            sort_2(buffer[17],buffer[16], tmp); // sort #9
            sort_2(buffer[19],buffer[18], tmp); // sort #10
            sort_2(buffer[21],buffer[20], tmp); // sort #11
            sort_2(buffer[23],buffer[22], tmp); // sort #12
            sort_2(buffer[2],buffer[0], tmp); // sort #13
            sort_2(buffer[3],buffer[1], tmp); // sort #14
            sort_2(buffer[6],buffer[4], tmp); // sort #15
            sort_2(buffer[7],buffer[5], tmp); // sort #16
            sort_2(buffer[10],buffer[8], tmp); // sort #17
            sort_2(buffer[11],buffer[9], tmp); // sort #18
            sort_2(buffer[14],buffer[12], tmp); // sort #19
            sort_2(buffer[15],buffer[13], tmp); // sort #20
            sort_2(buffer[18],buffer[16], tmp); // sort #21
            sort_2(buffer[19],buffer[17], tmp); // sort #22
            sort_2(buffer[22],buffer[20], tmp); // sort #23
            sort_2(buffer[23],buffer[21], tmp); // sort #24
            sort_2(buffer[2],buffer[1], tmp); // sort #25
            sort_2(buffer[6],buffer[5], tmp); // sort #26
            sort_2(buffer[10],buffer[9], tmp); // sort #27
            sort_2(buffer[14],buffer[13], tmp); // sort #28
            sort_2(buffer[18],buffer[17], tmp); // sort #29
            sort_2(buffer[22],buffer[21], tmp); // sort #30
            sort_2(buffer[4],buffer[0], tmp); // sort #31
            sort_2(buffer[5],buffer[1], tmp); // sort #32
            sort_2(buffer[6],buffer[2], tmp); // sort #33
            sort_2(buffer[7],buffer[3], tmp); // sort #34
            sort_2(buffer[12],buffer[8], tmp); // sort #35
            sort_2(buffer[13],buffer[9], tmp); // sort #36
            sort_2(buffer[14],buffer[10], tmp); // sort #37
            sort_2(buffer[15],buffer[11], tmp); // sort #38
            sort_2(buffer[20],buffer[16], tmp); // sort #39
            sort_2(buffer[21],buffer[17], tmp); // sort #40
            sort_2(buffer[22],buffer[18], tmp); // sort #41
            sort_2(buffer[23],buffer[19], tmp); // sort #42
            sort_2(buffer[4],buffer[2], tmp); // sort #43
            sort_2(buffer[5],buffer[3], tmp); // sort #44
            sort_2(buffer[12],buffer[10], tmp); // sort #45
            sort_2(buffer[13],buffer[11], tmp); // sort #46
            sort_2(buffer[20],buffer[18], tmp); // sort #47
            sort_2(buffer[21],buffer[19], tmp); // sort #48
            sort_2(buffer[2],buffer[1], tmp); // sort #49
            sort_2(buffer[4],buffer[3], tmp); // sort #50
            sort_2(buffer[6],buffer[5], tmp); // sort #51
            sort_2(buffer[10],buffer[9], tmp); // sort #52
            sort_2(buffer[12],buffer[11], tmp); // sort #53
            sort_2(buffer[14],buffer[13], tmp); // sort #54
            sort_2(buffer[18],buffer[17], tmp); // sort #55
            sort_2(buffer[20],buffer[19], tmp); // sort #56
            sort_2(buffer[22],buffer[21], tmp); // sort #57
            sort_2(buffer[8],buffer[0], tmp); // sort #58
            sort_2(buffer[9],buffer[1], tmp); // sort #59
            sort_2(buffer[10],buffer[2], tmp); // sort #60
            sort_2(buffer[11],buffer[3], tmp); // sort #61
            sort_2(buffer[12],buffer[4], tmp); // sort #62
            sort_2(buffer[13],buffer[5], tmp); // sort #63
            sort_2(buffer[14],buffer[6], tmp); // sort #64
            sort_2(buffer[15],buffer[7], tmp); // sort #65
            sort_2(buffer[24],buffer[16], tmp); // sort #66
            sort_2(buffer[8],buffer[4], tmp); // sort #67
            sort_2(buffer[9],buffer[5], tmp); // sort #68
            sort_2(buffer[10],buffer[6], tmp); // sort #69
            sort_2(buffer[11],buffer[7], tmp); // sort #70
            sort_2(buffer[24],buffer[20], tmp); // sort #71
            sort_2(buffer[4],buffer[2], tmp); // sort #72
            sort_2(buffer[5],buffer[3], tmp); // sort #73
            sort_2(buffer[8],buffer[6], tmp); // sort #74
            sort_2(buffer[9],buffer[7], tmp); // sort #75
            sort_2(buffer[12],buffer[10], tmp); // sort #76
            sort_2(buffer[13],buffer[11], tmp); // sort #77
            sort_2(buffer[20],buffer[18], tmp); // sort #78
            sort_2(buffer[21],buffer[19], tmp); // sort #79
            sort_2(buffer[24],buffer[22], tmp); // sort #80
            sort_2(buffer[2],buffer[1], tmp); // sort #81
            sort_2(buffer[4],buffer[3], tmp); // sort #82
            sort_2(buffer[6],buffer[5], tmp); // sort #83
            sort_2(buffer[8],buffer[7], tmp); // sort #84
            sort_2(buffer[10],buffer[9], tmp); // sort #85
            sort_2(buffer[12],buffer[11], tmp); // sort #86
            sort_2(buffer[14],buffer[13], tmp); // sort #87
            sort_2(buffer[18],buffer[17], tmp); // sort #88
            sort_2(buffer[20],buffer[19], tmp); // sort #89
            sort_2(buffer[22],buffer[21], tmp); // sort #90
            sort_2(buffer[24],buffer[23], tmp); // sort #91
            sort_2(buffer[16],buffer[0], tmp); // sort #92
            sort_2(buffer[17],buffer[1], tmp); // sort #93
            sort_2(buffer[18],buffer[2], tmp); // sort #94
            sort_2(buffer[19],buffer[3], tmp); // sort #95
            sort_2(buffer[20],buffer[4], tmp); // sort #96
            sort_2(buffer[21],buffer[5], tmp); // sort #97
            sort_2(buffer[22],buffer[6], tmp); // sort #98
            sort_2(buffer[23],buffer[7], tmp); // sort #99
            sort_2(buffer[24],buffer[8], tmp); // sort #100
            sort_2(buffer[16],buffer[8], tmp); // sort #101
            sort_2(buffer[17],buffer[9], tmp); // sort #102
            sort_2(buffer[18],buffer[10], tmp); // sort #103
            sort_2(buffer[19],buffer[11], tmp); // sort #104
            sort_2(buffer[20],buffer[12], tmp); // sort #105
            sort_2(buffer[21],buffer[13], tmp); // sort #106
            sort_2(buffer[22],buffer[14], tmp); // sort #107
            sort_2(buffer[23],buffer[15], tmp); // sort #108
            sort_2(buffer[8],buffer[4], tmp); // sort #109
            sort_2(buffer[9],buffer[5], tmp); // sort #110
            sort_2(buffer[10],buffer[6], tmp); // sort #111
            sort_2(buffer[11],buffer[7], tmp); // sort #112
            sort_2(buffer[16],buffer[12], tmp); // sort #113
            sort_2(buffer[17],buffer[13], tmp); // sort #114
            sort_2(buffer[18],buffer[14], tmp); // sort #115
            sort_2(buffer[19],buffer[15], tmp); // sort #116
            sort_2(buffer[24],buffer[20], tmp); // sort #117
            sort_2(buffer[4],buffer[2], tmp); // sort #118
            sort_2(buffer[5],buffer[3], tmp); // sort #119
            sort_2(buffer[8],buffer[6], tmp); // sort #120
            sort_2(buffer[9],buffer[7], tmp); // sort #121
            sort_2(buffer[12],buffer[10], tmp); // sort #122
            sort_2(buffer[13],buffer[11], tmp); // sort #123
            sort_2(buffer[16],buffer[14], tmp); // sort #124
            sort_2(buffer[17],buffer[15], tmp); // sort #125
            sort_2(buffer[20],buffer[18], tmp); // sort #126
            sort_2(buffer[21],buffer[19], tmp); // sort #127
            sort_2(buffer[24],buffer[22], tmp); // sort #128
            sort_2(buffer[2],buffer[1], tmp); // sort #129
            sort_2(buffer[4],buffer[3], tmp); // sort #130
            sort_2(buffer[6],buffer[5], tmp); // sort #131
            sort_2(buffer[8],buffer[7], tmp); // sort #132
            sort_2(buffer[10],buffer[9], tmp); // sort #133
            sort_2(buffer[12],buffer[11], tmp); // sort #134
            sort_2(buffer[14],buffer[13], tmp); // sort #135
            sort_2(buffer[16],buffer[15], tmp); // sort #136
            sort_2(buffer[18],buffer[17], tmp); // sort #137
            sort_2(buffer[20],buffer[19], tmp); // sort #138
            sort_2(buffer[22],buffer[21], tmp); // sort #139
            sort_2(buffer[24],buffer[23], tmp); // sort #140

        sort_result[rgb] = buffer[12];
    }

  int out_idx = (row*imgWidth + col) * 3;
  #pragma unroll 3
  for (int rgb = 0; rgb < 3; rgb++)
  {
    gOutput[out_idx + rgb] = sort_result[rgb];
  }
}
