library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu1 is
    generic (
        data_width : integer := 32
    );
    port (
        opa       : in  std_logic_vector(data_width-1 downto 0);
        opb       : in  std_logic_vector(data_width-1 downto 0);
        alu_ctrl  : in  std_logic_vector(3 downto 0);

        result    : out std_logic_vector(data_width-1 downto 0);
        zero      : out std_logic;
        carry_out : out std_logic;
        overflow  : out std_logic;
        sign      : out std_logic
    );
end alu1;

architecture rtl of alu1 is
    signal a_u, b_u : unsigned(data_width-1 downto 0);
    signal a_s, b_s : signed(data_width-1 downto 0);

    signal add_ext  : unsigned(data_width downto 0);
    signal sub_ext  : unsigned(data_width downto 0);

    signal r        : std_logic_vector(data_width-1 downto 0);
    signal c        : std_logic;
    signal v        : std_logic;
begin
    a_u <= unsigned(opa);
    b_u <= unsigned(opb);
    a_s <= signed(opa);
    b_s <= signed(opb);

    process(opa, opb, alu_ctrl, a_u, b_u, a_s, b_s)
        variable shamt : integer range 0 to 31;
        variable tmp_u   : unsigned(data_width-1 downto 0);
        variable tmp_s   : signed(data_width-1 downto 0);
        variable b_shl_u : unsigned(data_width-1 downto 0);
    begin
        shamt := to_integer(unsigned(opb(4 downto 0)));

        -- defaults
        r <= (others => '0');
        c <= '0';
        v <= '0';

        case alu_ctrl is
            when "0000" =>  -- ADD
                add_ext <= ('0' & a_u) + ('0' & b_u);
                r <= std_logic_vector(add_ext(data_width-1 downto 0));
                c <= add_ext(data_width);
                -- overflow signed add: same sign operands, different sign result
                v <= (not (opa(data_width-1) xor opb(data_width-1))) and (opa(data_width-1) xor add_ext(data_width-1));

            when "0001" =>  -- SUB
                sub_ext <= ('0' & a_u) - ('0' & b_u);
                r <= std_logic_vector(sub_ext(data_width-1 downto 0));
                c <= sub_ext(data_width); -- carry/borrow convention per unsigned subtraction
                -- overflow signed sub: different sign operands, result sign differs from A
                v <= (opa(data_width-1) xor opb(data_width-1)) and (opa(data_width-1) xor sub_ext(data_width-1));

            when "0010" =>  -- AND
                r <= opa and opb;

            when "0011" =>  -- OR
                r <= opa or opb;

            when "0100" =>  -- XOR
                r <= opa xor opb;

            when "0101" =>  -- SLL
                tmp_u := shift_left(a_u, shamt);
                r <= std_logic_vector(tmp_u);

            when "0110" =>  -- SRL
                tmp_u := shift_right(a_u, shamt);
                r <= std_logic_vector(tmp_u);

            when "0111" =>  -- SRA
                tmp_s := shift_right(a_s, shamt);
                r <= std_logic_vector(tmp_s);

            when "1000" =>  -- SLT (signed)
                if a_s < b_s then
                    r <= (0 => '1', others => '0');
                else
                    r <= (others => '0');
                end if;

            when "1001" =>  -- SLTU (unsigned)
                if a_u < b_u then
                    r <= (0 => '1', others => '0');
                else
                    r <= (others => '0');
                end if;

            when "1010" =>  -- SLLI (usar opb[4:0] como inmediato)
                tmp_u := shift_left(a_u, shamt);
                r <= std_logic_vector(tmp_u);

            when "1011" =>  -- SRLI
                tmp_u := shift_right(a_u, shamt);
                r <= std_logic_vector(tmp_u);

            when "1100" =>  -- SRAI
                tmp_s := shift_right(a_s, shamt);
                r <= std_logic_vector(tmp_s);

            when "1101" =>  -- LUI : B << 12
                tmp_u := shift_left(b_u, 12);
                r <= std_logic_vector(tmp_u);

            when "1110" =>  -- AUIPC simplificado: A(PC) + (B << 12)
                b_shl_u := shift_left(b_u, 12);
                add_ext <= ('0' & a_u) + ('0' & b_shl_u);
                r <= std_logic_vector(add_ext(data_width-1 downto 0));
                c <= add_ext(data_width);
                v <= (not (opa(data_width-1) xor b_shl_u(data_width-1))) and
                     (opa(data_width-1) xor add_ext(data_width-1));

            when "1111" =>  -- NOR
                r <= opa nor opb;

            when others =>
                r <= (others => '0');
                c <= '0';
                v <= '0';
        end case;
    end process;

    result    <= r;
    zero      <= '1' when r = (r'range => '0') else '0';
    sign      <= r(data_width-1);
    carry_out <= c;
    overflow  <= v;
end rtl;
