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

/*
 * This function performs a linear transformation on the diameter of a
 * compartment. Can be used as a crude way to shift and scale the diameter
 * in distance-dependent manner (distance from soma).
 * 
 * The transformation is such that a diameter of A_old becomes A_new, and a
 * diameter of B_old becomes B_new. Other diameters change by the transformation
 * given by the line joining ( A_old, B_old ) and ( A_new, B_new ).
 * 
 * So if your cell has:
 * 		Proximal diameter  :  0.5 um
 * 		Distal diameter    :  0.2 um
 * 
 * but you want:
 * 		Proximal diameter  :  1.5 um
 * 		Distal diameter    :  0.1 um
 * 
 * then give the following values to this function:
 * 		A_old              :  0.5 um
 * 		B_old              :  0.2 um
 * 		A_new              :  1.5 um
 * 		B_new              :  0.1 um
 */
function linear_transform_diameter( path, A_old, B_old, A_new, B_new )
	str path
	float A_old
	float B_old
	float A_new
	float B_new
	
	str c
	float ra, rm, cm
	float ra_s, rm_s, cm_s
	float dia_old
	float dia_new
	float dia_scale
	float len_scale = 1.0
	float RA_scale = 1.0
	float RM_scale = 1.0
	float CM_scale = 1.0
	foreach c ( { el { path }/##[TYPE=compartment] }  )
		dia_old = { getfield { c } dia }
		ra = { getfield { c } Ra }
		rm = { getfield { c } Rm }
		cm = { getfield { c } Cm }
		
		dia_new = { A_new + ( dia_old - A_old ) * ( B_new - A_new ) / ( B_old - A_old ) }
		if ( dia_new <= 0.0 )
			echo
			echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
			echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
			echo "Error in function 'linear_transform_diameter'!"
			echo "Diameter for compartment '"{ c }"' has been transformed from "{ dia_old }" to "{ dia_new }"."
			echo "New diameter cannot be <= 0."
			echo "Parameters:"
			echo "	A_old: "{ A_old }
			echo "	B_old: "{ B_old }
			echo "	A_new: "{ A_new }
			echo "	B_new: "{ B_new }
			echo
			echo "(Aborting...)"
			echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
			echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
			echo
			
			quit
		end
		dia_scale = { dia_new / dia_old }
		
		ra_s = { ra_scale { RA_scale } { dia_scale } { len_scale } }
		rm_s = { rm_scale { RM_scale } { dia_scale } { len_scale } }
		cm_s = { cm_scale { CM_scale } { dia_scale } { len_scale } }
		
		setfield { c } dia { dia_new }
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
