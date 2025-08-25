module file_monitor;

  import verilog_serial_pkg::*;

  bit clk;

  initial begin

    serial_begin("com0");

    forever begin
      clk = !clk;
      #100ns;
    end

    $finish;

  end

endmodule
