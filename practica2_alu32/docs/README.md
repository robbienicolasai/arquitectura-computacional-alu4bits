# Práctica 2 — ALU RISC-V de 32 bits

Implementación base alineada al enunciado de práctica:
- 16 operaciones (ALUControl[3:0])
- Banderas: `Zero`, `CarryOut`, `Overflow`, `Sign`
- AUIPC simplificado usando `A` como PC: `A + (B << 12)`

## Archivos
- `src/practica2_alu32/alu1.vhd`
- `sim/practica2_alu32/tb_alu_jueves.vhd`

## Mapa de operaciones
- `0000` ADD
- `0001` SUB
- `0010` AND
- `0011` OR
- `0100` XOR
- `0101` SLL
- `0110` SRL
- `0111` SRA
- `1000` SLT
- `1001` SLTU
- `1010` SLLI
- `1011` SRLI
- `1100` SRAI
- `1101` LUI (`B << 12`)
- `1110` AUIPC (`A + (B << 12)`)
- `1111` NOR

## Nota
Para corrimientos, la cantidad se toma de `B[4:0]`.
