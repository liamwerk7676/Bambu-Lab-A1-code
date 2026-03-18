;===== machine: A1 =========================
;===== code: FILAMENT G-CODE ===============
;===== date: 20240830 -- 12122025 ======================
;
;===== modded bcSys v0.4 ===================
;===== ported by liamwerk7676 ===========
;===== optimized for all nozzle sizes ======
;===== Long retract in GCODE ===============

M1007 S0 ; turn off mass estimation
G392 S0
M620 S[next_extruder]A
M204 S9000
{if toolchange_count > 1}
G17
G2 Z{max_layer_z + 0.4} I0.86 J0.86 P1 F10000 ; spiral lift a little from second lift
{endif}
G1 Z{max_layer_z + 3.0} F1200

M400
M106 P1 S0
M106 P2 S0
{if old_filament_temp > 142 && next_extruder < 255}
M104 S[old_filament_temp]
{endif}

;******** ADDON LONG RETRACTION
G1 E-18 F1600    ;Filament is retracted before cutting (18mm)
M400
;******** ADDON LONG RETRACTION
G1 X267 Y128 F18000 F8000 ; timesaver

M620.1 E F[old_filament_e_feedrate] T{nozzle_temperature_range_high[previous_extruder]}
M620.10 A0 F[old_filament_e_feedrate]
T[next_extruder]
M620.1 E F[new_filament_e_feedrate] T{nozzle_temperature_range_high[next_extruder]}
M620.10 A1 F[new_filament_e_feedrate] L[flush_length] H[nozzle_diameter] T[nozzle_temperature_range_high]


{if next_extruder < 255}
M400


;*******************************
;******** ADDON LONG RETRACTION
;*******************************
M104 S[nozzle_temperature_range_high]
G1 E18 F600     ;Filament is extruded for 18 mm
M400
;*******************************
;******** ADDON LONG RETRACTION
;*******************************
G92 E0
M628 S0

M104 S[new_filament_temp] ;time saver
{if flush_length_1 > 1}
; FLUSH_START
; always use highest temperature to flush
M400
M1002 set_filament_type:UNKNOWN
M106 P1 S60
{if flush_length_1 > 23.7}
G1 E23.7 F{old_filament_e_feedrate} ; do not need pulsatile flushing for start part
G1 E{(flush_length_1 - 23.7) * 0.02} F150
G1 E{(flush_length_1 - 23.7) * 0.23} F{old_filament_e_feedrate * 1.2}
G1 E{(flush_length_1 - 23.7) * 0.02} F150
G1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate * 1.2}
G1 E{(flush_length_1 - 23.7) * 0.02} F150
G1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate * 1.2}
G1 E{(flush_length_1 - 23.7) * 0.02} F150
G1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate * 1.2}
{else}
G1 E{flush_length_1} F{old_filament_e_feedrate}
{endif}
; FLUSH_END
G1 E-[old_retract_length_toolchange] F1800
G1 E[old_retract_length_toolchange] F300
M400
M1002 set_filament_type:{filament_type[next_extruder]}
{endif}

{if flush_length_1 > 45 && flush_length_2 > 1}
; WIPE
M400
M106 P1 S178
M400 S3
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
M400
M106 P1 S0
{endif}

{if flush_length_2 > 1}
M106 P1 S60
; FLUSH_START
G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate * 1.2}
G1 E{flush_length_2 * 0.02} F150
G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate * 1.2}
G1 E{flush_length_2 * 0.02} F150
G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate * 1.2}
G1 E{flush_length_2 * 0.02} F150
G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate * 1.2}
G1 E{flush_length_2 * 0.02} F150
G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate * 1.2}
G1 E{flush_length_2 * 0.02} F150
; FLUSH_END
G1 E-[new_retract_length_toolchange] F1800
G1 E[new_retract_length_toolchange] F300
{endif}

{if flush_length_2 > 45 && flush_length_3 > 1}
; WIPE
M400
M106 P1 S178
M400 S2 ;time saver
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
M400
M106 P1 S0
{endif}

{if flush_length_3 > 1}
M106 P1 S60
; FLUSH_START
G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate * 1.2}
G1 E{flush_length_3 * 0.02} F150
G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate * 1.2}
G1 E{flush_length_3 * 0.02} F150
G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate * 1.2}
G1 E{flush_length_3 * 0.02} F150
G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate * 1.2}
G1 E{flush_length_3 * 0.02} F150
G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate * 1.2}
G1 E{flush_length_3 * 0.02} F150
; FLUSH_END
G1 E-[new_retract_length_toolchange] F1800
G1 E[new_retract_length_toolchange] F300
{endif}

{if flush_length_3 > 45 && flush_length_4 > 1}
; WIPE
M400
M106 P1 S178
M400 S2 ;time saver
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
M400
M106 P1 S0
{endif}

{if flush_length_4 > 1}
M106 P1 S60
; FLUSH_START
G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate * 1.2}
G1 E{flush_length_4 * 0.02} F150
G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate * 1.2}
G1 E{flush_length_4 * 0.02} F150
G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate * 1.2}
G1 E{flush_length_4 * 0.02} F150
G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate * 1.2}
G1 E{flush_length_4 * 0.02} F150
G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate * 1.2}
G1 E{flush_length_4 * 0.02} F150
; FLUSH_END
{endif}

M629

M400
M106 P1 S60
M104 S[new_filament_temp] ;time saver
G1 E6 F{new_filament_e_feedrate} ;Compensate for filament spillage during waiting temperature
M400
G92 E0
G1 E-[new_retract_length_toolchange] F1800
M400
M106 P1 S178
M400 S2 ;time saver
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
G1 X-38.2 F18000
G1 X-48.2 F3000
M400
G1 Z{max_layer_z + 3.0} F3000
M106 P1 S0
{if layer_z <= (initial_layer_print_height + 0.001)}
M204 S[initial_layer_acceleration]
{else}
M204 S[default_acceleration]
{endif}
{else}
G1 X[x_after_toolchange] Y[y_after_toolchange] Z[z_after_toolchange] F12000
{endif}

M622.1 S0
M9833 F{outer_wall_volumetric_speed/2.4} A0.3 ; cali dynamic extrusion compensation
M1002 judge_flag filament_need_cali_flag
M622 J1
  M109 S[new_filament_temp] ;make sure temp is correct before calibration
  G92 E0
  G1 E-[new_retract_length_toolchange] F1800
  M400
  
  M106 P1 S255
  M400 S2
  G1 X-38.2 F18000
  G1 X-48.2 F3000
  G1 X-38.2 F18000 ;wipe and shake
  G1 X-48.2 F3000
  G1 X-38.2 F12000 ;wipe and shake
  G1 X-48.2 F3000
  M400
  M106 P1 S0 
M623

M621 S[next_extruder]A
G392 S0

M1007 S1
