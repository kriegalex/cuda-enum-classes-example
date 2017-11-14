
/**
 * @license MIT
 * @author Marco Lourenço
 * @date 14.11.17.
 */

// cuda_runtime include not needed by nvcc, only to help IDE
#include <cuda_runtime.h>
#include <iostream>

#include "enum.h"
#include "cuda_helper.h"

__device__ void giveTheColorPlz(const Color &c) {
  Color kernel_color = Color::red;
  bool tmp = (c == kernel_color);
  printf("device fct param is red: %d\n", tmp);
}

__global__ void testEnumKernel(Color *color_device,
                               const Animal *animal_device,
                               const Mammal *mammal_device,
                               const ManagedAnimal *managed_animal) {
  printf("animal casted: %u\n", static_cast<ushort>(*animal_device));
  printf("animal not explicitly casted: %u\n", *animal_device);
  printf("mammal casted: %u\n", static_cast<ushort>(*mammal_device));
  printf("mammal not explicitly casted: %u\n", *mammal_device);
  printf("color not explicitly casted: %u\n", *color_device);

  bool tmp = (*color_device == Color::red);
  printf("color equals red: %d\n", tmp);

  *color_device = Color::blue;
  printf("color set to blue\n");
  tmp = (*color_device == Color::red);
  printf("color equals red: %d\n", tmp);

  printf("color not explicitly casted: %u\n", *color_device);

  giveTheColorPlz(Color::red);

  tmp = (*(managed_animal->animal) == Animal::cat);
  printf("managed animal is cat: %d\n", tmp);
}

int main() {

  //--- Without UNIFIED MEMORY ---

  Color red_host = Color::red;
  Animal cat_host = Animal::cat;
  Mammal deer_host = Mammal::deer;

  Color *red_device;
  cudaMalloc(&red_device, sizeof(Color));
  cudaMemcpy(red_device, &red_host, sizeof(Color), cudaMemcpyHostToDevice);

  Animal *cat_device;
  cudaMalloc(&cat_device, sizeof(Animal));
  cudaMemcpy(cat_device, &cat_host, sizeof(Animal), cudaMemcpyHostToDevice);

  Mammal *deer_device;
  cudaMalloc(&deer_device, sizeof(Mammal));
  cudaMemcpy(deer_device, &deer_host, sizeof(Mammal), cudaMemcpyHostToDevice);

  //--- With UNIFIED MEMORY ---

  // ManagedAnimal managed_animal; --> THIS WILL NOT WORK
  ManagedAnimal *managed_animal = new ManagedAnimal;
  *(managed_animal->animal) = Animal::cat;

  testEnumKernel <<< 1, 1 >>>
      (red_device, cat_device, deer_device, managed_animal);
  CUDA_SAFE_CALL(cudaDeviceSynchronize()) // this should NOT give a CUDA error

  return EXIT_SUCCESS;
}