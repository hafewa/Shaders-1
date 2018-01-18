// autor: Leonardo de Abreu Schmidt

// funções para manipulação de vetores

// calcula a normal da face de um triangulo passando-se 3 vertices
float3 CalculateNormalFromTriangle(float3 v0, float3 v1, float3 v2){
	float3 sideA = v1 - v0;
	float3 sideB = v2 - v0;
	float3 norm = normalize(cross(sideA,sideB));
	return norm;
}

// calcula a distância entre dois pontos
float DistanceBetweenPoints(float3 p1, float3 p2){
	return sqrt(pow(p2.x-p1.x,2)+pow(p2.y-p1.y,2)+pow(p2.z-p1.z,2));
}

// retorna o vetor normalizado gerado por dois pontos
float3 GetVector(float3 p1, float3 p2){
	float3 v = p2-p1;
	return normalize(v);
}