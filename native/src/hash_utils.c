#include <stdint.h>
#include <stddef.h>

static uint32_t crc32_table[256];
static int table_ready = 0;

static void build_crc32_table(void) {
    for (uint32_t i = 0; i < 256; i++) {
        uint32_t crc = i;
        for (int j = 0; j < 8; j++) {
            crc = (crc >> 1) ^ (0xEDB88320 & (-(crc & 1)));
        }
        crc32_table[i] = crc;
    }
    table_ready = 1;
}

/// CRC32 using a 256-entry lookup table.
/// One table lookup per byte instead of 8 shifts per byte (bit-at-a-time).
uint32_t native_crc32(const uint8_t* data, int32_t length) {
    if (!table_ready) {
        build_crc32_table();
    }

    uint32_t crc = 0xFFFFFFFF;
    for (int32_t i = 0; i < length; i++) {
        crc = crc32_table[(crc ^ data[i]) & 0xFF] ^ (crc >> 8);
    }
    return crc ^ 0xFFFFFFFF;
}
