library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu1_0 is
    Port (
        op_a     : in  STD_LOGIC_VECTOR(3 downto 0);
        op_b     : in  STD_LOGIC_VECTOR(3 downto 0);
        alu_ctrl : in  STD_LOGIC_VECTOR(3 downto 0);
        result   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end alu1_0;

architecture Behavioral of alu1_0 is
begin
    process(op_a, op_b, alu_ctrl)
    begin
        case alu_ctrl is
            when "0000" =>  -- ADD
                result <= std_logic_vector(unsigned(op_a) + unsigned(op_b));
            when "0001" =>  -- SUB
                result <= std_logic_vector(unsigned(op_a) - unsigned(op_b));
            when "0010" =>  -- AND
                result <= op_a and op_b;
            when "0011" =>  -- OR
                result <= op_a or op_b;
            when "0100" =>  -- XOR
                result <= op_a xor op_b;
            when "0101" =>  -- NOT A
                result <= not op_a;
            when "0110" =>  -- Shift left A
                result <= std_logic_vector(shift_left(unsigned(op_a), 1));
            when "0111" =>  -- Shift right A
                result <= std_logic_vector(shift_right(unsigned(op_a), 1));
            when others =>
                result <= (others => '0');
        end case;
    end process;
end Behavioral;
