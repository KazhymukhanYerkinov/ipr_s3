#ifndef HASH_UTILS_H
#define HASH_UTILS_H

#include <stdint.h>

uint32_t native_crc32(const uint8_t* data, int32_t length);
uint32_t native_djb2_hash(const char* str);
int32_t native_count_bytes(const uint8_t* data, int32_t length, uint8_t target);

#endif
