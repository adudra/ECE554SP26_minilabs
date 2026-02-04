onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /matmul_tb/clk
add wave -noupdate -radix hexadecimal -childformat {{{/matmul_tb/matmul/a_matrix[0]} -radix hexadecimal} {{/matmul_tb/matmul/a_matrix[1]} -radix hexadecimal} {{/matmul_tb/matmul/a_matrix[2]} -radix hexadecimal} {{/matmul_tb/matmul/a_matrix[3]} -radix hexadecimal} {{/matmul_tb/matmul/a_matrix[4]} -radix hexadecimal} {{/matmul_tb/matmul/a_matrix[5]} -radix hexadecimal} {{/matmul_tb/matmul/a_matrix[6]} -radix hexadecimal} {{/matmul_tb/matmul/a_matrix[7]} -radix hexadecimal}} -subitemconfig {{/matmul_tb/matmul/a_matrix[0]} {-height 15 -radix hexadecimal} {/matmul_tb/matmul/a_matrix[1]} {-height 15 -radix hexadecimal} {/matmul_tb/matmul/a_matrix[2]} {-height 15 -radix hexadecimal} {/matmul_tb/matmul/a_matrix[3]} {-height 15 -radix hexadecimal} {/matmul_tb/matmul/a_matrix[4]} {-height 15 -radix hexadecimal} {/matmul_tb/matmul/a_matrix[5]} {-height 15 -radix hexadecimal} {/matmul_tb/matmul/a_matrix[6]} {-height 15 -radix hexadecimal} {/matmul_tb/matmul/a_matrix[7]} {-height 15 -radix hexadecimal}} /matmul_tb/matmul/a_matrix
add wave -noupdate -radix hexadecimal -childformat {{{/matmul_tb/matmul/b_vector[0]} -radix hexadecimal} {{/matmul_tb/matmul/b_vector[1]} -radix hexadecimal} {{/matmul_tb/matmul/b_vector[2]} -radix hexadecimal} {{/matmul_tb/matmul/b_vector[3]} -radix hexadecimal} {{/matmul_tb/matmul/b_vector[4]} -radix hexadecimal} {{/matmul_tb/matmul/b_vector[5]} -radix hexadecimal} {{/matmul_tb/matmul/b_vector[6]} -radix hexadecimal} {{/matmul_tb/matmul/b_vector[7]} -radix hexadecimal}} -subitemconfig {{/matmul_tb/matmul/b_vector[0]} {-height 15 -radix hexadecimal} {/matmul_tb/matmul/b_vector[1]} {-height 15 -radix hexadecimal} {/matmul_tb/matmul/b_vector[2]} {-height 15 -radix hexadecimal} {/matmul_tb/matmul/b_vector[3]} {-height 15 -radix hexadecimal} {/matmul_tb/matmul/b_vector[4]} {-height 15 -radix hexadecimal} {/matmul_tb/matmul/b_vector[5]} {-height 15 -radix hexadecimal} {/matmul_tb/matmul/b_vector[6]} {-height 15 -radix hexadecimal} {/matmul_tb/matmul/b_vector[7]} {-height 15 -radix hexadecimal}} /matmul_tb/matmul/b_vector
add wave -noupdate -radix hexadecimal -childformat {{{/matmul_tb/matmul/c_vector[0]} -radix hexadecimal} {{/matmul_tb/matmul/c_vector[1]} -radix hexadecimal} {{/matmul_tb/matmul/c_vector[2]} -radix hexadecimal} {{/matmul_tb/matmul/c_vector[3]} -radix hexadecimal} {{/matmul_tb/matmul/c_vector[4]} -radix hexadecimal} {{/matmul_tb/matmul/c_vector[5]} -radix hexadecimal} {{/matmul_tb/matmul/c_vector[6]} -radix hexadecimal} {{/matmul_tb/matmul/c_vector[7]} -radix hexadecimal}} -expand -subitemconfig {{/matmul_tb/matmul/c_vector[0]} {-height 15 -radix hexadecimal} {/matmul_tb/matmul/c_vector[1]} {-height 15 -radix hexadecimal} {/matmul_tb/matmul/c_vector[2]} {-height 15 -radix hexadecimal} {/matmul_tb/matmul/c_vector[3]} {-height 15 -radix hexadecimal} {/matmul_tb/matmul/c_vector[4]} {-height 15 -radix hexadecimal} {/matmul_tb/matmul/c_vector[5]} {-height 15 -radix hexadecimal} {/matmul_tb/matmul/c_vector[6]} {-height 15 -radix hexadecimal} {/matmul_tb/matmul/c_vector[7]} {-height 15 -radix hexadecimal}} /matmul_tb/matmul/c_vector
add wave -noupdate -radix hexadecimal /matmul_tb/matmul/state
add wave -noupdate -radix hexadecimal /matmul_tb/matmul/next_state
add wave -noupdate /matmul_tb/matmul/run
add wave -noupdate -expand /matmul_tb/matmul/ia_empty
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {213 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 206
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
WaveRestoreZoom {0 ps} {576 ps}
