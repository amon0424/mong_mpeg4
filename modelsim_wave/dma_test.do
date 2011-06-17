onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/rst
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/clk
add wave -noupdate -expand -group DMA -color Gold -radix hexadecimal /testbench/cpu/dma0/ahbsi.hsel(5)
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbsi.haddr
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbsi
add wave -noupdate -expand -group DMA -radix hexadecimal -subitemconfig {/testbench/cpu/dma0/ahbso.hready {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hresp {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(31) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(30) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(29) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(28) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(27) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(26) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(25) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(24) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(23) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(22) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(21) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(20) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(19) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(18) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(17) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(16) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(15) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(14) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(13) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(12) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(11) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(10) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(9) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(8) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(7) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(6) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(5) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(4) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(3) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(2) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(1) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hrdata(0) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hsplit {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hcache {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hirq {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hconfig {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbso.hindex {-height 15 -radix hexadecimal}} /testbench/cpu/dma0/ahbso
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbmi
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbmo
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/valid
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/temp_addr
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/r.data
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/r
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/r.data
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/rin
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/dmai
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/dmao
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/src_addr
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/dst_addr
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/rfactor
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/action
add wave -noupdate -expand -group Master -radix hexadecimal /testbench/cpu/dma0/ahbif/rst
add wave -noupdate -expand -group Master -radix hexadecimal /testbench/cpu/dma0/ahbif/clk
add wave -noupdate -expand -group Master -radix hexadecimal -subitemconfig {/testbench/cpu/dma0/ahbif/dmai.address {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/dmai.wdata {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/dmai.start {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/dmai.burst {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/dmai.write {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/dmai.busy {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/dmai.irq {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/dmai.size {-height 15 -radix hexadecimal}} /testbench/cpu/dma0/ahbif/dmai
add wave -noupdate -expand -group Master -radix hexadecimal /testbench/cpu/dma0/ahbif/dmao
add wave -noupdate -expand -group Master -radix hexadecimal -subitemconfig {/testbench/cpu/dma0/ahbif/ahbi.hgrant {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/ahbi.hready {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/ahbi.hresp {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/ahbi.hrdata {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/ahbi.hcache {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/ahbi.hirq {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/ahbi.testen {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/ahbi.testrst {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/ahbi.scanen {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/ahbi.testoen {-height 15 -radix hexadecimal}} /testbench/cpu/dma0/ahbif/ahbi
add wave -noupdate -expand -group Master -radix hexadecimal -expand -subitemconfig {/testbench/cpu/dma0/ahbif/ahbo.hbusreq {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/ahbo.hlock {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/ahbo.htrans {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/ahbo.haddr {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/ahbo.hwrite {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/ahbo.hsize {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/ahbo.hburst {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/ahbo.hprot {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/ahbo.hwdata {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/ahbo.hirq {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/ahbo.hconfig {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/ahbo.hindex {-height 15 -radix hexadecimal}} /testbench/cpu/dma0/ahbif/ahbo
add wave -noupdate -expand -group Master -radix hexadecimal -expand -subitemconfig {/testbench/cpu/dma0/ahbif/r.start {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/r.retry {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/r.grant {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbif/r.active {-height 15 -radix hexadecimal}} /testbench/cpu/dma0/ahbif/r
add wave -noupdate -expand -group Master -radix hexadecimal /testbench/cpu/dma0/ahbif/rin
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/rst
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/clk
add wave -noupdate -expand -group MCOMP -color Gold -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi.hsel(4)
add wave -noupdate -expand -group MCOMP -color Magenta -radix hexadecimal /testbench/cpu/my_mcomp/ahbso.hrdata
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi
add wave -noupdate -expand -group MCOMP -radix hexadecimal -subitemconfig {/testbench/cpu/my_mcomp/ahbso.hready {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbso.hresp {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbso.hrdata {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbso.hsplit {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbso.hcache {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbso.hirq {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbso.hconfig {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbso.hindex {-radix hexadecimal}} /testbench/cpu/my_mcomp/ahbso
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_a
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_b
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_c
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_d
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_r
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/wr_valid
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/addr_wr
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/CLK1
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/WE1
add wave -noupdate -expand -group {MCOMP RAM} -radix unsigned /testbench/cpu/my_mcomp/ram/Addr1
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_In1
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_Out1
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/CLK2
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/WE2
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Addr2
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_In2
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_Out2
add wave -noupdate -radix hexadecimal -expand -subitemconfig {/testbench/cpu/my_mcomp/ram/DataMEM(0) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(1) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(2) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(3) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(4) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(5) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(6) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(7) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(8) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(9) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(10) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(11) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(12) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(13) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(14) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(15) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(16) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(17) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(18) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(19) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(20) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(21) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(22) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(23) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(24) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(25) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(26) {-height 15 -radix hexadecimal}} /testbench/cpu/my_mcomp/ram/DataMEM
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {224946000 ps} 0}
configure wave -namecolwidth 286
configure wave -valuecolwidth 232
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 25
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {224584300 ps} {224967372 ps}
bookmark add wave {bram write} {{221645184 ps} {222028256 ps}} 46
bookmark add wave {dma enable} {{216604464 ps} {216987536 ps}} 0
bookmark add wave {dma read} {{216979464 ps} {217362536 ps}} 12
