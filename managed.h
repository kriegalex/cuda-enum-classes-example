
/**
 * @license MIT
 * @author Marco Lourenço
 * @date 14.11.17.
 */

#pragma once

#include <cuda_runtime.h>

/**
 * For more informations :
 * https://devblogs.nvidia.com/parallelforall/unified-memory-in-cuda-6/
 */
class Managed {
 public:
  void *operator new(size_t len) {
    void *ptr;
    cudaMallocManaged(&ptr, len);
    cudaDeviceSynchronize();
    return ptr;
  }

  void operator delete(void *ptr) {
    cudaDeviceSynchronize();
    cudaFree(ptr);
  }
};
