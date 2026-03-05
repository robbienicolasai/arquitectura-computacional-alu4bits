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

begin

-- PROCESO PRINCIPAL CON CASES
process(opa, opb, alu_ctrl)
    variable shamt      : integer range 0 to 31;
    variable res_v      : std_logic_vector(data_width-1 downto 0);
    variable sum_ext_v  : unsigned(data_width downto 0);
    variable sub_ext_v  : unsigned(data_width downto 0);
    variable b_shl_12_v : unsigned(data_width-1 downto 0);
    variable c_v        : std_logic;
    variable o_v        : std_logic;
begin
    shamt := to_integer(unsigned(opb(4 downto 0)));

    -- defaults
    res_v := (others => '0');
    c_v   := '0';
    o_v   := '0';

    case alu_ctrl is

        -- ADD
        when ALU_ADD =>
            sum_ext_v := unsigned('0' & opa) + unsigned('0' & opb);
            res_v := std_logic_vector(sum_ext_v(data_width-1 downto 0));
            c_v := sum_ext_v(data_width);
            -- overflow suma con signo
            o_v := (not (opa(data_width-1) xor opb(data_width-1))) and
                   (opa(data_width-1) xor res_v(data_width-1));

        -- SUB
        when ALU_SUB =>
            sub_ext_v := unsigned('0' & opa) - unsigned('0' & opb);
            res_v := std_logic_vector(sub_ext_v(data_width-1 downto 0));
            c_v := sub_ext_v(data_width);
            -- overflow resta con signo
            o_v := (opa(data_width-1) xor opb(data_width-1)) and
                   (opa(data_width-1) xor res_v(data_width-1));

        -- AND
        when ALU_AND =>
            res_v := opa and opb;

        -- OR
        when ALU_OR =>
            res_v := opa or opb;

        -- XOR
        when ALU_XOR =>
            res_v := opa xor opb;

        -- SLL
        when ALU_SLL =>
            res_v := std_logic_vector(shift_left(unsigned(opa), shamt));

        -- SRL
        when ALU_SRL =>
            res_v := std_logic_vector(shift_right(unsigned(opa), shamt));

        -- SRA
        when ALU_SRA =>
            res_v := std_logic_vector(shift_right(signed(opa), shamt));

        -- SLT (signed)
        when ALU_SLT =>
            if signed(opa) < signed(opb) then
                res_v := (0 => '1', others => '0');
            else
                res_v := (others => '0');
            end if;

        -- SLTU (unsigned)
        when ALU_SLTU =>
            if unsigned(opa) < unsigned(opb) then
                res_v := (0 => '1', others => '0');
            else
                res_v := (others => '0');
            end if;

        -- SLLI
        when ALU_SLLI =>
            res_v := std_logic_vector(shift_left(unsigned(opa), shamt));

        -- SRLI
        when ALU_SRLI =>
            res_v := std_logic_vector(shift_right(unsigned(opa), shamt));

        -- SRAI
        when ALU_SRAI =>
            res_v := std_logic_vector(shift_right(signed(opa), shamt));

        -- LUI: B << 12
        when ALU_LUI =>
            res_v := std_logic_vector(shift_left(unsigned(opb), 12));

        -- AUIPC simplificado: A(PC) + (B << 12)
        when ALU_AUIPC =>
            b_shl_12_v := shift_left(unsigned(opb), 12);
            sum_ext_v := unsigned('0' & opa) + unsigned('0' & std_logic_vector(b_shl_12_v));
            res_v := std_logic_vector(sum_ext_v(data_width-1 downto 0));
            c_v := sum_ext_v(data_width);
            o_v := (not (opa(data_width-1) xor std_logic_vector(b_shl_12_v)(data_width-1))) and
                   (opa(data_width-1) xor res_v(data_width-1));

        -- NOR
        when ALU_NOR =>
            res_v := opa nor opb;

        when others =>
            res_v := (others => '0');
            c_v   := '0';
            o_v   := '0';
    end case;

    -- salidas
    result    <= res_v;
    carry_out <= c_v;
    overflow  <= o_v;

    if res_v = (res_v'range => '0') then
        zero <= '1';
    else
        zero <= '0';
    end if;

    sign <= res_v(data_width-1);

end process;

end simple;
