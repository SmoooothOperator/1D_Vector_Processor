# --- Variables ---
# Tool executable names
VLOGAN = vlogan
VCS    = vcs
SIMV   = ./simv
VERDI  = verdi

# Flags
VLOGAN_FLAGS = -sverilog -kdb -lca -full64 -l vlogan.log
VCS_FLAGS    = -full64 -debug_access+all -kdb -lca -timescale=1ns/1ps -l elab.log
SIM_FLAGS    = -l sim.log

# Project specific
TOP_MODULE = tb_fifo
FILE_LIST  = fifo_filelist.f

# --- Targets ---

# Default target
all: analyze elaborate sim

# Step 1: Analysis
analyze:
	$(VLOGAN) $(VLOGAN_FLAGS) -f $(FILE_LIST)

# Step 2: Elaboration
elaborate:
	$(VCS) $(VCS_FLAGS) $(TOP_MODULE)

# Step 3: Simulation
sim:
	$(SIMV) $(SIM_FLAGS)

# Shortcut to open Verdi
verdi:
	$(VERDI) -dbdir ./simv.daidir &

# Clean up simulation artifacts
clean:
	rm -rf csrc simv* *.log ucli.key vc_hdrs.h *.fsdb verdiLog novas.*