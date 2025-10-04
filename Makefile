SIM=iverilog
BUILD=build
SV_SRC=tb/top_tb.sv rtl/alu.sv

all: sim

sim:
	mkdir -p $(BUILD)
	$(SIM) -g2012 -o $(BUILD)/simv $(SV_SRC)
	vvp $(BUILD)/simv | tee $(BUILD)/run.log

waves:
	gtkwave $(BUILD)/alu.vcd &

clean:
	rm -rf $(BUILD)
