# XDC de referencia (ALU 4 bits)

> Este archivo resume el mapeo discutido para usar PMODA/PMODB con señales `op_a`, `op_b`, `alu_ctrl`, `result` y `IOSTANDARD LVCMOS33`.
> Ajustar según la fuente oficial de constraints de la placa y el diseño final.

## PMODA (ejemplo)
- op_a[0..3]
- op_b[0..3]

## PMODB (ejemplo)
- alu_ctrl[0..3]
- result[0..3]

## Reglas
- Nombres del XDC deben coincidir exactamente con los puertos del `entity` VHDL.
- Usar siempre `LVCMOS33`.
- Revisar warnings de constraints antes de generar bitstream.
