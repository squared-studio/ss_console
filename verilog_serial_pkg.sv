package verilog_serial_pkg;

  function automatic void build_script();
    int file_handle;
    file_handle = $fopen("run_console.sh", "w");
    // verilog_format: off
    if (file_handle) begin
      $fwrite(file_handle, "#!/bin/bash\n");
      $fwrite(file_handle, "\n");
      $fwrite(file_handle, "cleanup() {\n");
      $fwrite(file_handle, "  rm -f \"$input_file\" \"$output_file\"\n");
      $fwrite(file_handle, "  kill $TAIL_PID 2>/dev/null\n");
      $fwrite(file_handle, "}\n");
      $fwrite(file_handle, "\n");
      $fwrite(file_handle, "while getopts \"n:t:p:\" opt; do\n");
      $fwrite(file_handle, "  case $opt in\n");
      $fwrite(file_handle, "    p) port=$OPTARG ;;\n");
      $fwrite(file_handle, "    *) echo \"Invalid option\"; exit 1 ;;\n");
      $fwrite(file_handle, "  esac\n");
      $fwrite(file_handle, "done\n");
      $fwrite(file_handle, "\n");
      $fwrite(file_handle, "if [ -z \"$port\" ]; then\n");
      $fwrite(file_handle, "  echo \"Error: -p is a required argument.\"\n");
      $fwrite(file_handle, "  exit 1\n");
      $fwrite(file_handle, "fi\n");
      $fwrite(file_handle, "\n");
      $fwrite(file_handle, "input_file=\"${port}.i.ss_console\"\n");
      $fwrite(file_handle, "output_file=\"${port}.o.ss_console\"\n");
      $fwrite(file_handle, "\n");
      $fwrite(file_handle, "touch \"$input_file\" \"$output_file\"\n");
      $fwrite(file_handle, "\n");
      $fwrite(file_handle, "echo -e \"\\033[1;37m                                    _         _             _ _       \\033[0m\"\n");
      $fwrite(file_handle, "echo -e \"\\033[1;37m ___  __ _ _   _  __ _ _ __ ___  __| |    ___| |_ _   _  __| (_) ___  \\033[0m\"\n");
      $fwrite(file_handle, "echo -e \"\\033[1;37m/ __|/ _' | | | |/ _' | '__/ _ \\/ _' |___/ __| __| | | |/ _' | |/ _ \\ \\033[0m\"\n");
      $fwrite(file_handle, "echo -e \"\\033[1;36m\\__ \\ (_| | |_| | (_| | | |  __/ (_| |___\\__ \\ |_| |_| | (_| | | (_) |\\033[0m\"\n");
      $fwrite(file_handle, "echo -e \"\\033[1;36m|___/\\__, |\\__,_|\\__,_|_|  \\___|\\__,_|   |___/\\__|\\__,_|\\__,_|_|\\___/ \\033[0m\"\n");
      $fwrite(file_handle, "echo -e \"\\033[1;36m        |_|                                                2023-$(date +%%Y)\\033[0m\\n\"\n");
      $fwrite(file_handle, "\n");
      $fwrite(file_handle, "echo -e \"Monitoring: ${input_file} ${output_file}\\n\"\n");
      $fwrite(file_handle, "\n");
      $fwrite(file_handle, "sleep 2\n");
      $fwrite(file_handle, "\n");
      $fwrite(file_handle, "clear\n");
      $fwrite(file_handle, "\n");
      $fwrite(file_handle, "trap 'cleanup; kill $TAIL_PID; cleanup; exit' SIGINT\n");
      $fwrite(file_handle, "\n");
      $fwrite(file_handle, "tail -f \"$output_file\" &\n");
      $fwrite(file_handle, "\n");
      $fwrite(file_handle, "TAIL_PID=$!\n");
      $fwrite(file_handle, "\n");
      $fwrite(file_handle, "while true\n");
      $fwrite(file_handle, "do\n");
      $fwrite(file_handle, "  read -r user_input\n");
      $fwrite(file_handle, "  echo \"$user_input\" >> \"$input_file\"\n");
      $fwrite(file_handle, "done\n");
      $fwrite(file_handle, "\n");
      $fclose(file_handle);
      // verilog_format: on
    end
  endfunction

  mailbox #(bit [7:0]) char_mbx = new();  // TODO
  // TODO
  task automatic input_file(input string file_name);
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
            char_mbx.put(character);  // TODO
            last_char_pos = curr_char_pos;
          end
        end
        $fclose(file_handle);
        #1ns;
      end else begin
        break;
      end
      #1ns;
    end
  endtask

  task automatic serial_begin(input string port_name);
    int fh;
    fh = $fopen($sformatf("%s.i.ss_console", port_name), "w");
    $fclose(fh);
    build_script();
    fork
      input_file($sformatf("%s.i.ss_console", port_name));
      begin  // TODO
        int       fh;  // TODO
        bit [7:0] char;  // TODO
        forever begin  // TODO
          fh = $fopen($sformatf("%s.o.ss_console", port_name), "a");  // TODO
          char_mbx.get(char);  // TODO
          $fwrite(fh, "%c", char + 1);  // TODO
          $fclose(fh);  // TODO
        end  // TODO
      end  // TODO
      $system($sformatf("start \"Git Bash\" \"bash.exe\" --login -c './run_console.sh -p %s'",
                        port_name));
    join_none
  endtask

endpackage : verilog_serial_pkg
