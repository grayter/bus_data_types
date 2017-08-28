library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library types;

-- This package contains the descriptions of several common bus formats that
-- are used across multiple cores.

package bus_data_types_pkg is
  type AVALON_DATA_STREAM_PACKET_t is record
    start          : std_ulogic;
    stop           : std_ulogic;
    valid          : std_ulogic;
    data           : std_ulogic_vector;
    transaction_id : std_ulogic_vector;
  end record AVALON_DATA_STREAM_PACKET_t;

  type ACK_t is record
    ack : std_ulogic;
  end record ACK_t;

  type AVALON_PACKET_ARRAY_t is array(natural range <>) of AVALON_DATA_STREAM_PACKET_t;
  type ACK_ARRAY_t is array(natural range <>) of ACK_t;
  
  type std_ulogic_vector_array is array(natural range <>) of std_ulogic_vector;

  function packet_to_text(packet : AVALON_DATA_STREAM_PACKET_t) return string;
  function packet_equality(a : AVALON_DATA_STREAM_PACKET_t;
                           b : AVALON_DATA_STREAM_PACKET_t) return boolean;
end package;

package body bus_data_types_pkg is
  function packet_to_text(packet : AVALON_DATA_STREAM_PACKET_t) return string is
    constant result_length : natural := 34 + 1 + 1 + 1 + (packet.transaction_id'length/4) + (packet.data'length/4);
    variable result : string(1 to result_length);
  begin
    result := "Start: " & to_string(packet.start)           & " " &
              "Stop: "  & to_string(packet.stop)            & " " &
              "Valid: " & to_string(packet.valid)           & " " &
              "ID: "    & to_hstring(packet.transaction_id) & " " &
              "Data: "  & to_hstring(packet.data);
    return result;
  end function;

  function packet_equality(a : AVALON_DATA_STREAM_PACKET_t;
                           b : AVALON_DATA_STREAM_PACKET_t) return boolean is
    variable result : boolean := true;
  begin
    result := result and (a.start = b.start);
    result := result and (a.stop = b.stop);
    result := result and (a.valid = b.valid);
    result := result and (a.data = b.data);
    result := result and (a.transaction_id = b.transaction_id);
    return result;
  end function;
end package body;
