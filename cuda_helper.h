
/**
 * @license MIT
 * @author Marco Lourenço
 * @date 14.11.17.
 */

#pragma once

#include <cuda_runtime.h>
#include <cstdio>
#include <cstdlib>

__host__ __forceinline__ void checkCudaError(cudaError_t code, const char *file,
                                             int line, bool abort = true) {
  if (code != cudaSuccess) {
    fprintf(stderr, "CheckCudaError: %s %s %d\n", cudaGetErrorString(code),
            file, line);
    if (abort)
      exit(code);
  }
}
// checking for errors in CUDA code
#define CUDA_SAFE_CALL(ans)                                                    \
  { checkCudaError((ans), __FILE__, __LINE__, false); }

