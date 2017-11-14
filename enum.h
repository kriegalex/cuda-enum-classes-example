
/**
 * @license MIT
 * @author Marco Lourenço
 * @date 14.11.17.
 */

#pragma once

#include <cstring>
#include "managed.h"
#include "cuda_helper.h"

enum class Animal : unsigned short { cat = 1, dog = 4, bird = 15 };

enum Mammal : unsigned short { human = 2, deer = 6 };

enum class Color { red, green, blue };

struct ManagedAnimal : public Managed {
  Animal *animal;

  ManagedAnimal() {
    cudaMallocManaged(&animal, sizeof(Animal));
  }

  ManagedAnimal(const ManagedAnimal &a) {
    memcpy(animal, a.animal, sizeof(Animal));
  }

  ~ManagedAnimal() { cudaFree(animal); }
};
