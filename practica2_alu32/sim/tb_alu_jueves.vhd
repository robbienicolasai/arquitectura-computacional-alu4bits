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
    signal zero_tb     : std_logic;
    signal carry_out_tb: std_logic;
    signal overflow_tb : std_logic;
    signal sign_tb     : std_logic;

    constant ALU_ADD  : std_logic_vector(3 downto 0) := "0000";
    constant ALU_SUB  : std_logic_vector(3 downto 0) := "0001";
    constant ALU_AND  : std_logic_vector(3 downto 0) := "0010";
    constant ALU_OR   : std_logic_vector(3 downto 0) := "0011";
    constant ALU_XOR  : std_logic_vector(3 downto 0) := "0100";
    constant ALU_SLL  : std_logic_vector(3 downto 0) := "0101";
    constant ALU_SRL  : std_logic_vector(3 downto 0) := "0110";
    constant ALU_SRA  : std_logic_vector(3 downto 0) := "0111";
    constant ALU_SLT  : std_logic_vector(3 downto 0) := "1000";
    constant ALU_SLTU : std_logic_vector(3 downto 0) := "1001";
    constant ALU_SLLI : std_logic_vector(3 downto 0) := "1010";
    constant ALU_SRLI : std_logic_vector(3 downto 0) := "1011";
    constant ALU_SRAI : std_logic_vector(3 downto 0) := "1100";
    constant ALU_LUI  : std_logic_vector(3 downto 0) := "1101";
    constant ALU_AUIPC: std_logic_vector(3 downto 0) := "1110";
    constant ALU_NOR  : std_logic_vector(3 downto 0) := "1111";
begin
    dut: entity work.alu1
        generic map (data_width => data_width)
        port map (
            opa       => opa_tb,
            opb       => opb_tb,
            alu_ctrl  => alu_ctrl_tb,
            result    => result_tb,
            zero      => zero_tb,
            carry_out => carry_out_tb,
            overflow  => overflow_tb,
            sign      => sign_tb
        );

    stim: process
    begin
        -- ADD
        opa_tb <= x"0000000B"; opb_tb <= x"00000002"; alu_ctrl_tb <= ALU_ADD;  wait for CLK_PERIOD;
        -- SUB
        opa_tb <= x"00000008"; opb_tb <= x"00000007"; alu_ctrl_tb <= ALU_SUB;  wait for CLK_PERIOD;
        -- AND
        opa_tb <= x"F0F0F0F0"; opb_tb <= x"0FF00FF0"; alu_ctrl_tb <= ALU_AND;  wait for CLK_PERIOD;
        -- OR
        opa_tb <= x"00000003"; opb_tb <= x"00000001"; alu_ctrl_tb <= ALU_OR;   wait for CLK_PERIOD;
        -- XOR
        opa_tb <= x"00000003"; opb_tb <= x"00000001"; alu_ctrl_tb <= ALU_XOR;  wait for CLK_PERIOD;
        -- SLL
        opa_tb <= x"00000001"; opb_tb <= x"00000004"; alu_ctrl_tb <= ALU_SLL;  wait for CLK_PERIOD;
        -- SRL
        opa_tb <= x"80000000"; opb_tb <= x"00000004"; alu_ctrl_tb <= ALU_SRL;  wait for CLK_PERIOD;
        -- SRA
        opa_tb <= x"80000000"; opb_tb <= x"00000004"; alu_ctrl_tb <= ALU_SRA;  wait for CLK_PERIOD;
        -- SLT (signed)
        opa_tb <= x"FFFFFFFF"; opb_tb <= x"00000001"; alu_ctrl_tb <= ALU_SLT;  wait for CLK_PERIOD;
        -- SLTU (unsigned)
        opa_tb <= x"FFFFFFFF"; opb_tb <= x"00000001"; alu_ctrl_tb <= ALU_SLTU; wait for CLK_PERIOD;
        -- SLLI
        opa_tb <= x"00000002"; opb_tb <= x"00000003"; alu_ctrl_tb <= ALU_SLLI; wait for CLK_PERIOD;
        -- SRLI
        opa_tb <= x"00000010"; opb_tb <= x"00000002"; alu_ctrl_tb <= ALU_SRLI; wait for CLK_PERIOD;
        -- SRAI
        opa_tb <= x"FFFFFFF0"; opb_tb <= x"00000002"; alu_ctrl_tb <= ALU_SRAI; wait for CLK_PERIOD;
        -- LUI
        opa_tb <= x"00000000"; opb_tb <= x"00012345"; alu_ctrl_tb <= ALU_LUI;  wait for CLK_PERIOD;
        -- AUIPC (A actúa como PC)
        opa_tb <= x"00001000"; opb_tb <= x"00000001"; alu_ctrl_tb <= ALU_AUIPC;wait for CLK_PERIOD;
        -- NOR
        opa_tb <= x"00000003"; opb_tb <= x"00000001"; alu_ctrl_tb <= ALU_NOR;  wait for CLK_PERIOD;

        wait;
    end process;
end simple;
