## Nombre: Ismael, Apellidos: Sallami Moreno, Titulación: GIADE
## email: ism350zsallami@correo.ugr.es, DNI o pasaporte: 20888108Z

extends Node3D

func _crear_cilindro_y( n : int, dy : float ) -> ArrayMesh :
	
	var pos :  PackedVector3Array = []
	var tri  : PackedInt32Array = []
	
	for i in range(n) :
		var ang_rad : float = (2.0*PI*float(i))/float(n)
		var c : float = cos(ang_rad) 
		var s : float = -sin(ang_rad)
		pos.push_back( Vector3(c,0.0,s))
		pos.push_back( Vector3(c,dy,s))
	
	for i in range(n) :
		var b : int = 2*i
		var m : int = 2*n
		tri.push_back( (b+0) % m ) ; tri.push_back( (b+2) % m ) ; tri.push_back( (b+1) % m )
		tri.push_back( (b+1) % m ) ; tri.push_back( (b+2) % m ) ; tri.push_back( (b+3) % m )
			
	
	## tablas de atributos de v
	var tablas : Array = [] ; tablas.resize( Mesh.ARRAY_MAX ) ## hasta 13 tablas de atributos
	tablas[ Mesh.ARRAY_VERTEX ] = pos
	tablas[ Mesh.ARRAY_INDEX ] = tri
	
	# crear el array mesh en coordenadas maestras, usando las tablas
	var malla_cil := ArrayMesh.new()
	malla_cil.add_surface_from_arrays( Mesh.PRIMITIVE_TRIANGLES, tablas )
	return malla_cil
	
## -----------------------------------------------------------------------------
## Crea un cono de radio 1, con eje el eje Y, desde dy hasta 1 en Y.

func _crear_cono_y( n : int , dy : float ) -> ArrayMesh :
	
	var pos :  PackedVector3Array = []
	var tri  : PackedInt32Array = []
	
	for i in range(n) :
		var ang_rad : float = (2.0*PI*float(i))/float(n)
		pos.push_back( Vector3( cos(ang_rad) ,dy, -sin(ang_rad) ))
		
	pos.push_back( Vector3( 0.0, 1.0, 0.0 )) ## apice en indice 'n'
	
	for i in range(n) :
		tri.push_back( i ) ; tri.push_back( (i+1)%n ) ; tri.push_back( n )

	## tablas de atributos de v
	var tablas : Array = [] ; tablas.resize( Mesh.ARRAY_MAX ) ## hasta 13 tablas de atributos
	tablas[ Mesh.ARRAY_VERTEX ] = pos
	tablas[ Mesh.ARRAY_INDEX ]  = tri
	
	##print("### pos == ", tablas[Mesh.ARRAY_VERTEX])
	##print("### inds == ", tablas[Mesh.ARRAY_INDEX])

	# crear el array mesh en coordenadas maestras, usando las tablas
	var malla_cil := ArrayMesh.new()
	malla_cil.add_surface_from_arrays( Mesh.PRIMITIVE_TRIANGLES, tablas )
	return malla_cil

## -----------------------------------------------------------------------------

func _crear_material_plano( c : Color ) -> StandardMaterial3D :
	
	var m := StandardMaterial3D.new()
	m.albedo_color = c
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED  # ignorar las luces de la escena
	m.cull_mode = BaseMaterial3D.CULL_DISABLED # no hacer cribado de caras traseras
	m.lighting = false  # idem?
	
	return m

## -----------------------------------------------------------------------------

func _crear_mesh_instance( am : ArrayMesh, c : Color ) -> MeshInstance3D : 
	
	var m := MeshInstance3D.new()
	m.mesh = am  
	m.material_override = _crear_material_plano( c )
	m.cast_shadow = GeometryInstance3D.ShadowCastingSetting.SHADOW_CASTING_SETTING_OFF
	return m

## -----------------------------------------------------------------------------

func _init() -> void :
	
	const color_rojo  := Color( 1.0, 0.1, 0.1 )
	const color_verde := Color( 0.2, 1.0, 0.2 )
	const color_azul  := Color( 0.2, 0.8, 1.0 )
	
	var malla_cil : ArrayMesh = _crear_cilindro_y( 32, 0.85 )
	var malla_cono := _crear_cono_y( 32, 0.85 )
	
	## rotaciones para llevar el eje Y a los otros.
	var rotz = Transform3D().rotated( Vector3(0.0,0.0,1.0), -PI/2.0 )
	var rotx = Transform3D().rotated( Vector3(1.0,0.0,0.0), PI/2.0 )

	# ejes cortos (longitud unidad)
	var ex := _crear_mesh_instance( malla_cil, color_rojo )
	var ey := _crear_mesh_instance( malla_cil, color_verde )
	var ez := _crear_mesh_instance( malla_cil, color_azul )
	
	var r : float = 0.016
	var tesc = Transform3D().scaled( Vector3( r,1.0,r  ) )
	ex.transform = rotz*tesc
	ey.transform = tesc 
	ez.transform = rotx*tesc
	
	## añadir hijos
	add_child( ex )
	add_child( ey )
	add_child( ez )
	
	## conos en las puntas de los ejes 'cortos'
	
	var cx := _crear_mesh_instance( malla_cono, color_rojo )
	var cy := _crear_mesh_instance( malla_cono, color_verde )
	var cz := _crear_mesh_instance( malla_cono, color_azul )
	
	var tesc_c = Transform3D().scaled( Vector3( 4.0*r,1.0,4.0*r ) )
	cx.transform = rotz*tesc_c
	cy.transform = tesc_c
	cz.transform = rotx*tesc_c 
	
	add_child( cx )
	add_child( cy )
	add_child( cz )
	
	## ejes 'largos' y finos
	
	## crear instancias del mesh cilindrico
	var ex_l := _crear_mesh_instance( malla_cil, color_rojo )
	var ey_l := _crear_mesh_instance( malla_cil, color_verde )
	var ez_l := _crear_mesh_instance( malla_cil, color_azul )
	
	## definir la transformación de cada instancia
	var rl : float = 0.006
	var l : float = 10.0
	var tras = Transform3D().translated( Vector3( 0.0, -l, 0.0 ))
	var esca = Transform3D().scaled( Vector3( rl,2.0*l,rl  ) )
	
	ex_l.transform = rotz*tras*esca
	ey_l.transform = tras*esca
	ez_l.transform = rotx*tras*esca

	## añadir hijos
	add_child( ex_l )
	add_child( ey_l )
	add_child( ez_l ) 
