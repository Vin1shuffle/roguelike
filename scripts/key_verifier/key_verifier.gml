function leftPressed() {
    return keyboard_check(vk_left);
}

function rightPressed() {
    return keyboard_check(vk_right);
}

function jumpPressed () {
    return keyboard_check_pressed(vk_up);
}

function downPressed() {
    return keyboard_check(vk_down)
}

function isMoving () {
    return rightPressed() - leftPressed() != 0;
}

function dashPressed() {
    return keyboard_check_pressed(vk_space);
}

function isRunning() {
    return keyboard_check(vk_shift);
}