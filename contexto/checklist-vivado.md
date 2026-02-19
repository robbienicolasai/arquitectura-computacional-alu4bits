# Checklist Vivado

1. Verificar `Project part = xc7z020clg400-1`.
2. Agregar VHDL y XDC.
3. Definir `Set as Top` en entidad principal.
4. Validar que puertos coincidan con XDC (`op_a`, `op_b`, `alu_ctrl`, `result`).
5. `Run Synthesis`.
6. `Run Implementation`.
7. `Generate Bitstream`.
8. `Open Hardware Manager` -> `Program Device`.

## Si falla
- Revisar primer error en Messages.
- Confirmar nombres exactos de puertos.
- Confirmar que no haya constraints en pines inválidos para la parte seleccionada.
