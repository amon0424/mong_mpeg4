onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/cpu/my_idct2d/rst
add wave -noupdate /testbench/cpu/my_idct2d/clk
add wave -noupdate -group ahb /testbench/cpu/my_idct2d/ahbsi.hready
add wave -noupdate -group ahb /testbench/cpu/my_idct2d/ahbsi.hwrite
add wave -noupdate -group ahb -radix hexadecimal /testbench/cpu/my_idct2d/ahbsi.haddr
add wave -noupdate -group ahb -radix hexadecimal /testbench/cpu/my_idct2d/ahbsi.hwdata
add wave -noupdate -group ahb -color Violet -radix hexadecimal /testbench/cpu/my_idct2d/ahbso.hrdata
add wave -noupdate -group ahb /testbench/cpu/my_idct2d/ahbsi
add wave -noupdate -group ahb /testbench/cpu/my_idct2d/ahbso
add wave -noupdate -group ahb -color Yellow /testbench/cpu/my_idct2d/ahbsi.hsel(7)
add wave -noupdate /testbench/cpu/my_idct2d/wr_valid
add wave -noupdate -color Blue /testbench/cpu/my_idct2d/prev_state
add wave -noupdate -color Blue /testbench/cpu/my_idct2d/prev_substate
add wave -noupdate /testbench/cpu/my_idct2d/next_state
add wave -noupdate /testbench/cpu/my_idct2d/next_substate
add wave -noupdate -radix unsigned /testbench/cpu/my_idct2d/stage_counter
add wave -noupdate /testbench/cpu/my_idct2d/action
add wave -noupdate -radix unsigned /testbench/cpu/my_idct2d/read_count
add wave -noupdate -color Cyan -radix decimal /testbench/cpu/my_idct2d/row_index
add wave -noupdate -radix unsigned /testbench/cpu/my_idct2d/col_index
add wave -noupdate -radix unsigned /testbench/cpu/my_idct2d/hwrite_stage
add wave -noupdate -radix unsigned /testbench/cpu/my_idct2d/hread_stage
add wave -noupdate /testbench/cpu/my_idct2d/action_idct
add wave -noupdate -divider IDCT
add wave -noupdate /testbench/cpu/my_idct2d/rw
add wave -noupdate -radix unsigned /testbench/cpu/my_idct2d/rw_stage
add wave -noupdate /testbench/cpu/my_idct2d/Fin
add wave -noupdate -radix decimal /testbench/cpu/my_idct2d/pout
add wave -noupdate -group idct -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/action
add wave -noupdate -group idct -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/action_two
add wave -noupdate -group idct -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/main_cntr
add wave -noupdate -group idct -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/aux_cntr
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
add wave -noupdate -group idct -group {p Array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/p0
add wave -noupdate -group idct -group {p Array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/p1
add wave -noupdate -group idct -group {p Array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/p2
add wave -noupdate -group idct -group {p Array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/p3
add wave -noupdate -group idct -group {p Array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/p4
add wave -noupdate -group idct -group {p Array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/p5
add wave -noupdate -group idct -group {p Array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/p6
add wave -noupdate -group idct -group {p Array} -radix decimal /testbench/cpu/my_idct2d/my_idct_1d/p7
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
add wave -noupdate -group iram /testbench/cpu/my_idct2d/iram/CLK
add wave -noupdate -group iram /testbench/cpu/my_idct2d/iram/WE
add wave -noupdate -group iram /testbench/cpu/my_idct2d/iram/Addr
add wave -noupdate -group iram /testbench/cpu/my_idct2d/iram/Data_In
add wave -noupdate -group iram /testbench/cpu/my_idct2d/iram/Data_Out
add wave -noupdate -group tram /testbench/cpu/my_idct2d/tram/CLK
add wave -noupdate -group tram /testbench/cpu/my_idct2d/tram/WE
add wave -noupdate -group tram -radix unsigned /testbench/cpu/my_idct2d/tram/Addr
add wave -noupdate -group tram -radix decimal /testbench/cpu/my_idct2d/tram/Data_In
add wave -noupdate -group tram /testbench/cpu/my_idct2d/tram/Data_Out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {Begin {215871000 ps} 1} {End {294621000 ps} 1} {{Cursor 7} {231796922 ps} 0}
configure wave -namecolwidth 256
configure wave -valuecolwidth 168
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
WaveRestoreZoom {38495304 ps} {38838142 ps}
bookmark add wave Done {{242527571 ps} {242870409 ps}} -none-
bookmark add wave {Stage0 begin} {{231302427 ps} {231645265 ps}} -none-
bookmark add wave {Stage1 begin} {{236901570 ps} {237244408 ps}} -none-
bookmark add wave hwrite {{215820129 ps} {216162967 ps}} 0
