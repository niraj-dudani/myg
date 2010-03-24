float pi = 3.14159265359

function sa( diameter, length )
	float diameter
	float length
	
	return { pi * diameter * length }
end

function ca( diameter )
	float diameter
	
	return { pi * diameter * diameter / 4.0 }
end

function ra( RA, diameter, length )
	float RA
	float diameter
	float length
	float cross = { ca { diameter } }
	
	return { RA * length / cross }
end

function rm( RM, diameter, length )
	float RM
	float diameter
	float length
	float surface = { sa { diameter } { length } }
	
	return { RM / surface }
end

function cm( CM, diameter, length )
	float CM
	float diameter
	float length
	float surface = { sa { diameter } { length } }
	
	return { CM * surface }
end

function sa_scale( dia_scale, len_scale )
	float dia_scale
	float len_scale
	
	return { dia_scale * len_scale }
end

function ca_scale( dia_scale )
	float dia_scale
	
	return { dia_scale * dia_scale }
end

function ra_scale( RA_scale, dia_scale, len_scale )
	float RA_scale
	float dia_scale
	float len_scale
	float cross_scale = { ca_scale { dia_scale } }
	
	return { RA_scale * len_scale / cross_scale }
end

function rm_scale( RM_scale, dia_scale, len_scale )
	float RM_scale
	float dia_scale
	float len_scale
	float surface_scale = { sa_scale { dia_scale } { len_scale } }
	
	return { RM_scale / surface_scale }
end

function cm_scale( CM_scale, dia_scale, len_scale )
	float CM_scale
	float dia_scale
	float len_scale
	float surface_scale = { sa_scale { dia_scale } { len_scale } }
	
	return { CM_scale * surface_scale }
end

function scale_passive( path, RA_scale, RM_scale, CM_scale, dia_scale, len_scale )
	str path
	float RA_scale
	float RM_scale
	float CM_scale
	float dia_scale
	float len_scale
	
	str c
	float ra, rm, cm
	float ra_s, rm_s, cm_s
	float dia, len
	foreach c ( { el { path }/##[TYPE=compartment] }  )
		dia = { getfield { c } dia }
		len = { getfield { c } len }
		ra = { getfield { c } Ra }
		rm = { getfield { c } Rm }
		cm = { getfield { c } Cm }
		
		ra_s = { ra_scale { RA_scale } { dia_scale } { len_scale } }
		rm_s = { rm_scale { RM_scale } { dia_scale } { len_scale } }
		cm_s = { cm_scale { CM_scale } { dia_scale } { len_scale } }
		
		setfield { c } dia { dia * dia_scale }
		setfield { c } len { len * len_scale }
		setfield { c } Ra { ra * ra_s }
		setfield { c } Rm { rm * rm_s }
		setfield { c } Cm { cm * cm_s }
	end
end

function scale_channel( path, channel, g_scale, dia_scale, len_scale )
	str path
	str channel
	float g_scale
	float dia_scale
	float len_scale
	
	str c
	str chan
	float g
	float dia, len
	float scale
	foreach c ( { el { path }/##[TYPE=compartment] }  )
		dia = { getfield { c } dia }
		len = { getfield { c } len }
		
		if ( { strcmp { channel } "##" } == 0 )
			foreach chan ( { el { c }/##[TYPE=tabchannel] }  )
				g = { getfield { chan } Gbar }
				scale = { g_scale } * { sa_scale { dia_scale } { len_scale } }
				setfield { chan } Gbar { g * scale }
			end
		else
			foreach chan ( { el { c }/{ channel } }  )
				g = { getfield { chan } Gbar }
				scale = { g_scale } * { sa_scale { dia_scale } { len_scale } }
				setfield { chan } Gbar { g * scale }
			end
		end
	end
end
