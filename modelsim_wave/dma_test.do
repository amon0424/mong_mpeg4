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
add wave -noupdate -expand -group DMA -radix hexadecimal -expand -subitemconfig {/testbench/cpu/dma0/ahbmo.hbusreq {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbmo.hlock {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbmo.htrans {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbmo.haddr {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbmo.hwrite {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbmo.hsize {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbmo.hburst {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbmo.hprot {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbmo.hwdata {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbmo.hirq {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbmo.hconfig {-height 15 -radix hexadecimal} /testbench/cpu/dma0/ahbmo.hindex {-height 15 -radix hexadecimal}} /testbench/cpu/dma0/ahbmo
add wave -noupdate -expand -group DMA -radix hexadecimal -subitemconfig {/testbench/cpu/dma0/r.srcaddr {-radix hexadecimal} /testbench/cpu/dma0/r.srcinc {-radix hexadecimal} /testbench/cpu/dma0/r.dstaddr {-radix hexadecimal} /testbench/cpu/dma0/r.dstinc {-radix hexadecimal} /testbench/cpu/dma0/r.len {-radix hexadecimal} /testbench/cpu/dma0/r.enable {-radix hexadecimal} /testbench/cpu/dma0/r.write {-radix hexadecimal} /testbench/cpu/dma0/r.inhibit {-radix hexadecimal} /testbench/cpu/dma0/r.status {-radix hexadecimal} /testbench/cpu/dma0/r.dstate {-radix hexadecimal} /testbench/cpu/dma0/r.data {-radix hexadecimal} /testbench/cpu/dma0/r.cnt {-radix hexadecimal} /testbench/cpu/dma0/r.readCountInRow {-radix hexadecimal} /testbench/cpu/dma0/r.src_stride {-radix hexadecimal} /testbench/cpu/dma0/r.dst_stride {-radix hexadecimal} /testbench/cpu/dma0/r.src_width {-radix hexadecimal} /testbench/cpu/dma0/r.dst_width {-radix hexadecimal} /testbench/cpu/dma0/r.src_mcomp {-radix hexadecimal} /testbench/cpu/dma0/r.rfactor {-radix hexadecimal} /testbench/cpu/dma0/r.mcomp_mode {-radix hexadecimal} /testbench/cpu/dma0/r.beat {-radix hexadecimal} /testbench/cpu/dma0/r.write_valid {-radix hexadecimal} /testbench/cpu/dma0/r.write_addr {-radix hexadecimal}} /testbench/cpu/dma0/r
add wave -noupdate -expand -group DMA -radix hexadecimal -expand -subitemconfig {/testbench/cpu/dma0/r.data(0) {-radix hexadecimal} /testbench/cpu/dma0/r.data(1) {-radix hexadecimal} /testbench/cpu/dma0/r.data(2) {-radix hexadecimal} /testbench/cpu/dma0/r.data(3) {-radix hexadecimal} /testbench/cpu/dma0/r.data(4) {-radix hexadecimal} /testbench/cpu/dma0/r.data(5) {-radix hexadecimal} /testbench/cpu/dma0/r.data(6) {-radix hexadecimal} /testbench/cpu/dma0/r.data(7) {-radix hexadecimal} /testbench/cpu/dma0/r.data(8) {-radix hexadecimal} /testbench/cpu/dma0/r.data(9) {-radix hexadecimal} /testbench/cpu/dma0/r.data(10) {-radix hexadecimal} /testbench/cpu/dma0/r.data(11) {-radix hexadecimal} /testbench/cpu/dma0/r.data(12) {-radix hexadecimal} /testbench/cpu/dma0/r.data(13) {-radix hexadecimal} /testbench/cpu/dma0/r.data(14) {-radix hexadecimal} /testbench/cpu/dma0/r.data(15) {-radix hexadecimal} /testbench/cpu/dma0/r.data(16) {-radix hexadecimal} /testbench/cpu/dma0/r.data(17) {-radix hexadecimal} /testbench/cpu/dma0/r.data(18) {-radix hexadecimal} /testbench/cpu/dma0/r.data(19) {-radix hexadecimal} /testbench/cpu/dma0/r.data(20) {-radix hexadecimal} /testbench/cpu/dma0/r.data(21) {-radix hexadecimal} /testbench/cpu/dma0/r.data(22) {-radix hexadecimal} /testbench/cpu/dma0/r.data(23) {-radix hexadecimal} /testbench/cpu/dma0/r.data(24) {-radix hexadecimal} /testbench/cpu/dma0/r.data(25) {-radix hexadecimal} /testbench/cpu/dma0/r.data(26) {-radix hexadecimal}} /testbench/cpu/dma0/r.data
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/rin
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/dmai
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/dmao
add wave -noupdate -expand -group DMA -radix unsigned /testbench/cpu/dma0/clk
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/rst
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/clk
add wave -noupdate -expand -group MCOMP -color Gold -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi.hsel(4)
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi.haddr
add wave -noupdate -expand -group MCOMP -color Magenta -radix hexadecimal /testbench/cpu/my_mcomp/ahbso.hrdata
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi.hwdata
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi
add wave -noupdate -expand -group MCOMP -radix hexadecimal -expand -subitemconfig {/testbench/cpu/my_mcomp/ahbso.hready {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ahbso.hresp {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ahbso.hrdata {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ahbso.hsplit {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ahbso.hcache {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ahbso.hirq {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ahbso.hconfig {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ahbso.hindex {-height 15 -radix hexadecimal}} /testbench/cpu/my_mcomp/ahbso
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_a
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_b
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_c
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_d
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_r
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/wr_valid
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/addr_wr
add wave -noupdate -expand -group MCOMP /testbench/cpu/my_mcomp/reading
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/CLK1
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/WE1
add wave -noupdate -expand -group {MCOMP RAM} -radix unsigned /testbench/cpu/my_mcomp/ram/Addr1
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_Out1
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/CLK2
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/WE2
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Addr2
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_In2
add wave -noupdate -expand -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_Out2
add wave -noupdate -radix hexadecimal /testbench/cpu/my_mcomp/ram/DataMEM
add wave -noupdate -expand -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/HCLK
add wave -noupdate -expand -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/HRESETn
add wave -noupdate -expand -group DMA2AHB -radix hexadecimal -expand -subitemconfig {/testbench/cpu/dma0/mst/DMAIn.Reset {-height 15 -radix hexadecimal} /testbench/cpu/dma0/mst/DMAIn.Address {-height 15 -radix hexadecimal} /testbench/cpu/dma0/mst/DMAIn.Data {-height 15 -radix hexadecimal} /testbench/cpu/dma0/mst/DMAIn.Request {-height 15 -radix hexadecimal} /testbench/cpu/dma0/mst/DMAIn.Burst {-height 15 -radix hexadecimal} /testbench/cpu/dma0/mst/DMAIn.Beat {-height 15 -radix hexadecimal} /testbench/cpu/dma0/mst/DMAIn.Size {-height 15 -radix hexadecimal} /testbench/cpu/dma0/mst/DMAIn.Store {-height 15 -radix hexadecimal} /testbench/cpu/dma0/mst/DMAIn.Lock {-height 15 -radix hexadecimal}} /testbench/cpu/dma0/mst/DMAIn
add wave -noupdate -expand -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/DMAOut
add wave -noupdate -expand -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/AHBIn
add wave -noupdate -expand -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/AHBOut
add wave -noupdate -expand -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/Address
add wave -noupdate -expand -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/AddressSave
add wave -noupdate -expand -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/ActivePhase
add wave -noupdate -expand -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/AddressPhase
add wave -noupdate -expand -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/DataPhase
add wave -noupdate -expand -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/ReDataPhase
add wave -noupdate -expand -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/ReAddrPhase
add wave -noupdate -expand -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/IdlePhase
add wave -noupdate -expand -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/EarlyPhase
add wave -noupdate -expand -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/BoundaryPhase
add wave -noupdate -expand -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/SingleAcc
add wave -noupdate -expand -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/WriteAcc
add wave -noupdate -expand -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/DelDataPhase
add wave -noupdate -expand -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/DelAddrPhase
add wave -noupdate -expand -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/AHBInHGRANTx
add wave -noupdate -group view1 -radix unsigned /testbench/cpu/dma0/clk
add wave -noupdate -group view1 -radix unsigned /testbench/cpu/dma0/mst/DMAIn.Request
add wave -noupdate -group view1 -radix hexadecimal /testbench/cpu/dma0/mst/DMAIn.Address
add wave -noupdate -group view1 -radix hexadecimal /testbench/cpu/dma0/mst/DMAIn.Burst
add wave -noupdate -group view1 -radix unsigned /testbench/cpu/dma0/mst/AHBOut.hburst
add wave -noupdate -group view1 -radix unsigned /testbench/cpu/dma0/mst/AHBOut.htrans
add wave -noupdate -group view1 -radix hexadecimal /testbench/cpu/dma0/mst/AHBOut.haddr
add wave -noupdate -group view1 -radix unsigned /testbench/cpu/dma0/mst/AHBIn.hready
add wave -noupdate -group view1 -radix hexadecimal /testbench/cpu/dma0/mst/AHBIn.hrdata
add wave -noupdate -group view1 -radix hexadecimal /testbench/cpu/dma0/rin.beat
add wave -noupdate -group view1 -radix hexadecimal /testbench/cpu/dma0/r.beat
add wave -noupdate -group view1 /testbench/cpu/dma0/mst/DMAOut.Ready
add wave -noupdate -group view1 -radix hexadecimal /testbench/cpu/dma0/mst/DMAOut.Data
add wave -noupdate -group view1 -radix hexadecimal /testbench/cpu/dma0/r.data
add wave -noupdate -group view2 -radix hexadecimal /testbench/cpu/dma0/r.write
add wave -noupdate -group view2 -radix unsigned /testbench/cpu/dma0/mst/DMAIn.Request
add wave -noupdate -group view2 -radix hexadecimal /testbench/cpu/dma0/mst/DMAIn.Address
add wave -noupdate -group view2 -radix hexadecimal /testbench/cpu/dma0/mst/DMAIn.Burst
add wave -noupdate -group view2 -radix unsigned /testbench/cpu/dma0/mst/AHBOut.hburst
add wave -noupdate -group view2 -radix unsigned /testbench/cpu/dma0/mst/AHBOut.htrans
add wave -noupdate -group view2 -radix hexadecimal /testbench/cpu/dma0/mst/AHBOut.haddr
add wave -noupdate -group view2 -radix unsigned /testbench/cpu/dma0/mst/AHBIn.hready
add wave -noupdate -group view2 -radix hexadecimal /testbench/cpu/dma0/mst/DMAOut.Ready
add wave -noupdate -group view2 -radix unsigned /testbench/cpu/dma0/r.cnt
add wave -noupdate -group view2 -radix hexadecimal /testbench/cpu/dma0/mst/AHBOut.hwdata
add wave -noupdate -group view2 -radix unsigned /testbench/cpu/my_mcomp/ram/Addr1
add wave -noupdate -group view2 -radix hexadecimal /testbench/cpu/my_mcomp/ram/WE1
add wave -noupdate -group view2 -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_In1
add wave -noupdate -group view2 -radix hexadecimal /testbench/cpu/my_mcomp/reg_r
add wave -noupdate -group view2 -radix hexadecimal /testbench/cpu/my_mcomp/ram/DataMEM
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {226770366 ps} 1} {{Cursor 2} {234171751 ps} 1} {{Cursor 3} {233922897 ps} 0}
configure wave -namecolwidth 277
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
WaveRestoreZoom {233859576 ps} {234261550 ps}
bookmark add wave {stage 1 dma enable } {{221329464 ps} {221712536 ps}} 0
bookmark add wave {stage1 dma to mcomp} {{225204464 ps} {225587536 ps}} 135
bookmark add wave {stage1 ram to dma} {{221712535 ps} {222095607 ps}} 0
bookmark add wave {stage2 mcomp to dma} {{228821569 ps} {229204641 ps}} 28
