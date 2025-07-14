camera_set_view_size(view_camera[VIEW],VIEW_LARG, VIEW_ALT);

if(instance_exists(global.view_target)){
	var x_to=global.view_target.x-VIEW_LARG/2;
	var y_to=global.view_target.y-VIEW_ALT/2;
	
	x_to=clamp(x_to,0,room_width-VIEW_LARG);
	y_to=clamp(y_to,0,room_height-VIEW_ALT);
	
	var c_x=camera_get_view_x(view_camera[VIEW]);
	var c_y=camera_get_view_y(view_camera[VIEW]);
	var n_x=lerp(c_x,x_to,VIEW_SPEED);
	var n_y=lerp(c_y,y_to,VIEW_SPEED);
	
	camera_set_view_pos(view_camera[VIEW],n_x,n_y);
}