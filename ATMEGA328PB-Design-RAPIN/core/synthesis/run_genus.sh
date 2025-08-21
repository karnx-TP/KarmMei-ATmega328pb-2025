rm -fr result/
rm -fr outputs/
rm -fr log/
mkdir -p results/
mkdir -p reports/
mkdir -p log/
genus -abort_on_error -f genus_script.tcl -log "log/genus_run.log"