// autor: Leonardo de Abreu Schmidt

void SubdivideTriangles(float3 v1, float3 v2, float3 v3, int deep){
	if(deep==0){
		return;
	}else{
		float3 posmed = (v1+v2+v3)/3.0;
		SubdivideTriangles(v1,v2,posmed,deep-1);
		SubdivideTriangles(v2,v3,posmed,deep-1);
		SubdivideTriangles(v3,v1,posmed,deep-1);
	}
}