//
//  shiftLeft.metal
//  Ledify
//
//  Created by Mark Wong on 4/1/2023.
//

#include <metal_stdlib>
using namespace metal;

kernel void compute0(constant int &width, device vector_int2 *array [[ buffer(0) ]],
                     uint2 tid [[thread_position_in_grid]]) {
    
    for (int i = 0; i < width - 1; i++) {
        if (tid.x == i) {
            array[tid.y * width + tid.x].x = array[tid.y * width + tid.x + 1].x;
        }
    }
    if (tid.x == width - 1) {
        array[tid.y * width + tid.x].x = 0;
    }
}

 
//kernel void setLEDColors(
//    device simd_float4* ledBuffer [[ buffer(0) ]],
//    uint2 gid [[ thread_position_in_grid ]] ) {
//    const int numRows = 10; // replace with actual number of rows
//    const int numCols = 10; // replace with actual number of columns
//
//    int index = gid.y * numCols + gid.x;
//    if (index < numRows * numCols) {
//        float4 color = float4(ledBuffer[index].rgb, 1.0);
//        color = saturate(color); // clamp to valid range (0-1)
//        ledBuffer[index] = simd_make_float4(color.r, color.g, color.b, color.a);
//    }
//}
