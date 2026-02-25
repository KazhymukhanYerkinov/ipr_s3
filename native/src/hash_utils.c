#include <stdint.h>
#include <stddef.h>

/// CRC32 checksum for file integrity verification.
/// Uses the standard CRC32 polynomial (0xEDB88320, reflected).
///
/// @param data   Pointer to the byte array
/// @param length Number of bytes to process
/// @return       CRC32 checksum as uint32_t
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

/// DJB2 string hash — fast, non-cryptographic hash for deduplication.
/// Created by Daniel J. Bernstein.
///
/// @param str  Null-terminated C string
/// @return     Hash value as uint32_t
uint32_t native_djb2_hash(const char* str) {
    uint32_t hash = 5381;
    int c;
    while ((c = *str++)) {
        hash = ((hash << 5) + hash) + c; // hash * 33 + c
    }
    return hash;
}

/// Counts occurrences of a specific byte in a data buffer.
/// Useful for entropy analysis of encrypted files.
///
/// @param data   Pointer to the byte array
/// @param length Number of bytes to scan
/// @param target The byte value to count
/// @return       Number of occurrences
int32_t native_count_bytes(const uint8_t* data, int32_t length, uint8_t target) {
    int32_t count = 0;
    for (int32_t i = 0; i < length; i++) {
        if (data[i] == target) {
            count++;
        }
    }
    return count;
}
