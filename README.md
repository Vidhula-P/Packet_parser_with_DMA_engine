# Packet Parser with DMA Engine
*(DMA Engine pending)*

This project implements a system that parses **96 B input data** and forwards the payload to a FIFO buffer. The system structure is as follows:

## Data Structure
The input data consists of:

- **Ethernet header (16 B)**: A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1
- **IP header (20 B)**: B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2
- **TCP header (20 B)**: C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
- **Payload (40 B)**: D4F40099D4F40099D4F40099D4F40099D4F40099D4F40099D4F40099D4F40099D4F40099D4F40099


## System Description
- The **parser** extracts header information and forwards **only the payload** to a `32x16` FIFO buffer.
- Both the **parser** and **FIFO** were individually tested:
- `tb/fifo_tb.sv`
- `tb/parser_tb.sv`
- Integration testing was done in `tb/tb.sv`.

## Simulation & Debugging
Simulation outputs were verified using **SimVision**, ensuring correct handshake signals and data flow. Debug statements were added at important location printing the below self-explanatory debug statements-
```
Word sent in testbench- a1a1a1a1 
Word sent in testbench- a1a1a1a1 
Word sent in testbench- a1a1a1a1 
Word sent in testbench- a1a1a1a1 
Word sent in testbench- b2b2b2b2 
Word sent in testbench- b2b2b2b2 
Word sent in testbench- b2b2b2b2 
Word sent in testbench- b2b2b2b2 
Word sent in testbench- b2b2b2b2 
Word sent in testbench- c3c3c3c3 
Word sent in testbench- c3c3c3c3 
Word sent in testbench- c3c3c3c3 
Word sent in testbench- c3c3c3c3 
Word sent in testbench- c3c3c3c3 
Write pointer- 0 
Word sent in testbench- d4f40099 
Write pointer- 1 
Word sent in testbench- d4f40099 
Write pointer- 2 
Word sent in testbench- d4f40099 
Write pointer- 3 
Word sent in testbench- d4f40099 
Write pointer- 4 
Word sent in testbench- d4f40099 
Write pointer- 5 
Word sent in testbench- d4f40099 
Write pointer- 6 
Word sent in testbench- d4f40099 
Write pointer- 7 
Word sent in testbench- d4f40099 
Write pointer- 8 
Word sent in testbench- d4f40099 
Write pointer- 9 
Word sent in testbench- d4f40099 
Read pointer- 0 
FIFO OUT: d4f40099 
Read pointer- 1 
FIFO OUT: d4f40099 
Read pointer- 2 
FIFO OUT: d4f40099 
Read pointer- 3 
FIFO OUT: d4f40099 
Read pointer- 4 
FIFO OUT: d4f40099 
Read pointer- 5 
FIFO OUT: d4f40099 
Read pointer- 6 
FIFO OUT: d4f40099 
Read pointer- 7 
FIFO OUT: d4f40099 
Read pointer- 8 
FIFO OUT: d4f40099 
Read pointer- 9 
FIFO OUT: d4f40099
```
## Conclusion
The code successfully parses the headers and forwards the payload to the FIFO buffer as intended.  
