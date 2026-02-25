#include <stdint.h>
#include <stddef.h>

/// CRC32 checksum for file integrity verification.
uint32_t native_crc32(const uint8_t* data, int32_t length) {
    uint32_t crc = 0xFFFFFFFF;
    for (int32_t i = 0; i < length; i++) {
        crc ^= data[i];
        for (int j = 0; j < 8; j++) {
            crc = (crc >> 1) ^ (0xEDB88320 & (-(crc & 1)));
        }
    }
    return crc ^ 0xFFFFFFFF;
}

/// DJB2 string hash for fast deduplication.
uint32_t native_djb2_hash(const char* str) {
    uint32_t hash = 5381;
    int c;
    while ((c = *str++)) {
        hash = ((hash << 5) + hash) + c;
    }
    return hash;
}

/// Counts occurrences of a specific byte value.
int32_t native_count_bytes(const uint8_t* data, int32_t length, uint8_t target) {
    int32_t count = 0;
    for (int32_t i = 0; i < length; i++) {
        if (data[i] == target) {
            count++;
        }
    }
    return count;
}
