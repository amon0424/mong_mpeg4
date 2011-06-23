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
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/rin
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/dmai
add wave -noupdate -expand -group DMA -radix hexadecimal /testbench/cpu/dma0/dmao
add wave -noupdate -expand -group DMA -radix unsigned /testbench/cpu/dma0/clk
add wave -noupdate -expand -group MCOMP -color Gold -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi.hsel(4)
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/rst
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/clk
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi.haddr
add wave -noupdate -expand -group MCOMP -color Magenta -radix hexadecimal /testbench/cpu/my_mcomp/ahbso.hrdata
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi.hwdata
add wave -noupdate -expand -group MCOMP -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi
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
add wave -noupdate -radix hexadecimal /testbench/cpu/my_mcomp/ram/DataMEM
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/HCLK
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/HRESETn
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/DMAIn
add wave -noupdate -group DMA2AHB -radix hexadecimal -expand -subitemconfig {/testbench/cpu/dma0/mst/DMAOut.Grant {-height 15 -radix hexadecimal} /testbench/cpu/dma0/mst/DMAOut.OKAY {-height 15 -radix hexadecimal} /testbench/cpu/dma0/mst/DMAOut.Ready {-height 15 -radix hexadecimal} /testbench/cpu/dma0/mst/DMAOut.Retry {-height 15 -radix hexadecimal} /testbench/cpu/dma0/mst/DMAOut.Fault {-height 15 -radix hexadecimal} /testbench/cpu/dma0/mst/DMAOut.Data {-height 15 -radix hexadecimal}} /testbench/cpu/dma0/mst/DMAOut
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/AHBIn
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/AHBOut
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/Address
add wave -noupdate -group DMA2AHB -radix hexadecimal /testbench/cpu/dma0/mst/AddressSave
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
add wave -noupdate -group {view1-ram to dma} -radix unsigned /testbench/cpu/dma0/clk
add wave -noupdate -group {view1-ram to dma} -radix unsigned /testbench/cpu/dma0/mst/DMAIn.Request
add wave -noupdate -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/mst/ActivePhase
add wave -noupdate -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/mst/AddressPhase
add wave -noupdate -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/mst/DMAIn.Address
add wave -noupdate -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/mst/DMAIn.Burst
add wave -noupdate -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/mst/AHBIn.hready
add wave -noupdate -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/mst/DMAOut.OKAY
add wave -noupdate -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/mst/DMAOut.Ready
add wave -noupdate -group {view1-ram to dma} -radix unsigned /testbench/cpu/dma0/mst/AHBOut.hburst
add wave -noupdate -group {view1-ram to dma} -radix unsigned /testbench/cpu/dma0/mst/AHBOut.htrans
add wave -noupdate -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/mst/AHBOut.haddr
add wave -noupdate -group {view1-ram to dma} -radix unsigned /testbench/cpu/dma0/mst/AHBIn.hready
add wave -noupdate -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/mst/AHBIn.hrdata
add wave -noupdate -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/rin.beat
add wave -noupdate -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/r.beat
add wave -noupdate -group {view1-ram to dma} /testbench/cpu/dma0/mst/DMAOut.Ready
add wave -noupdate -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/mst/DMAOut.Data
add wave -noupdate -group {view1-ram to dma} -radix hexadecimal /testbench/cpu/dma0/r.data
add wave -noupdate -group {view2-dma to mcomp} -color Gold -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi.hsel(4)
add wave -noupdate -group {view2-dma to mcomp} -radix hexadecimal /testbench/cpu/dma0/r.dstate
add wave -noupdate -group {view2-dma to mcomp} -radix hexadecimal /testbench/cpu/dma0/r.write
add wave -noupdate -group {view2-dma to mcomp} -radix unsigned /testbench/cpu/dma0/mst/DMAIn.Request
add wave -noupdate -group {view2-dma to mcomp} -radix hexadecimal /testbench/cpu/dma0/mst/DMAIn.Address
add wave -noupdate -group {view2-dma to mcomp} -radix hexadecimal /testbench/cpu/dma0/mst/DMAIn.Burst
add wave -noupdate -group {view2-dma to mcomp} -radix unsigned /testbench/cpu/dma0/mst/AHBOut.hburst
add wave -noupdate -group {view2-dma to mcomp} -radix unsigned /testbench/cpu/dma0/mst/AHBOut.htrans
add wave -noupdate -group {view2-dma to mcomp} -radix hexadecimal /testbench/cpu/dma0/mst/AHBOut.haddr
add wave -noupdate -group {view2-dma to mcomp} -radix unsigned /testbench/cpu/dma0/mst/AHBIn.hready
add wave -noupdate -group {view2-dma to mcomp} -radix hexadecimal /testbench/cpu/dma0/mst/DMAOut.Ready
add wave -noupdate -group {view2-dma to mcomp} -radix hexadecimal /testbench/cpu/my_mcomp/ahbso.hready
add wave -noupdate -group {view2-dma to mcomp} -radix unsigned /testbench/cpu/dma0/r.cnt
add wave -noupdate -group {view2-dma to mcomp} -radix hexadecimal /testbench/cpu/dma0/mst/AHBOut.hwdata
add wave -noupdate -group {view2-dma to mcomp} -radix unsigned /testbench/cpu/my_mcomp/ram/Addr1
add wave -noupdate -group {view2-dma to mcomp} -radix hexadecimal /testbench/cpu/my_mcomp/ram/WE1
add wave -noupdate -group {view2-dma to mcomp} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_In1
add wave -noupdate -group {view2-dma to mcomp} -radix hexadecimal /testbench/cpu/my_mcomp/ram/DataMEM
add wave -noupdate -group {view2-dma to mcomp} -radix hexadecimal /testbench/cpu/my_mcomp/reg_r
add wave -noupdate -group {view2-dma to mcomp} /testbench/cpu/my_mcomp/mode
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
add wave -noupdate -group {view3-mcomp to dma} -radix unsigned /testbench/cpu/my_mcomp/ram/Addr1
add wave -noupdate -group {view3-mcomp to dma} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_Out1
add wave -noupdate -group {view3-mcomp to dma} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_Out2
add wave -noupdate -group {view3-mcomp to dma} -color Magenta -radix hexadecimal /testbench/cpu/my_mcomp/ahbso.hrdata
add wave -noupdate -group {view3-mcomp to dma} -radix unsigned /testbench/cpu/dma0/mst/AHBIn.hready
add wave -noupdate -group {view3-mcomp to dma} -radix hexadecimal /testbench/cpu/dma0/mst/DMAOut.Ready
add wave -noupdate -group {view3-mcomp to dma} -radix hexadecimal /testbench/cpu/my_mcomp/ahbso.hready
add wave -noupdate -group {view3-mcomp to dma} -radix unsigned /testbench/cpu/dma0/r.cnt
add wave -noupdate -group {view3-mcomp to dma} -radix hexadecimal /testbench/cpu/dma0/mst/AHBOut.hwdata
add wave -noupdate -group {view3-mcomp to dma} -radix hexadecimal /testbench/cpu/my_mcomp/ram/DataMEM
add wave -noupdate -group {view3-mcomp to dma} -radix hexadecimal /testbench/cpu/my_mcomp/reg_r
add wave -noupdate -group {view3-mcomp to dma} -radix hexadecimal /testbench/cpu/dma0/r.data
add wave -noupdate -group {view3-mcomp to dma} /testbench/cpu/my_mcomp/mode
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -color Gold -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi.hsel(4)
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix hexadecimal /testbench/cpu/dma0/r.write
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix unsigned /testbench/cpu/dma0/mst/DMAIn.Request
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix hexadecimal /testbench/cpu/dma0/mst/DMAIn.Address
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix hexadecimal /testbench/cpu/dma0/mst/DMAIn.Burst
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix unsigned /testbench/cpu/dma0/mst/AHBOut.hburst
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix unsigned /testbench/cpu/dma0/mst/AHBOut.htrans
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi.htrans
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi.hwrite
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix hexadecimal /testbench/cpu/dma0/mst/AHBOut.haddr
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix hexadecimal /testbench/cpu/my_mcomp/next_addr
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} /testbench/cpu/my_mcomp/reading
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix unsigned /testbench/cpu/my_mcomp/ram/Addr1
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix unsigned /testbench/cpu/my_mcomp/ram/Addr2
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_Out1
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix hexadecimal /testbench/cpu/my_mcomp/ram/Data_Out2
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -color Magenta -radix hexadecimal /testbench/cpu/my_mcomp/ahbso.hrdata
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix unsigned /testbench/cpu/dma0/mst/AHBIn.hready
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix hexadecimal /testbench/cpu/dma0/mst/DMAOut.Ready
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix hexadecimal /testbench/cpu/my_mcomp/ahbso.hready
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix unsigned /testbench/cpu/dma0/r.cnt
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix hexadecimal /testbench/cpu/dma0/mst/AHBOut.hwdata
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix hexadecimal /testbench/cpu/my_mcomp/ram/DataMEM
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix hexadecimal /testbench/cpu/my_mcomp/reg_r
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix hexadecimal /testbench/cpu/dma0/r.data
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix unsigned /testbench/cpu/my_mcomp/mode
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix unsigned /testbench/cpu/my_mcomp/hv_counter
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix unsigned /testbench/cpu/my_mcomp/hv_request
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix unsigned /testbench/cpu/my_mcomp/hv_start
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix unsigned /testbench/cpu/my_mcomp/hv_flag
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix unsigned /testbench/cpu/my_mcomp/hv_tmp
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix unsigned /testbench/cpu/my_mcomp/last_ram_addr1
add wave -noupdate -expand -group {view3-mcomp to dma (hv)} -radix unsigned /testbench/cpu/my_mcomp/last_ram_addr2
add wave -noupdate -group {view4-dma to ram} -radix hexadecimal /testbench/cpu/dma0/r.write
add wave -noupdate -group {view4-dma to ram} -color Gold -radix hexadecimal /testbench/cpu/my_mcomp/ahbsi.hsel(4)
add wave -noupdate -group {view4-dma to ram} -radix hexadecimal /testbench/cpu/dma0/r.data
add wave -noupdate -group {view4-dma to ram} -radix unsigned /testbench/cpu/dma0/r.cnt
add wave -noupdate -group {view4-dma to ram} -radix hexadecimal /testbench/cpu/dma0/mst/DMAIn.Address
add wave -noupdate -group {view4-dma to ram} -radix hexadecimal /testbench/cpu/dma0/mst/AHBOut.haddr
add wave -noupdate -group {view4-dma to ram} -radix hexadecimal /testbench/cpu/dma0/r.beat
add wave -noupdate -group {view4-dma to ram} -radix hexadecimal /testbench/cpu/dma0/mst/AHBOut.hwdata
add wave -noupdate -group {view4-dma to ram} -radix hexadecimal /testbench/cpu/dma0/mst/AHBIn.hready
add wave -noupdate -group {view4-dma to ram} -radix unsigned /testbench/cpu/dma0/mst/DMAIn.Request
add wave -noupdate -group {view4-dma to ram} -radix hexadecimal /testbench/cpu/dma0/mst/DMAIn.Burst
add wave -noupdate -group {view4-dma to ram} -radix hexadecimal /testbench/cpu/dma0/mst/ActivePhase
add wave -noupdate -group {view4-dma to ram} -radix hexadecimal /testbench/cpu/dma0/mst/AddressPhase
add wave -noupdate -group {view4-dma to ram} -radix hexadecimal /testbench/cpu/dma0/mst/DataPhase
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {226770366 ps} 1} {{Cursor 2} {234171751 ps} 1} {{Cursor 4} {227746249 ps} 1} {{Cursor 5} {240245580 ps} 0}
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
WaveRestoreZoom {239884855 ps} {240317639 ps}
bookmark add wave {0. dma enable } {{221329464 ps} {221712536 ps}} 0
bookmark add wave {1. ram to dma} {{223672164 ps} {224055236 ps}} 32
bookmark add wave {2. dma to mcomp} {{226851648 ps} {227234720 ps}} 43
bookmark add wave {3. mcomp to dma} {{230903850 ps} {231286922 ps}} 72
bookmark add wave {4. dma to ram} {{231599976 ps} {231983048 ps}} 19
