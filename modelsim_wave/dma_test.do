onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/rst
add wave -noupdate -expand -group DMA -color Gold -radix hexadecimal /testbench/cpu/dma0/ahbsi.hsel(5)
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbsi.haddr
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbsi.hwdata
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbso.hrdata
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbsi.hwrite
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbsi
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbso
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbmi
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbmo
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/r
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/r.data
add wave -noupdate -expand -group DMA -radix hexadecimal -expand -subitemconfig {/testbench/cpu/dma0/rin.srcaddr {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.srcinc {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.dstaddr {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.dstinc {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.len {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.enable {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.write {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.inhibit {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.status {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.dstate {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.data {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.cnt {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.readCountInRow {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.src_stride {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.dst_stride {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.src_width {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.dst_width {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.write_rfactor {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.write_action {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.src_mcomp {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.rfactor {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.beat {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.write_valid {-height 15 -radix hexadecimal} /testbench/cpu/dma0/rin.write_addr {-height 15 -radix hexadecimal}} /testbench/cpu/dma0/rin
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/dmai
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/dmao
add wave -noupdate -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/rst
add wave -noupdate -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/clk
add wave -noupdate -group MCOMP -color Gold -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi.hsel(4)
add wave -noupdate -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi.haddr
add wave -noupdate -group MCOMP -color Magenta -radix hexadecimal /testbench/cpu/my_mcomp/ahbso.hrdata
add wave -noupdate -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi.hwdata
add wave -noupdate -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi
add wave -noupdate -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ahbso
add wave -noupdate -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_a
add wave -noupdate -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_b
add wave -noupdate -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_c
add wave -noupdate -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_d
add wave -noupdate -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_r
add wave -noupdate -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/wr_valid
add wave -noupdate -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/addr_wr
add wave -noupdate -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/CLK1
add wave -noupdate -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/WE1
add wave -noupdate -group {MCOMP RAM} -radix unsigned /testbench/cpu/my_mcomp/ram/Addr1
add wave -noupdate -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_In1
add wave -noupdate -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_Out1
add wave -noupdate -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/CLK2
add wave -noupdate -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/WE2
add wave -noupdate -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Addr2
add wave -noupdate -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_In2
add wave -noupdate -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_Out2
add wave -noupdate -radix hexadecimal /testbench/cpu/my_mcomp/ram/DataMEM
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/HCLK
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/HRESETn
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/DMAIn
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/DMAOut
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/AHBIn
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/AHBOut
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/Address
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/AddressSave
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/ActivePhase
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/AddressPhase
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/DataPhase
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/ReDataPhase
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/ReAddrPhase
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/IdlePhase
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/EarlyPhase
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/BoundaryPhase
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/SingleAcc
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/WriteAcc
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/DelDataPhase
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/DelAddrPhase
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/AHBInHGRANTx
add wave -noupdate -expand -group view1 -radix unsigned /testbench/cpu/dma0/clk
add wave -noupdate -expand -group view1 -radix unsigned /testbench/cpu/dma0/mst/DMAIn.Request
add wave -noupdate -expand -group view1 -radix hexadecimal /testbench/cpu/dma0/mst/DMAIn.Address
add wave -noupdate -expand -group view1 -radix hexadecimal /testbench/cpu/dma0/mst/DMAIn.Burst
add wave -noupdate -expand -group view1 -radix unsigned /testbench/cpu/dma0/mst/AHBOut.hburst
add wave -noupdate -expand -group view1 -radix unsigned /testbench/cpu/dma0/mst/AHBOut.htrans
add wave -noupdate -expand -group view1 -radix hexadecimal /testbench/cpu/dma0/mst/AHBOut.haddr
add wave -noupdate -expand -group view1 -radix unsigned /testbench/cpu/dma0/mst/AHBIn.hready
add wave -noupdate -expand -group view1 -radix hexadecimal /testbench/cpu/dma0/mst/AHBIn.hrdata
add wave -noupdate -expand -group view1 -radix hexadecimal /testbench/cpu/dma0/r.beat
add wave -noupdate -expand -group view1 /testbench/cpu/dma0/mst/DMAOut.Ready
add wave -noupdate -expand -group view1 -radix hexadecimal /testbench/cpu/dma0/mst/DMAOut.Data
add wave -noupdate -expand -group view1 -radix hexadecimal -expand -subitemconfig {/testbench/cpu/dma0/r.data(0) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(1) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(2) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(3) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(4) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(5) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(6) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(7) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(8) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(9) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(10) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(11) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(12) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(13) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(14) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(15) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(16) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(17) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(18) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(19) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(20) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(21) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(22) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(23) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(24) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(25) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(26) {-height 15 -radix hexadecimal}} /testbench/cpu/dma0/r.data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {226045924 ps} 1} {{Cursor 2} {224245581 ps} 0}
configure wave -namecolwidth 286
configure wave -valuecolwidth 116
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
WaveRestoreZoom {224123643 ps} {224539534 ps}
bookmark add wave {stage 1 dma enable } {{221329464 ps} {221712536 ps}} 0
bookmark add wave {stage1 dma to mcomp} {{225204464 ps} {225587536 ps}} 135
bookmark add wave {stage1 ram to dma} {{221712535 ps} {222095607 ps}} 0
bookmark add wave {stage2 mcomp to dma} {{228821569 ps} {229204641 ps}} 28
