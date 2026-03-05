library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu1 is
generic (
    data_width : integer := 32
);
port (
    opa      : in  std_logic_vector(data_width-1 downto 0);
    opb      : in  std_logic_vector(data_width-1 downto 0);
    alu_ctrl : in  std_logic_vector(3 downto 0);

    result    : out std_logic_vector(data_width-1 downto 0);
    carry_out : out std_logic;
    overflow  : out std_logic;
    zero      : out std_logic;
    sign      : out std_logic
    -- zero : out std_logic
);
end alu1;

architecture simple of alu1 is

-- CONSTANTES DE OPERACION
constant ALU_ADD   : std_logic_vector(3 downto 0) := "0000";
constant ALU_SUB   : std_logic_vector(3 downto 0) := "0001";
constant ALU_AND   : std_logic_vector(3 downto 0) := "0010";
constant ALU_OR    : std_logic_vector(3 downto 0) := "0011";
constant ALU_XOR   : std_logic_vector(3 downto 0) := "0100";
constant ALU_SLL   : std_logic_vector(3 downto 0) := "0101";
constant ALU_SRL   : std_logic_vector(3 downto 0) := "0110";
constant ALU_SRA   : std_logic_vector(3 downto 0) := "0111";
constant ALU_SLT   : std_logic_vector(3 downto 0) := "1000";
constant ALU_SLTU  : std_logic_vector(3 downto 0) := "1001";
constant ALU_SLLI  : std_logic_vector(3 downto 0) := "1010";
constant ALU_SRLI  : std_logic_vector(3 downto 0) := "1011";
constant ALU_SRAI  : std_logic_vector(3 downto 0) := "1100";
constant ALU_LUI   : std_logic_vector(3 downto 0) := "1101";
constant ALU_AUIPC : std_logic_vector(3 downto 0) := "1110";
constant ALU_NOR   : std_logic_vector(3 downto 0) := "1111";

-- SEÑALES INTERNAS
signal sum_extended : std_logic_vector(data_width downto 0);
signal sub_extended : std_logic_vector(data_width downto 0);
signal opa_extended, opb_extended : unsigned(data_width downto 0);
signal r_int : std_logic_vector(data_width-1 downto 0);

begin

-- EXTENDER OPERANDOS (para carry)
opa_extended <= unsigned('0' & opa);
opb_extended <= unsigned('0' & opb);

-- PROCESO PRINCIPAL CON CASES
process(opa, opb, alu_ctrl, opa_extended, opb_extended)
    variable shamt    : integer range 0 to 31;
    variable b_shl_12 : unsigned(data_width-1 downto 0);
    variable sumv     : unsigned(data_width downto 0);
    variable subv     : unsigned(data_width downto 0);
begin
    shamt := to_integer(unsigned(opb(4 downto 0)));

    -- defaults
    r_int      <= (others => '0');
    sum_extended <= (others => '0');
    sub_extended <= (others => '0');
    carry_out  <= '0';
    overflow   <= '0';

    case alu_ctrl is

        -- ADD
        when ALU_ADD =>
            sumv := opa_extended + opb_extended;
            sum_extended <= std_logic_vector(sumv);
            r_int <= std_logic_vector(sumv(data_width-1 downto 0));
            carry_out <= sumv(data_width);
            overflow <= (not (opa(data_width-1) xor opb(data_width-1))) and (opa(data_width-1) xor std_logic(sumv(data_width-1)));

        -- SUB
        when ALU_SUB =>
            subv := opa_extended - opb_extended;
            sub_extended <= std_logic_vector(subv);
            r_int <= std_logic_vector(subv(data_width-1 downto 0));
            carry_out <= subv(data_width);
            overflow <= (opa(data_width-1) xor opb(data_width-1)) and (opa(data_width-1) xor std_logic(subv(data_width-1)));

        -- AND
        when ALU_AND =>
            r_int <= opa and opb;

        -- OR
        when ALU_OR =>
            r_int <= opa or opb;

        -- XOR
        when ALU_XOR =>
            r_int <= opa xor opb;

        -- SLL
        when ALU_SLL =>
            r_int <= std_logic_vector(shift_left(unsigned(opa), shamt));

        -- SRL
        when ALU_SRL =>
            r_int <= std_logic_vector(shift_right(unsigned(opa), shamt));

        -- SRA
        when ALU_SRA =>
            r_int <= std_logic_vector(shift_right(signed(opa), shamt));

        -- SLT (signed)
        when ALU_SLT =>
            if signed(opa) < signed(opb) then
                r_int <= (0 => '1', others => '0');
            else
                r_int <= (others => '0');
            end if;

        -- SLTU (unsigned)
        when ALU_SLTU =>
            if unsigned(opa) < unsigned(opb) then
                r_int <= (0 => '1', others => '0');
            else
                r_int <= (others => '0');
            end if;

        -- SLLI (usa opb[4:0] como inmediato)
        when ALU_SLLI =>
            r_int <= std_logic_vector(shift_left(unsigned(opa), shamt));

        -- SRLI
        when ALU_SRLI =>
            r_int <= std_logic_vector(shift_right(unsigned(opa), shamt));

        -- SRAI
        when ALU_SRAI =>
            r_int <= std_logic_vector(shift_right(signed(opa), shamt));

        -- LUI = B << 12
        when ALU_LUI =>
            r_int <= std_logic_vector(shift_left(unsigned(opb), 12));

        -- AUIPC simplificado = A(PC) + (B << 12)
        when ALU_AUIPC =>
            b_shl_12 := shift_left(unsigned(opb), 12);
            sumv := opa_extended + ('0' & b_shl_12);
            sum_extended <= std_logic_vector(sumv);
            r_int <= std_logic_vector(sumv(data_width-1 downto 0));
            carry_out <= sumv(data_width);
            overflow <= (not (opa(data_width-1) xor std_logic(b_shl_12(data_width-1)))) and
                        (opa(data_width-1) xor std_logic(sumv(data_width-1)));

        -- NOR
        when ALU_NOR =>
            r_int <= opa nor opb;

        when others =>
            r_int <= (others => '0');
    end case;

end process;

-- SALIDAS
result <= r_int;
zero   <= '1' when r_int = (r_int'range => '0') else '0';
sign   <= r_int(data_width-1);

end simple;
