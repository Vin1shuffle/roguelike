#macro LEFT_SIDE "l"
#macro RIGHT_SIDE "r"
#macro UP_SIDE "u"
#macro DOWN_SIDE "d"
#macro ANY_SIDE "a"
#macro ANY_HORIZONTAL_SIDE "ah"
#macro ANY_VERTICAL_SIDE "av"

function isTouching(side, object) {
    switch(side) {
        case LEFT_SIDE:
            return place_meeting(x-1, y, object);
        case RIGHT_SIDE:
            return place_meeting(x+1, y, object);
        case ANY_HORIZONTAL_SIDE:
            return place_meeting(x-1, y, object) or place_meeting(x+1, y, object);
        case UP_SIDE:
            return place_meeting(x, y-1, object);
        case DOWN_SIDE:
            return place_meeting(x, y+1, object);
        case ANY_VERTICAL_SIDE:
            return place_meeting(x, y-1, object) or place_meeting(x, y+1, object);
        case ANY_SIDE:
            return place_meeting(x-1, y, object) or place_meeting(x+1, y, object) or place_meeting(x, y-1, object) or place_meeting(x, y+1, object);
    }
}

function isTouchingWall(side) {
    return isTouching(side, obj_wall);
}

function isTouchingGround() {
    return isTouching(DOWN_SIDE, obj_wall);
}