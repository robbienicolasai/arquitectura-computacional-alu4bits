# Proyecto: Arquitectura Computacional (FPGA en PYNQ-Z1)

Repositorio para organizar prácticas de ALU en Vivado (PYNQ-Z1 / `xc7z020clg400-1`).

## Prácticas en este repo

### Práctica 1 — ALU 4 bits
- `src/alu1_0.vhd`
- `constraints/alu4bits_pynqz1_pmod.xdc`
- `reportes/practica1_alu4bits/`

### Práctica 2 — ALU 32 bits
- `practica2_alu32/src/alu1.vhd`
- `practica2_alu32/sim/tb_alu_jueves.vhd`
- `practica2_alu32/docs/`
- `practica2_alu32/results/`

## Soporte y contexto
- `contexto/notas-fpga.md`
- `contexto/xdc-referencia.md`
- `contexto/checklist-vivado.md`
- `PLAN_INTERACTIVO.md`

## Flujo de trabajo recomendado
1. Crear proyecto Vivado con `xc7z020clg400-1`.
2. Agregar archivos de la práctica correspondiente.
3. Definir top entity.
4. Ejecutar Synthesis → Implementation → Generate Bitstream.
