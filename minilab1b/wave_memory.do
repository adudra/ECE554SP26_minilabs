onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /avalon_mm_master_tb/iTB/top_master/clk
add wave -noupdate -radix hexadecimal /avalon_mm_master_tb/iTB/top_master/rst_n
add wave -noupdate -divider Master
add wave -noupdate -radix hexadecimal /avalon_mm_master_tb/iTB/top_master/state
add wave -noupdate -radix hexadecimal /avalon_mm_master_tb/iTB/top_master/address
add wave -noupdate -radix hexadecimal /avalon_mm_master_tb/iTB/top_master/readdata
add wave -noupdate -radix hexadecimal /avalon_mm_master_tb/iTB/top_master/read
add wave -noupdate -radix hexadecimal /avalon_mm_master_tb/iTB/top_master/readdatavalid
add wave -noupdate -radix hexadecimal /avalon_mm_master_tb/iTB/top_master/cnt
add wave -noupdate -radix hexadecimal /avalon_mm_master_tb/iTB/top_master/cap
add wave -noupdate -radix hexadecimal -childformat {{{/avalon_mm_master_tb/iTB/top_master/a_matrix[0]} -radix hexadecimal} {{/avalon_mm_master_tb/iTB/top_master/a_matrix[1]} -radix hexadecimal} {{/avalon_mm_master_tb/iTB/top_master/a_matrix[2]} -radix hexadecimal} {{/avalon_mm_master_tb/iTB/top_master/a_matrix[3]} -radix hexadecimal} {{/avalon_mm_master_tb/iTB/top_master/a_matrix[4]} -radix hexadecimal} {{/avalon_mm_master_tb/iTB/top_master/a_matrix[5]} -radix hexadecimal} {{/avalon_mm_master_tb/iTB/top_master/a_matrix[6]} -radix hexadecimal} {{/avalon_mm_master_tb/iTB/top_master/a_matrix[7]} -radix hexadecimal}} -expand -subitemconfig {{/avalon_mm_master_tb/iTB/top_master/a_matrix[0]} {-height 15 -radix hexadecimal} {/avalon_mm_master_tb/iTB/top_master/a_matrix[1]} {-height 15 -radix hexadecimal} {/avalon_mm_master_tb/iTB/top_master/a_matrix[2]} {-height 15 -radix hexadecimal} {/avalon_mm_master_tb/iTB/top_master/a_matrix[3]} {-height 15 -radix hexadecimal} {/avalon_mm_master_tb/iTB/top_master/a_matrix[4]} {-height 15 -radix hexadecimal} {/avalon_mm_master_tb/iTB/top_master/a_matrix[5]} {-height 15 -radix hexadecimal} {/avalon_mm_master_tb/iTB/top_master/a_matrix[6]} {-height 15 -radix hexadecimal} {/avalon_mm_master_tb/iTB/top_master/a_matrix[7]} {-height 15 -radix hexadecimal}} /avalon_mm_master_tb/iTB/top_master/a_matrix
add wave -noupdate -divider Slave
add wave -noupdate /avalon_mm_master_tb/iTB/top_slave/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {154 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 319
configure wave -valuecolwidth 100
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
configure wave -timelineunits ps
update
WaveRestoreZoom {11 ps} {293 ps}
