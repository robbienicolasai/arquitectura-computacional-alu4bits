# Notas rápidas FPGA

## Hardware
- Board: Digilent PYNQ-Z1
- SoC: Xilinx Zynq-7000
- PMODs usados: PMODA (JA) y PMODB (JB)

## Recomendaciones eléctricas
- Señales PMOD en 3.3V (LVCMOS33)
- GND común entre FPGA y protoboard
- Evitar entradas flotantes (pull-up/pull-down)
- LEDs con resistencia en serie (220Ω a 1kΩ)

## Errores detectados durante avance
- Proyecto creado con parte incorrecta en un punto (xc7z010).
- Parte correcta para PYNQ-Z1: xc7z020clg400-1.
- Importante definir top module en Vivado.
