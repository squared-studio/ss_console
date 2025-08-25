SHELL := /bin/bash

.PHONY: all
all:
	@rm -rf build
	@mkdir -p build
	@echo "*" > build/.gitignore
	@cd build; xvlog -sv ../verilog_serial_pkg.sv ../file_monitor.sv
	@cd build; xelab file_monitor -s file_monitor
	@cd build; xsim file_monitor -runall
