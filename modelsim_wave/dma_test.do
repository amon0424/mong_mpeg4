onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group DMA -radix hexadecimal /testbench/cpu/dma0/rst
add wave -noupdate -group DMA -color Gold -radix hexadecimal /testbench/cpu/dma0/ahbsi.hsel(5)
add wave -noupdate -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbsi.haddr
add wave -noupdate -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbsi.hwdata
add wave -noupdate -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbso.hrdata
add wave -noupdate -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbsi.hwrite
add wave -noupdate -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbsi
add wave -noupdate -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbso
add wave -noupdate -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbmi
add wave -noupdate -group DMA -radix hexadecimal /testbench/cpu/dma0/ahbmo
add wave -noupdate -group DMA -radix hexadecimal -expand -subitemconfig {/testbench/cpu/dma0/r.srcaddr {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.srcinc {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.dstaddr {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.dstinc {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.len {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.enable {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.write {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.inhibit {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.status {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.dstate {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data {-height 15 -radix hexadecimal -expand} /testbench/cpu/dma0/r.data(0) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(1) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(2) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(3) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(4) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(5) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(6) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(7) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(8) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(9) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(10) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(11) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(12) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(13) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(14) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(15) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(16) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(17) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(18) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(19) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(20) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(21) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(22) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(23) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(24) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(25) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(26) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.cnt {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.readCountInRow {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.src_stride {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.dst_stride {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.src_width {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.dst_width {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.src_mcomp {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.rfactor {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.mcomp_mode {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.beat {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.write_valid {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.write_addr {-height 15 -radix hexadecimal}} /testbench/cpu/dma0/r
add wave -noupdate -group DMA -radix hexadecimal /testbench/cpu/dma0/r.data
add wave -noupdate -group DMA -radix hexadecimal /testbench/cpu/dma0/rin
add wave -noupdate -group DMA -radix hexadecimal /testbench/cpu/dma0/dmai
add wave -noupdate -group DMA -radix hexadecimal /testbench/cpu/dma0/dmao
add wave -noupdate -group DMA -radix unsigned /testbench/cpu/dma0/clk
add wave -noupdate -expand -group MCOMP -color Gold -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi.hsel(4)
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/rst
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/clk
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi.haddr
add wave -noupdate -expand -group MCOMP -color Magenta -radix hexadecimal /testbench/cpu/my_mcomp/ahbso.hrdata
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi.hwdata
add wave -noupdate -expand -group MCOMP -radix hexadecimal -expand -subitemconfig {/testbench/cpu/my_mcomp/ahbsi.hsel {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbsi.haddr {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbsi.hwrite {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbsi.htrans {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbsi.hsize {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbsi.hburst {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbsi.hwdata {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbsi.hprot {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbsi.hready {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbsi.hmaster {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbsi.hmastlock {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbsi.hmbsel {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbsi.hcache {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbsi.hirq {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbsi.testen {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbsi.testrst {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbsi.scanen {-radix hexadecimal} /testbench/cpu/my_mcomp/ahbsi.testoen {-radix hexadecimal}} /testbench/cpu/my_mcomp/ahbsi
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ahbso
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_a
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_b
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_c
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_d
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/reg_r
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/wr_valid
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/addr_wr
add wave -noupdate -expand -group MCOMP /testbench/cpu/my_mcomp/reading
add wave -noupdate -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/CLK1
add wave -noupdate -group {MCOMP RAM} -radix hexadecimal /testbench/cpu/my_mcomp/ram/WE1
add wave -noupdate -group {MCOMP RAM} -radix unsigned /testbench/cpu/my_mcomp/ram/Addr1
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
add wave -noupdate -expand -group {view1-ram to dma} -radix unsigned /testbench/cpu/dma0/clk
add wave -noupdate -expand -group {view1-ram to dma} -radix unsigned /testbench/cpu/dma0/mst/DMAIn.Request
add wave -noupdate -expand -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/mst/DMAIn.Address
add wave -noupdate -expand -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/mst/DMAIn.Burst
add wave -noupdate -expand -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/mst/AHBIn.hready
add wave -noupdate -expand -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/mst/DMAOut.OKAY
add wave -noupdate -expand -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/mst/DMAOut.Ready
add wave -noupdate -expand -group {view1-ram to dma} -radix unsigned /testbench/cpu/dma0/mst/AHBOut.hburst
add wave -noupdate -expand -group {view1-ram to dma} -radix unsigned /testbench/cpu/dma0/mst/AHBOut.htrans
add wave -noupdate -expand -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/mst/AHBOut.haddr
add wave -noupdate -expand -group {view1-ram to dma} -radix unsigned /testbench/cpu/dma0/mst/AHBIn.hready
add wave -noupdate -expand -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/mst/AHBIn.hrdata
add wave -noupdate -expand -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/rin.beat
add wave -noupdate -expand -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/r.beat
add wave -noupdate -expand -group {view1-ram to dma} /testbench/cpu/dma0/mst/DMAOut.Ready
add wave -noupdate -expand -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/mst/DMAOut.Data
add wave -noupdate -expand -group {view1-ram to dma} -radix hexadecimal -subitemconfig {/testbench/cpu/dma0/r.data(0) {-radix hexadecimal} /testbench/cpu/dma0/r.data(1) {-radix hexadecimal} /testbench/cpu/dma0/r.data(2) {-radix hexadecimal} /testbench/cpu/dma0/r.data(3) {-radix hexadecimal} /testbench/cpu/dma0/r.data(4) {-radix hexadecimal} /testbench/cpu/dma0/r.data(5) {-radix hexadecimal} /testbench/cpu/dma0/r.data(6) {-radix hexadecimal} /testbench/cpu/dma0/r.data(7) {-radix hexadecimal} /testbench/cpu/dma0/r.data(8) {-radix hexadecimal} /testbench/cpu/dma0/r.data(9) {-radix hexadecimal} /testbench/cpu/dma0/r.data(10) {-radix hexadecimal} /testbench/cpu/dma0/r.data(11) {-radix hexadecimal} /testbench/cpu/dma0/r.data(12) {-radix hexadecimal} /testbench/cpu/dma0/r.data(13) {-radix hexadecimal} /testbench/cpu/dma0/r.data(14) {-radix hexadecimal} /testbench/cpu/dma0/r.data(15) {-radix hexadecimal} /testbench/cpu/dma0/r.data(16) {-radix hexadecimal} /testbench/cpu/dma0/r.data(17) {-radix hexadecimal} /testbench/cpu/dma0/r.data(18) {-radix hexadecimal} /testbench/cpu/dma0/r.data(19) {-radix hexadecimal} /testbench/cpu/dma0/r.data(20) {-radix hexadecimal} /testbench/cpu/dma0/r.data(21) {-radix hexadecimal} /testbench/cpu/dma0/r.data(22) {-radix hexadecimal} /testbench/cpu/dma0/r.data(23) {-radix hexadecimal} /testbench/cpu/dma0/r.data(24) {-radix hexadecimal} /testbench/cpu/dma0/r.data(25) {-radix hexadecimal} /testbench/cpu/dma0/r.data(26) {-radix hexadecimal}} /testbench/cpu/dma0/r.data
add wave -noupdate -expand -group {view2-dma to mcomp} -color Gold -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi.hsel(4)
add wave -noupdate -expand -group {view2-dma to mcomp} -radix hexadecimal /testbench/cpu/dma0/r.write
add wave -noupdate -expand -group {view2-dma to mcomp} -radix unsigned /testbench/cpu/dma0/mst/DMAIn.Request
add wave -noupdate -expand -group {view2-dma to mcomp} -radix hexadecimal /testbench/cpu/dma0/mst/DMAIn.Address
add wave -noupdate -expand -group {view2-dma to mcomp} -radix hexadecimal /testbench/cpu/dma0/mst/DMAIn.Burst
add wave -noupdate -expand -group {view2-dma to mcomp} -radix unsigned /testbench/cpu/dma0/mst/AHBOut.hburst
add wave -noupdate -expand -group {view2-dma to mcomp} -radix unsigned /testbench/cpu/dma0/mst/AHBOut.htrans
add wave -noupdate -expand -group {view2-dma to mcomp} -radix hexadecimal /testbench/cpu/dma0/mst/AHBOut.haddr
add wave -noupdate -expand -group {view2-dma to mcomp} -radix unsigned /testbench/cpu/dma0/mst/AHBIn.hready
add wave -noupdate -expand -group {view2-dma to mcomp} -radix hexadecimal /testbench/cpu/dma0/mst/DMAOut.Ready
add wave -noupdate -expand -group {view2-dma to mcomp} -radix hexadecimal /testbench/cpu/my_mcomp/ahbso.hready
add wave -noupdate -expand -group {view2-dma to mcomp} -radix unsigned /testbench/cpu/dma0/r.cnt
add wave -noupdate -expand -group {view2-dma to mcomp} -radix hexadecimal /testbench/cpu/dma0/mst/AHBOut.hwdata
add wave -noupdate -expand -group {view2-dma to mcomp} -radix unsigned /testbench/cpu/my_mcomp/ram/Addr1
add wave -noupdate -expand -group {view2-dma to mcomp} -radix hexadecimal /testbench/cpu/my_mcomp/ram/WE1
add wave -noupdate -expand -group {view2-dma to mcomp} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_In1
add wave -noupdate -expand -group {view2-dma to mcomp} -radix hexadecimal -expand -subitemconfig {/testbench/cpu/my_mcomp/ram/DataMEM(0) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(1) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(2) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(3) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(4) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(5) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(6) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(7) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(8) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(9) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(10) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(11) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(12) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(13) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(14) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(15) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(16) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(17) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(18) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(19) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(20) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(21) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(22) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(23) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(24) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(25) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(26) {-height 15 -radix hexadecimal}} /testbench/cpu/my_mcomp/ram/DataMEM
add wave -noupdate -expand -group {view2-dma to mcomp} -radix hexadecimal /testbench/cpu/my_mcomp/reg_r
add wave -noupdate -expand -group {view2-dma to mcomp} /testbench/cpu/my_mcomp/mode
add wave -noupdate -group {view3-mcomp to dma} -color Gold -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi.hsel(4)
add wave -noupdate -group {view3-mcomp to dma} -radix hexadecimal /testbench/cpu/dma0/r.write
add wave -noupdate -group {view3-mcomp to dma} -radix unsigned /testbench/cpu/dma0/mst/DMAIn.Request
add wave -noupdate -group {view3-mcomp to dma} -radix hexadecimal /testbench/cpu/dma0/mst/DMAIn.Address
add wave -noupdate -group {view3-mcomp to dma} -radix hexadecimal /testbench/cpu/dma0/mst/DMAIn.Burst
add wave -noupdate -group {view3-mcomp to dma} -radix unsigned /testbench/cpu/dma0/mst/AHBOut.hburst
add wave -noupdate -group {view3-mcomp to dma} -radix unsigned /testbench/cpu/dma0/mst/AHBOut.htrans
add wave -noupdate -group {view3-mcomp to dma} -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi.htrans
add wave -noupdate -group {view3-mcomp to dma} -radix hexadecimal /testbench/cpu/dma0/mst/AHBOut.haddr
add wave -noupdate -group {view3-mcomp to dma} -radix hexadecimal /testbench/cpu/my_mcomp/next_addr
add wave -noupdate -group {view3-mcomp to dma} /testbench/cpu/my_mcomp/reading
add wave -noupdate -group {view3-mcomp to dma} -radix unsigned -subitemconfig {/testbench/cpu/my_mcomp/ram/Addr1(4) {-radix unsigned} /testbench/cpu/my_mcomp/ram/Addr1(3) {-radix unsigned} /testbench/cpu/my_mcomp/ram/Addr1(2) {-radix unsigned} /testbench/cpu/my_mcomp/ram/Addr1(1) {-radix unsigned} /testbench/cpu/my_mcomp/ram/Addr1(0) {-radix unsigned}} /testbench/cpu/my_mcomp/ram/Addr1
add wave -noupdate -group {view3-mcomp to dma} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_Out1
add wave -noupdate -group {view3-mcomp to dma} -color Magenta -radix hexadecimal /testbench/cpu/my_mcomp/ahbso.hrdata
add wave -noupdate -group {view3-mcomp to dma} -radix unsigned /testbench/cpu/dma0/mst/AHBIn.hready
add wave -noupdate -group {view3-mcomp to dma} -radix hexadecimal /testbench/cpu/dma0/mst/DMAOut.Ready
add wave -noupdate -group {view3-mcomp to dma} -radix hexadecimal /testbench/cpu/my_mcomp/ahbso.hready
add wave -noupdate -group {view3-mcomp to dma} -radix unsigned /testbench/cpu/dma0/r.cnt
add wave -noupdate -group {view3-mcomp to dma} -radix hexadecimal /testbench/cpu/dma0/mst/AHBOut.hwdata
add wave -noupdate -group {view3-mcomp to dma} -radix hexadecimal -subitemconfig {/testbench/cpu/my_mcomp/ram/DataMEM(0) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(1) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(2) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(3) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(4) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(5) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(6) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(7) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(8) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(9) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(10) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(11) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(12) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(13) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(14) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(15) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(16) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(17) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(18) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(19) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(20) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(21) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(22) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(23) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(24) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(25) {-height 15 -radix hexadecimal} /testbench/cpu/my_mcomp/ram/DataMEM(26) {-height 15 -radix hexadecimal}} /testbench/cpu/my_mcomp/ram/DataMEM
add wave -noupdate -group {view3-mcomp to dma} -radix hexadecimal /testbench/cpu/my_mcomp/reg_r
add wave -noupdate -group {view3-mcomp to dma} -radix hexadecimal -expand -subitemconfig {/testbench/cpu/dma0/r.data(0) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(1) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(2) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(3) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(4) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(5) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(6) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(7) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(8) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(9) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(10) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(11) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(12) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(13) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(14) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(15) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(16) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(17) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(18) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(19) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(20) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(21) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(22) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(23) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(24) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(25) {-height 15 -radix hexadecimal} /testbench/cpu/dma0/r.data(26) {-height 15 -radix hexadecimal}} /testbench/cpu/dma0/r.data
add wave -noupdate -group {view3-mcomp to dma} /testbench/cpu/my_mcomp/mode
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {226770366 ps} 1} {{Cursor 2} {234171751 ps} 1} {{Cursor 3} {231395346 ps} 0}
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
WaveRestoreZoom {226851648 ps} {227234720 ps}
bookmark add wave {0. dma enable } {{221329464 ps} {221712536 ps}} 0
bookmark add wave {1. ram to dma} {{223672164 ps} {224055236 ps}} 32
bookmark add wave {2. dma to mcomp} {{226851648 ps} {227234720 ps}} 43
bookmark add wave {3. mcomp to dma} {{230903850 ps} {231286922 ps}} 72
