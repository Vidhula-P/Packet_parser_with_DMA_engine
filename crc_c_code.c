// C code to verify SystemVerilog output
// Adapted from https://stigge.org/martin/pub/SAR-PR-2006-05.pdf (Systems Architecture Group, Humboldt University Berlin)

#include <stdint.h>
#include <stdio.h>

#define CRCPOLY  0xEDB88320
#define INITXOR  0xFFFFFFFF
#define FINALXOR 0xFFFFFFFF

uint32_t crc32(uint8_t *data_raw, int length) {
    uint32_t temp_crc = INITXOR;

    for (int j = 0; j < length; j++) {
        uint8_t data_byte = data_raw[j];
        for (int i = 0; i < 8; i++) {
            if ((temp_crc ^ data_byte) & 1)
                temp_crc = (temp_crc >> 1) ^ CRCPOLY;
            else
                temp_crc >>= 1;
            data_byte >>= 1;
        }
    }
    return temp_crc ^ FINALXOR;
}

int main() {
		//0123456789ABCDEF00112233445566778899AABBCCDDEEFF0F1E2D3C4B5A6978
    uint8_t input[32] = {
		0x01, 0x23, 0x45, 0x67, 0x89, 0xAB, 0xCD, 0xEF,   0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77,
		0x88, 0x99, 0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF,   0x0F, 0x1E, 0x2D, 0x3C, 0x4B, 0x5A, 0x69, 0x78
		};

    uint32_t out = crc32(input, 32);
    printf("%08X\n", out);
    return 0;
}

