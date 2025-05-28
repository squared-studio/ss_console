module file_monitor;

  initial begin
    fork
      monitor_file("input_log.txt");
    join_none
  end

  task automatic monitor_file(input string file_name);
    longint last_char_pos;
    longint curr_char_pos;
    int file_handle;
    logic [7:0] character;
    last_char_pos = 0;
    while (1) begin
      file_handle   = $fopen(file_name, "r");
      curr_char_pos = 0;
      if (file_handle) begin
        while (1) begin
          character = $fgetc(file_handle);
          if (character == 255) begin
            break;
          end
          curr_char_pos++;
          if (curr_char_pos > last_char_pos) begin
            $write("%c", character);
            last_char_pos = curr_char_pos;
          end
        end
        $fclose(file_handle);
        #10;
      end
    end
  endtask

endmodule
