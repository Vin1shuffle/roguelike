#macro MAX_SPD 4.0
#macro JUMP_HEIGHT 4.0
hspd=0;
vspd=0;
vspd_max=10;
vspd_min=-20;
grv=1.0;

//MOVE
can_move=0;
move_dir=0;
move_spd=0;
move_spd_max=MAX_SPD;
move_spd_run=7.0;
move_spd_walk=4.0;
acc=1.0;
dcc=1.0;
crouch=false;
move_spd_crouch=2.0;
//JUMP
jump_height=JUMP_HEIGHT;
coyote_time_max=10;
coyote_time=0;
walljump_grace = 0;
jmp_boost=6;
//DASH
dash_force=8;
dash_time=0;
dash_distance=15;
dash=true;
dash_delay=60;

state=player_state_move;