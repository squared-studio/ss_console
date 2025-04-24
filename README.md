# ss_console

## Usage

The `run_console.sh` script is used to monitor input and output files for a specific port. Follow the steps below to use it:

1. **Run the script**:
   ```bash
   ./run_console.sh -p <port_number>
   ```
   Replace `<port_number>` with the desired port number.

2. **Interact with the console**:
   - Type your input in the terminal, and it will be written to the input file (`/tmp/ss_console/<port_number>.i.ss_console`).
   - The output file (`/tmp/ss_console/<port_number>.o.ss_console`) will be monitored and displayed in real-time.

3. **Stop the script**:
   - Press `Ctrl+C` to terminate the script. This will clean up the temporary files and stop monitoring.

### Options

- `-p <port_number>`: (Required) Specify the port number for the session.

### Example

```bash
./run_console.sh -p 8080
```
This will create and monitor the following files:
- Input file: `/tmp/ss_console/8080.i.ss_console`
- Output file: `/tmp/ss_console/8080.o.ss_console`
