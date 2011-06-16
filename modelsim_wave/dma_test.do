onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/rst
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/clk
add wave -noupdate -expand -group DMA -color Gold -radix hexadecimal /testbench/cpu/dma0/ahbsi.hsel(5)
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbsi.haddr
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbsi
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbso
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbmi
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbmo
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/valid
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/temp_addr
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/r
add wave -noupdate -expand -group DMA -radix hexadecimal -expand -subitemconfig {/testbench/cpu/dma0/rin.srcaddr {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.srcinc {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.dstaddr {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.dstinc {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.len {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.enable {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.write {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.inhibit {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.status {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.dstate {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data {-height 15 -radix hexadecimal -expand} /testbench/cpu/dma0/rin.data(0) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(1) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(2) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(3) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(4) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(5) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(6) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(7) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(8) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(9) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(10) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(11) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(12) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(13) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(14) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(15) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(16) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(17) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(18) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(19) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(20) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(21) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(22) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(23) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(24) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(25) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(26) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(27) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(28) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(29) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(30) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data(31) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.cnt {-height 15 -radix hexadecimal}} /testbench/cpu/dma0/rin
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/dmai
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/dmao
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/src_addr
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/dst_addr
add wave -noupdate -expand -group DMA -radix unsigned /testbench/cpu/dma0/stride
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/rfactor
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/action
add wave -noupdate -expand -group DMA -radix unsigned /testbench/cpu/dma0/width
add wave -noupdate -expand -group DMA -radix unsigned /testbench/cpu/dma0/readCountInRow
add wave -noupdate -expand -group Master -radix hexadecimal /testbench/cpu/dma0/ahbif/rst
add wave -noupdate -expand -group Master -radix hexadecimal /testbench/cpu/dma0/ahbif/clk
add wave -noupdate -expand -group Master -radix hexadecimal /testbench/cpu/dma0/ahbif/dmai
add wave -noupdate -expand -group Master -radix hexadecimal /testbench/cpu/dma0/ahbif/dmao
add wave -noupdate -expand -group Master -radix hexadecimal /testbench/cpu/dma0/ahbif/ahbi
add wave -noupdate -expand -group Master -radix hexadecimal /testbench/cpu/dma0/ahbif/ahbo
add wave -noupdate -expand -group Master -radix hexadecimal /testbench/cpu/dma0/ahbif/r
add wave -noupdate -expand -group Master -radix hexadecimal /testbench/cpu/dma0/ahbif/rin
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/rst
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/clk
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ahbso
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_a
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_b
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_c
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_d
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_r
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/wr_valid
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/addr_wr
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ram_addr1
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ram_addr2
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ram_we1
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ram_we2
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ram_di1
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ram_di2
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ram_do1
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ram_do2
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/CLK1
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/WE1
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Addr1
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_In1
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_Out1
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/CLK2
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/WE2
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Addr2
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_In2
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_Out2
add wave -noupdate -radix hexadecimal -expand -subitemconfig {/testbench/cpu/my_mcomp/ram/DataMEM(0) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(1) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(2) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(3) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(4) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(5) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(6) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(7) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(8) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(9) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(10) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(11) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(12) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(13) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(14) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(15) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(16) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(17) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(18) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(19) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(20) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(21) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(22) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(23) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(24) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(25) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(26) {-height 15 -radix hexadecimal}} /testbench/cpu/my_mcomp/ram/DataMEM
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {218070097 ps} 0}
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
WaveRestoreZoom {216122106 ps} {216505178 ps}
bookmark add wave {bram write} {{217975420 ps} {218358492 ps}} 86
bookmark add wave {dma read} {{216979464 ps} {217362536 ps}} 12
