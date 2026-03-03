## =========================
## PYNQ-Z1 - ALU 4 bits
## PMODA -> op_a, op_b
## PMODB -> alu_ctrl, result
## Device: xc7z020clg400-1
## =========================

## ---------- PMODA ----------
## op_a[3:0] -> PMODA[0..3]
set_property PACKAGE_PIN Y18 [get_ports {op_a[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {op_a[0]}]

set_property PACKAGE_PIN Y19 [get_ports {op_a[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {op_a[1]}]

set_property PACKAGE_PIN Y16 [get_ports {op_a[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {op_a[2]}]

set_property PACKAGE_PIN Y17 [get_ports {op_a[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {op_a[3]}]

## op_b[3:0] -> PMODA[4..7]
set_property PACKAGE_PIN U18 [get_ports {op_b[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {op_b[0]}]

set_property PACKAGE_PIN U19 [get_ports {op_b[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {op_b[1]}]

set_property PACKAGE_PIN W18 [get_ports {op_b[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {op_b[2]}]

set_property PACKAGE_PIN W19 [get_ports {op_b[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {op_b[3]}]

## ---------- PMODB ----------
## alu_ctrl[3:0] -> PMODB[0..3]
set_property PACKAGE_PIN W14 [get_ports {alu_ctrl[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {alu_ctrl[0]}]

set_property PACKAGE_PIN Y14 [get_ports {alu_ctrl[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {alu_ctrl[1]}]

set_property PACKAGE_PIN T11 [get_ports {alu_ctrl[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {alu_ctrl[2]}]

set_property PACKAGE_PIN T10 [get_ports {alu_ctrl[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {alu_ctrl[3]}]

## result[3:0] -> PMODB[4..7]
set_property PACKAGE_PIN V16 [get_ports {result[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {result[0]}]

set_property PACKAGE_PIN W16 [get_ports {result[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {result[1]}]

set_property PACKAGE_PIN V12 [get_ports {result[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {result[2]}]

set_property PACKAGE_PIN W13 [get_ports {result[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {result[3]}]

## ---------- OPTIONAL PULLUPS (inputs only) ----------
set_property PULLUP true [get_ports {op_a[2]}]
set_property PULLUP true [get_ports {op_a[3]}]
set_property PULLUP true [get_ports {op_b[2]}]
set_property PULLUP true [get_ports {op_b[3]}]
set_property PULLUP true [get_ports {alu_ctrl[2]}]
set_property PULLUP true [get_ports {alu_ctrl[3]}]
