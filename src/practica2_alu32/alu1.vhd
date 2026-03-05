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
        result   : out std_logic_vector(data_width-1 downto 0);
        carry_out: out std_logic
        -- zero  : out std_logic
    );
end alu1;

architecture simple of alu1 is
    constant ALU_ADD  : std_logic_vector(3 downto 0) := "0000";
    constant ALU_SUB  : std_logic_vector(3 downto 0) := "0001";
    constant ALU_AND  : std_logic_vector(3 downto 0) := "0010";
    constant ALU_OR   : std_logic_vector(3 downto 0) := "0011";
    constant ALU_XOR  : std_logic_vector(3 downto 0) := "0100";
    constant ALU_NOR  : std_logic_vector(3 downto 0) := "0101";
    constant ALU_ADDE : std_logic_vector(3 downto 0) := "0110";

    signal sum_extended : std_logic_vector(data_width downto 0);
    signal opa_extended, opb_extended : unsigned(data_width downto 0);
begin
    opa_extended <= unsigned('0' & opa);
    opb_extended <= unsigned('0' & opb);

    process(opa, opb, alu_ctrl, sum_extended)
    begin
        case alu_ctrl is
            when ALU_ADD =>
                sum_extended <= (others => '0');
                result <= std_logic_vector(signed(opa) + signed(opb));
                carry_out <= '0';

            when ALU_ADDE =>
                sum_extended <= std_logic_vector(opa_extended + opb_extended);
                result <= sum_extended(data_width-1 downto 0);
                carry_out <= sum_extended(data_width);

            when ALU_SUB =>
                sum_extended <= (others => '0');
                result <= std_logic_vector(signed(opa) - signed(opb));
                carry_out <= '0';

            when ALU_AND =>
                sum_extended <= (others => '0');
                result <= opa and opb;
                carry_out <= '0';

            when ALU_OR =>
                sum_extended <= (others => '0');
                result <= opa or opb;
                carry_out <= '0';

            when ALU_XOR =>
                sum_extended <= (others => '0');
                result <= opa xor opb;
                carry_out <= '0';

            when ALU_NOR =>
                sum_extended <= (others => '0');
                result <= opa nor opb;
                carry_out <= '0';

            when others =>
                sum_extended <= (others => '0');
                result <= (others => '0');
                carry_out <= '0';
        end case;
    end process;
end simple;
