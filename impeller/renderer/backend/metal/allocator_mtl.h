// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef FLUTTER_IMPELLER_RENDERER_BACKEND_METAL_ALLOCATOR_MTL_H_
#define FLUTTER_IMPELLER_RENDERER_BACKEND_METAL_ALLOCATOR_MTL_H_

#include <Metal/Metal.h>

#include "impeller/core/allocator.h"

namespace impeller {

class AllocatorMTL final : public Allocator {
 public:
  AllocatorMTL();

  // |Allocator|
  ~AllocatorMTL() override;

 private:
  friend class ContextMTL;

  id<MTLDevice> device_;
  std::string allocator_label_;
  bool supports_memoryless_targets_ = false;
  bool supports_uma_ = false;
  bool is_valid_ = false;
  ISize max_texture_supported_;

  AllocatorMTL(id<MTLDevice> device, std::string label);

  // |Allocator|
  bool IsValid() const;

  // |Allocator|
  std::shared_ptr<DeviceBuffer> OnCreateBuffer(
      const DeviceBufferDescriptor& desc) override;

  // |Allocator|
  std::shared_ptr<Texture> OnCreateTexture(
      const TextureDescriptor& desc) override;

  // |Allocator|
  uint16_t MinimumBytesPerRow(PixelFormat format) const override;

  // |Allocator|
  ISize GetMaxTextureSizeSupported() const override;

  AllocatorMTL(const AllocatorMTL&) = delete;

  AllocatorMTL& operator=(const AllocatorMTL&) = delete;
};

}  // namespace impeller

#endif  // FLUTTER_IMPELLER_RENDERER_BACKEND_METAL_ALLOCATOR_MTL_H_
