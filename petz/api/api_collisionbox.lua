local modpath, S = ...

petz.get_collisionbox = function(p1, p2, scale_model, scale_baby)
	p1 = vector.multiply(p1, scale_model)
	p2 = vector.multiply(p2, scale_model)
	local collisionbox = {p1.x, p1.y, p1.z, p2.x, p2.y, p2.z}
	local collisionbox_baby
	if scale_baby then
		p1b = vector.multiply(p1, scale_baby)
		p2b = vector.multiply(p2, scale_baby)
		collisionbox_baby = {p1.x, p1.y, p1.z, p2.x, p2.y, p2.z}	
	end	
	return collisionbox, collisionbox_baby
end
