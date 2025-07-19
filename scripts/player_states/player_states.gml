#macro LEFT_SIDE "l"
#macro RIGHT_SIDE "r"
#macro ANY_SIDE "a"
var crouch = false;
//COLISAO PAREDE E CHAO
function isGround() {
	return place_meeting(x, y+1, obj_wall);
}

function player_state_move() {
	//FUNCOES E MOVIMENTO
	var key_left=keyboard_check(vk_left);
	var key_right=keyboard_check(vk_right);
	var key_jump=keyboard_check(vk_up);              
	var move=key_right-key_left!=0;
	var key_dash=keyboard_check(vk_space);
	var key_run=keyboard_check(vk_shift);
	var key_down=keyboard_check(vk_down);
	//AGACHAR
	verifyCrouch()
    //GRAVIDADE
    vspd += grv;
    vspd = clamp(vspd, vspd_min, vspd_max);
	handleMovement()

    //WALL SLIDE
    var max_slide = 1;
    if (isTouchingWall(ANY_SIDE) and !isGround) {
        if (vspd > max_slide) vspd = max_slide;
    }

    //WALL JUMP
    if (isTouchingWall(ANY_SIDE) and !isGround and key_jump) {
        coyote_time = 0;
        vspd=-sqrt(2 * grv * jump_height);
		
		var boost=0;
		if(key_run){
			boost=jmp_boost;
		}

        if (touchL  and key_right){
			hspd=move_spd_run+boost;
			}else if (touchR  and key_left ){
				hspd=move_spd_run-boost;
			}
        
        sprite_index = spr_volodar_jump;
    }
    //PULO NORMAL
	if (isGround) {
        coyote_time = coyote_time_max;
    } else {
        coyote_time--;
    }
    if (key_jump and coyote_time > 0) {
        vspd= -sqrt(2 * grv * jump_height);
		coyote_time=0;
		sprite_index = spr_volodar_jump;
	//PULO BOOST	
		if (move) {
        if (key_run) {
            hspd += jmp_boost * 1.2 * sign(hspd);
        } else {
            hspd += jmp_boost * 0.5 * sign(hspd);
        }
    }
}
	//ANIMAÇÕES
	if (!isGround) {
	    if (vspd < 0) {
	        sprite_index = spr_volodar_jump;
	    } else {
	        sprite_index = spr_volodar_fall;
	    }
	} else if (crouch) {
	    if (abs(hspd) > 0.1) {
	        sprite_index = spr_volodar_c_walk;
	    } else {
	        sprite_index = spr_volodar_crouch;
	    }
	} else {
	    if (abs(hspd) > 0.1) {
	        if (key_run) {
	            sprite_index = spr_volodar_run;
	        } else {
	            sprite_index = spr_volodar_walk;
	        }
	    } else {
	        sprite_index = spr_volodar;
	    }
	}

	//DASH
	if(key_dash and dash){
		hspd=0;
		vspd=0;
		dash_time=0;
		dash=false;
		alarm[0] = dash_delay;
		state=player_state_dash;
	}
}

function verifyCrouch() {
	var key_down=keyboard_check(vk_down);
	if(isGround and key_down){
		crouch=true;
		move_spd_max=move_spd_crouch
		show_debug_message(move_spd_max)
		if(move_spd >move_spd_max)approach(move_spd, 2, dcc);
	}else{
		move_spd_max=move_spd_walk
		crouch=false;
	}
}

function handleMovement() {
	var key_left=keyboard_check(vk_left);
	var key_right=keyboard_check(vk_right);
	var move=key_right-key_left!=0;
	var key_run=keyboard_check(vk_shift);
	//VELOCIDADE
	if (isGround and key_run and move){
		move_spd_max=move_spd_run
	}else if (keyboard_check_released(vk_shift)){
		move_spd_max=move_spd_walk
	}

    //MOVIMENTO
    if (move) {
        sprite_index = spr_volodar_walk;
        move_dir= point_direction(0,0, key_right - key_left, 0);
        move_spd= approach(move_spd, move_spd_max, dcc);
    } else {
        sprite_index = spr_volodar;
        move_spd = approach(move_spd, 0, dcc);
    }
    hspd = lengthdir_x(move_spd, move_dir);

    //VIRA O SPRITE
    if (hspd != 0) {
        image_xscale = sign(hspd);
    }
}

function player_state_dash() {
	sprite_index=spr_volodar_dash;
	hspd=lengthdir_x(dash_force,move_dir);
	dash_time=approach(dash_time,dash_distance,1);
	if(dash_time mod 2==0){
		rastro=instance_create_layer(x,y,layer,obj_dash_rastro);
		rastro.sprite_index=spr_dash_rastro;
		rastro.image_index=image_index;
		rastro.image_xscale=image_xscale;
		rastro.image_yscale=image_yscale;
		rastro.image_alpha=0.5;
		rastro.spd=0.1;
		rastro.rastro=20;
	}
	if(dash_time >= dash_distance){
		state=player_state_move
	}
}

function isTouchingWall(side) {
	switch (side) {
	    case LEFT_SIDE:
	        return place_meeting(x-1, y, obj_wall);
		case RIGHT_SIDE:
			return place_meeting(x+1, y, obj_wall);
	    default:
	        return place_meeting(x-1, y, obj_wall) or place_meeting(x+1, y, obj_wall);
	}
}