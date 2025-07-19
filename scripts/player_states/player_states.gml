function playerStateMove() {
    //AGACHAR
    verifyCrouching();
    //GRAVIDADE
    calculateGravity();
    //MOVIMENTO
    move();
    
    //WALL SLIDE
    var max_slide = 1;
    if (isTouchingWall(ANY_HORIZONTAL_SIDE) and !isTouchingGround()) {
        if (vspd > max_slide) vspd = max_slide;
    }
    
    //WALL JUMP
    if (isTouchingWall(ANY_HORIZONTAL_SIDE) and !isTouchingGround() and jumpPressed()) {
        coyote_time = 0;
        vspd=-sqrt(2 * grv * jump_height);
        
        var boost=0;
        if(isRunning()){
            boost=jmp_boost;
        }
        
        if (isTouchingWall(LEFT_SIDE)  and rightPressed()) {
            hspd+=move_spd_run+boost;
        } else if (isTouchingWall(RIGHT_SIDE)  and leftPressed()) {
            hspd+=move_spd_run-boost;
        }
        
        sprite_index = spr_volodar_walk;
        
    }
    
    if (isTouchingGround()) {
        coyote_time = coyote_time_max;
    } else {
        coyote_time--;
    }
    
    //PULO NORMAL
    if (jumpPressed() and coyote_time > 0) {
        vspd= -sqrt(2 * grv * jump_height);
        coyote_time=0;
        sprite_index = spr_volodar_jump;
        //PULO BOOST	
        if (isMoving()) {
            if (isRunning()) {
                hspd += jmp_boost * 1.2 * sign(hspd);
            } else {
                hspd += jmp_boost * 0.5 * sign(hspd);
            }
        }
    }
    //ANIMAÇÕES
    if (!isTouchingGround()) {
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
            if (isRunning()) {
                sprite_index = spr_volodar_run;
            } else {
                sprite_index = spr_volodar_walk;
            }
        } else {
            sprite_index = spr_volodar;
        }
    }
    
    //DASH
    if(dashPressed() and dash){
        hspd=0;
        vspd=0;
        dash_time=0;
        dash=false;
        alarm[0] = dash_delay;
        state=player_state_dash;
    }
}

function player_state_dash() {
    sprite_index = spr_volodar_dash;
    hspd = lengthdir_x(dash_force, move_dir);
    dash_time = approach(dash_time, dash_distance,1);
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
        state=playerStateMove
    }
}

function verifyCrouching() {
    if (isTouchingGround() and downPressed()) {
        crouch = true;
        move_spd_max = move_spd_crouch
        if (move_spd > move_spd_max) approach(move_spd, 2, dcc);
    } else {
        move_spd_max = move_spd_walk;
        crouch = false;
    }
}

function calculateGravity() {
    vspd += grv;
    vspd = clamp(vspd, vspd_min, vspd_max);
}

function move() {
    calculateSpeed()
    //MOVIMENTO
    if (isMoving()) {
        sprite_index = spr_volodar_walk;
        move_dir = point_direction(0, 0, rightPressed() - leftPressed(), 0);
        move_spd = approach(move_spd, move_spd_max, dcc);
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

function calculateSpeed() {
    if (isTouchingGround() and isRunning() and isMoving()) {
        move_spd_max = move_spd_run
    }else if (keyboard_check_released(vk_shift)) {
        move_spd_max = move_spd_walk
    }
}