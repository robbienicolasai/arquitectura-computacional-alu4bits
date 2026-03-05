-- ALU 32 bits (estilo clase) - Práctica 2
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu1 is
generic (data_width : integer := 32
);
port (
    opa : in std_logic_vector(data_width-1 downto 0);
    opb : in std_logic_vector(data_width-1 downto 0);
    alu_ctrl : in std_logic_vector(3 downto 0);

    result    : out std_logic_vector(data_width-1 downto 0);
    carry_out : out std_logic;
    overflow  : out std_logic;
    zero      : out std_logic;
    sign      : out std_logic
    --zero : out std_logic
);
end alu1;

architecture simple of alu1 is

constant ALU_ADD   : std_logic_vector(3 downto 0):= "0000";
constant ALU_SUB   : std_logic_vector(3 downto 0):= "0001";
constant ALU_AND   : std_logic_vector(3 downto 0):= "0010";
constant ALU_OR    : std_logic_vector(3 downto 0):= "0011";
constant ALU_XOR   : std_logic_vector(3 downto 0):= "0100";
constant ALU_SLL   : std_logic_vector(3 downto 0):= "0101";
constant ALU_SRL   : std_logic_vector(3 downto 0):= "0110";
constant ALU_SRA   : std_logic_vector(3 downto 0):= "0111";
constant ALU_SLT   : std_logic_vector(3 downto 0):= "1000";
constant ALU_SLTU  : std_logic_vector(3 downto 0):= "1001";
constant ALU_SLLI  : std_logic_vector(3 downto 0):= "1010";
constant ALU_SRLI  : std_logic_vector(3 downto 0):= "1011";
constant ALU_SRAI  : std_logic_vector(3 downto 0):= "1100";
constant ALU_LUI   : std_logic_vector(3 downto 0):= "1101";
constant ALU_AUIPC : std_logic_vector(3 downto 0):= "1110";
constant ALU_NOR   : std_logic_vector(3 downto 0):= "1111";

signal sum_extended : std_logic_vector(data_width downto 0);
signal sub_extended : std_logic_vector(data_width downto 0);
signal opa_extended, opb_extended : unsigned(data_width downto 0);

begin

-- Extender operandos
opa_extended <= unsigned('0' & opa);
opb_extended <= unsigned('0' & opb);

-- PROCESO PRINCIPAL CON CASES
process(opa, opb, alu_ctrl, sum_extended, sub_extended)
    variable shamt : integer range 0 to 31;
begin
    shamt := to_integer(unsigned(opb(4 downto 0)));

    case alu_ctrl is

        -- SUMA (simple con signo, como en clase)
        when ALU_ADD =>
            sum_extended <= (others => '0');
            sub_extended <= (others => '0');
            result <= std_logic_vector(signed(opa) + signed(opb));
            carry_out <= '0';
            overflow <= '0';

        -- RESTA (usando extendido también)
        when ALU_SUB =>
            sum_extended <= (others => '0');
            sub_extended <= std_logic_vector(opa_extended - opb_extended);
            result <= sub_extended(data_width-1 downto 0);
            carry_out <= sub_extended(data_width);
            overflow <= '0';

        -- AND
        when ALU_AND =>
            sum_extended <= (others => '0');
            sub_extended <= (others => '0');
            result <= opa and opb;
            carry_out <= '0';
            overflow <= '0';

        -- OR
        when ALU_OR =>
            sum_extended <= (others => '0');
            sub_extended <= (others => '0');
            result <= opa or opb;
            carry_out <= '0';
            overflow <= '0';

        -- XOR
        when ALU_XOR =>
            sum_extended <= (others => '0');
            sub_extended <= (others => '0');
            result <= opa xor opb;
            carry_out <= '0';
            overflow <= '0';

        -- SLL
        when ALU_SLL =>
            sum_extended <= (others => '0');
            sub_extended <= (others => '0');
            result <= std_logic_vector(shift_left(unsigned(opa), shamt));
            carry_out <= '0';
            overflow <= '0';

        -- SRL
        when ALU_SRL =>
            sum_extended <= (others => '0');
            sub_extended <= (others => '0');
            result <= std_logic_vector(shift_right(unsigned(opa), shamt));
            carry_out <= '0';
            overflow <= '0';

        -- SRA
        when ALU_SRA =>
            sum_extended <= (others => '0');
            sub_extended <= (others => '0');
            result <= std_logic_vector(shift_right(signed(opa), shamt));
            carry_out <= '0';
            overflow <= '0';

        -- SLT (signed)
        when ALU_SLT =>
            sum_extended <= (others => '0');
            sub_extended <= (others => '0');
            if signed(opa) < signed(opb) then
                result <= (0 => '1', others => '0');
            else
                result <= (others => '0');
            end if;
            carry_out <= '0';
            overflow <= '0';

        -- SLTU (unsigned)
        when ALU_SLTU =>
            sum_extended <= (others => '0');
            sub_extended <= (others => '0');
            if unsigned(opa) < unsigned(opb) then
                result <= (0 => '1', others => '0');
            else
                result <= (others => '0');
            end if;
            carry_out <= '0';
            overflow <= '0';

        -- SLLI
        when ALU_SLLI =>
            sum_extended <= (others => '0');
            sub_extended <= (others => '0');
            result <= std_logic_vector(shift_left(unsigned(opa), shamt));
            carry_out <= '0';
            overflow <= '0';

        -- SRLI
        when ALU_SRLI =>
            sum_extended <= (others => '0');
            sub_extended <= (others => '0');
            result <= std_logic_vector(shift_right(unsigned(opa), shamt));
            carry_out <= '0';
            overflow <= '0';

        -- SRAI
        when ALU_SRAI =>
            sum_extended <= (others => '0');
            sub_extended <= (others => '0');
            result <= std_logic_vector(shift_right(signed(opa), shamt));
            carry_out <= '0';
            overflow <= '0';

        -- LUI (B << 12)
        when ALU_LUI =>
            sum_extended <= (others => '0');
            sub_extended <= (others => '0');
            result <= std_logic_vector(shift_left(unsigned(opb), 12));
            carry_out <= '0';
            overflow <= '0';

        -- AUIPC simplificado: A(PC) + (B << 12)
        when ALU_AUIPC =>
            sum_extended <= std_logic_vector(opa_extended + ('0' & shift_left(unsigned(opb), 12)));
            sub_extended <= (others => '0');
            result <= sum_extended(data_width-1 downto 0);
            carry_out <= sum_extended(data_width);
            overflow <= '0';

        -- NOR
        when ALU_NOR =>
            sum_extended <= (others => '0');
            sub_extended <= (others => '0');
            result <= opa nor opb;
            carry_out <= '0';
            overflow <= '0';

        when others =>
            sum_extended <= (others => '0');
            sub_extended <= (others => '0');
            result <= (others => '0');
            carry_out <= '0';
            overflow <= '0';
    end case;

    -- banderas derivadas del resultado
    if result = (result'range => '0') then
        zero <= '1';
    else
        zero <= '0';
    end if;

    sign <= result(data_width-1);

end process;

end simple;
