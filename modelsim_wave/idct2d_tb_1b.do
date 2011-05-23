onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/cpu/my_idct2d/rst
add wave -noupdate /testbench/cpu/my_idct2d/clk
add wave -noupdate -color Yellow /testbench/cpu/my_idct2d/ahbsi.hsel(7)
add wave -noupdate /testbench/cpu/my_idct2d/ahbsi.hready
add wave -noupdate /testbench/cpu/my_idct2d/ahbsi.hwrite
add wave -noupdate /testbench/cpu/my_idct2d/ahbsi.haddr
add wave -noupdate /testbench/cpu/my_idct2d/ahbsi.hwdata
add wave -noupdate -color Violet -radix hexadecimal /testbench/cpu/my_idct2d/ahbso.hrdata
add wave -noupdate /testbench/cpu/my_idct2d/ahbsi
add wave -noupdate /testbench/cpu/my_idct2d/ahbso
add wave -noupdate /testbench/cpu/my_idct2d/wr_valid
add wave -noupdate /testbench/cpu/my_idct2d/addr_wr
add wave -noupdate -color Blue /testbench/cpu/my_idct2d/prev_state
add wave -noupdate -color Blue /testbench/cpu/my_idct2d/prev_substate
add wave -noupdate /testbench/cpu/my_idct2d/next_state
add wave -noupdate /testbench/cpu/my_idct2d/next_substate
add wave -noupdate -radix decimal /testbench/cpu/my_idct2d/stage_counter
add wave -noupdate /testbench/cpu/my_idct2d/action
add wave -noupdate -radix binary /testbench/cpu/my_idct2d/reading_block
add wave -noupdate -expand /testbench/cpu/my_idct2d/read_count
add wave -noupdate -color Cyan -radix unsigned -expand -subitemconfig {/testbench/cpu/my_idct2d/row_index(6) {-color #0000ffffffff -height 15 -radix unsigned} /testbench/cpu/my_idct2d/row_index(5) {-color #0000ffffffff -height 15 -radix unsigned} /testbench/cpu/my_idct2d/row_index(4) {-color #0000ffffffff -height 15 -radix unsigned} /testbench/cpu/my_idct2d/row_index(3) {-color #0000ffffffff -height 15 -radix unsigned} /testbench/cpu/my_idct2d/row_index(2) {-color #0000ffffffff -height 15 -radix unsigned} /testbench/cpu/my_idct2d/row_index(1) {-color #0000ffffffff -height 15 -radix unsigned} /testbench/cpu/my_idct2d/row_index(0) {-color #0000ffffffff -height 15 -radix unsigned}} /testbench/cpu/my_idct2d/row_index
add wave -noupdate -radix unsigned -expand -subitemconfig {/testbench/cpu/my_idct2d/col_index(5) {-height 15 -radix unsigned} /testbench/cpu/my_idct2d/col_index(4) {-height 15 -radix unsigned} /testbench/cpu/my_idct2d/col_index(3) {-height 15 -radix unsigned} /testbench/cpu/my_idct2d/col_index(2) {-height 15 -radix unsigned} /testbench/cpu/my_idct2d/col_index(1) {-height 15 -radix unsigned} /testbench/cpu/my_idct2d/col_index(0) {-height 15 -radix unsigned}} /testbench/cpu/my_idct2d/col_index
add wave -noupdate -divider IDCT
add wave -noupdate /testbench/cpu/my_idct2d/action_idct
add wave -noupdate /testbench/cpu/my_idct2d/rw
add wave -noupdate /testbench/cpu/my_idct2d/rw_stage
add wave -noupdate -radix decimal /testbench/cpu/my_idct2d/Fin1
add wave -noupdate -radix decimal /testbench/cpu/my_idct2d/Fin2
add wave -noupdate -radix decimal /testbench/cpu/my_idct2d/pout1
add wave -noupdate -radix decimal /testbench/cpu/my_idct2d/pout2
add wave -noupdate -group idct -group state /testbench/cpu/my_idct2d/my_idct_1d/done
add wave -noupdate -group idct -group state /testbench/cpu/my_idct2d/my_idct_1d/hv_pr_state
add wave -noupdate -group idct -group state /testbench/cpu/my_idct2d/my_idct_1d/hv_nx_state
add wave -noupdate -group idct -group state /testbench/cpu/my_idct2d/my_idct_1d/g2p_pr_state
add wave -noupdate -group idct -group state /testbench/cpu/my_idct2d/my_idct_1d/g2p_nx_state
add wave -noupdate -group idct -group {F array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/F0
add wave -noupdate -group idct -group {F array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/F1
add wave -noupdate -group idct -group {F array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/F2
add wave -noupdate -group idct -group {F array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/F3
add wave -noupdate -group idct -group {F array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/F4
add wave -noupdate -group idct -group {F array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/F5
add wave -noupdate -group idct -group {F array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/F6
add wave -noupdate -group idct -group {F array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/F7
add wave -noupdate -group idct -expand -group {p Array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/p0
add wave -noupdate -group idct -expand -group {p Array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/p1
add wave -noupdate -group idct -expand -group {p Array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/p2
add wave -noupdate -group idct -expand -group {p Array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/p3
add wave -noupdate -group idct -expand -group {p Array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/p4
add wave -noupdate -group idct -expand -group {p Array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/p5
add wave -noupdate -group idct -expand -group {p Array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/p6
add wave -noupdate -group idct -expand -group {p Array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/p7
add wave -noupdate -group idct -group {g array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/g0
add wave -noupdate -group idct -group {g array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/g1
add wave -noupdate -group idct -group {g array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/g2
add wave -noupdate -group idct -group {g array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/g3
add wave -noupdate -group idct -group {g array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/g4
add wave -noupdate -group idct -group {g array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/g5
add wave -noupdate -group idct -group {g array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/g6
add wave -noupdate -group idct -group {g array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/g7
add wave -noupdate -group idct -group {v array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/v0
add wave -noupdate -group idct -group {v array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/v1
add wave -noupdate -group idct -group {v array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/v2
add wave -noupdate -group idct -group {v array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/v3
add wave -noupdate -group idct -group {m array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/m1
add wave -noupdate -group idct -group {m array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/m2
add wave -noupdate -group idct -group {m array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/m3
add wave -noupdate -group idct -group {m array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/m4
add wave -noupdate -group idct -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/action
add wave -noupdate -group idct -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/action_two
add wave -noupdate -group idct -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/main_cntr
add wave -noupdate -group idct -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/aux_cntr
add wave -noupdate -group idct -group h -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/h00
add wave -noupdate -group idct -group h -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/h01
add wave -noupdate -group idct -group h -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/h02
add wave -noupdate -group idct -group h -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/h03
add wave -noupdate -group idct -group h -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/h10
add wave -noupdate -group idct -group h -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/h11
add wave -noupdate -group idct -group h -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/h12
add wave -noupdate -group idct -group h -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/h13
add wave -noupdate -group idct -group h -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/h20
add wave -noupdate -group idct -group h -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/h21
add wave -noupdate -group idct -group h -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/h22
add wave -noupdate -group idct -group h -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/h23
add wave -noupdate -group idct -group h -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/h30
add wave -noupdate -group idct -group h -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/h31
add wave -noupdate -group idct -group h -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/h32
add wave -noupdate -group idct -group h -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/h33
add wave -noupdate -divider BRAM
add wave -noupdate -radix decimal /testbench/cpu/my_idct2d/iram/DataMEM
add wave -noupdate -radix decimal /testbench/cpu/my_idct2d/tram/DataMEM
add wave -noupdate -group iram -radix decimal /testbench/cpu/my_idct2d/iram/CLK1
add wave -noupdate -group iram -radix decimal /testbench/cpu/my_idct2d/iram/WE1
add wave -noupdate -group iram -radix unsigned /testbench/cpu/my_idct2d/iram/Addr1
add wave -noupdate -group iram -radix decimal /testbench/cpu/my_idct2d/iram/Data_In1
add wave -noupdate -group iram -color Magenta -radix decimal /testbench/cpu/my_idct2d/iram/Data_Out1
add wave -noupdate -group iram -radix decimal /testbench/cpu/my_idct2d/iram/CLK2
add wave -noupdate -group iram -radix decimal /testbench/cpu/my_idct2d/iram/WE2
add wave -noupdate -group iram -radix unsigned /testbench/cpu/my_idct2d/iram/Addr2
add wave -noupdate -group iram -radix decimal /testbench/cpu/my_idct2d/iram/Data_In2
add wave -noupdate -group iram -color Magenta -radix decimal /testbench/cpu/my_idct2d/iram/Data_Out2
add wave -noupdate -group tram /testbench/cpu/my_idct2d/tram/CLK1
add wave -noupdate -group tram /testbench/cpu/my_idct2d/tram/WE1
add wave -noupdate -group tram -radix unsigned /testbench/cpu/my_idct2d/tram/Addr1
add wave -noupdate -group tram -radix decimal /testbench/cpu/my_idct2d/tram/Data_In1
add wave -noupdate -group tram /testbench/cpu/my_idct2d/tram/Data_Out1
add wave -noupdate -group tram /testbench/cpu/my_idct2d/tram/CLK2
add wave -noupdate -group tram /testbench/cpu/my_idct2d/tram/WE2
add wave -noupdate -group tram -radix unsigned /testbench/cpu/my_idct2d/tram/Addr2
add wave -noupdate -group tram -radix decimal /testbench/cpu/my_idct2d/tram/Data_In2
add wave -noupdate -group tram /testbench/cpu/my_idct2d/tram/Data_Out2
add wave -noupdate /testbench/cpu/my_idct2d/my_idct_1d/action
add wave -noupdate /testbench/cpu/my_idct2d/my_idct_1d/main_cntr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {223396000 ps} 1} {{Cursor 2} {231471000 ps} 0} {{Stage0 begin} {231372327 ps} 1} {{Stage1 begin} {234973654 ps} 1} {done {238597327 ps} 1}
configure wave -namecolwidth 272
configure wave -valuecolwidth 168
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {239443994 ps} {240029263 ps}
