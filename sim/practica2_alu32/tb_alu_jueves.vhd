library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_alu_jueves is
end tb_alu_jueves;

architecture simple of tb_alu_jueves is
    constant data_width : integer := 32;
    constant CLK_PERIOD : time := 10 ns;

    signal opa_tb      : std_logic_vector(data_width-1 downto 0);
    signal opb_tb      : std_logic_vector(data_width-1 downto 0);
    signal alu_ctrl_tb : std_logic_vector(3 downto 0);
    signal result_tb   : std_logic_vector(data_width-1 downto 0);
    signal carry_out_tb: std_logic;

    constant ALU_ADD  : std_logic_vector(3 downto 0) := "0000";
    constant ALU_SUB  : std_logic_vector(3 downto 0) := "0001";
    constant ALU_AND  : std_logic_vector(3 downto 0) := "0010";
    constant ALU_OR   : std_logic_vector(3 downto 0) := "0011";
    constant ALU_XOR  : std_logic_vector(3 downto 0) := "0100";
    constant ALU_NOR  : std_logic_vector(3 downto 0) := "0101";
    constant ALU_ADDE : std_logic_vector(3 downto 0) := "0110";
begin
    alu1_i : entity work.alu1
        generic map (data_width => data_width)
        port map (
            opa       => opa_tb,
            opb       => opb_tb,
            alu_ctrl  => alu_ctrl_tb,
            result    => result_tb,
            carry_out => carry_out_tb
        );

    stim : process
    begin
        -- TEST 1: ADD con signo
        opa_tb <= x"0000000B"; -- 11
        opb_tb <= x"00000002"; -- 2
        alu_ctrl_tb <= ALU_ADD;
        wait for CLK_PERIOD;

        -- TEST 2: SUB con signo
        opa_tb <= x"00000008"; -- 8
        opb_tb <= x"00000007"; -- 7
        alu_ctrl_tb <= ALU_SUB;
        wait for CLK_PERIOD;

        -- TEST 3: XOR
        opa_tb <= x"00000008";
        opb_tb <= x"00000007";
        alu_ctrl_tb <= ALU_XOR;
        wait for CLK_PERIOD;

        -- TEST 4: ADDE (con carry)
        opa_tb <= x"FFFFFFFF";
        opb_tb <= x"00000001";
        alu_ctrl_tb <= ALU_ADDE;
        wait for CLK_PERIOD;

        wait;
    end process;
end simple;
