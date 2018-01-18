Shader "Unlit/GeometryShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Factor ("Factor",Range(0,20)) = 1
		_Color ("Color",Color) = (1,1,1,1)
		_LightPos("LightPos",Vector) = (0,0,0,0)
		_Atten("Atten",Range(0,20)) = 1.0
		_Distance("Distance",Range(0,10)) = 1.0
		_PersonPos("PersonPos",Vector) = (0.0,0.0,0.0,0.0)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma geometry geom
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			#include "Vectoring.cginc"
			#include "Tesselation.cginc"

			struct v2g
			{
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				float4 vertex : POSITION;
			};

			struct g2f
			{
				float2 uv : TEXCOORD0;
				float4 col : COLOR;
				float4 pos : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Factor;
			float4 _LightPos;
			float4 _Color;
			float _Atten;
			float4 _PersonPos;
			float _Distance;

			v2g vert (appdata_base v)
			{
				v2g o;
				o.vertex = v.vertex;
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.normal = v.normal;
				return o;
			}

			[maxvertexcount(12)]
			void geom(triangle v2g IN[3], inout TriangleStream<g2f> stream){

				float3 lightDirection = normalize(_LightPos.xyz);

				float3 norm = CalculateNormalFromTriangle(IN[0].vertex,IN[1].vertex,IN[2].vertex);

				float3 plus = norm*_Factor;

				float3 difuseReflection = max(0.0,dot(norm,lightDirection));

				float3 posmed = (IN[0].vertex+IN[1].vertex+IN[2].vertex)/3.0;
				float2 texmed = (IN[0].uv+IN[1].uv+IN[2].uv)/3.0;

				float3 posp = posmed+plus;
				_PersonPos.y = posp.y;
				if(DistanceBetweenPoints(posp,_PersonPos.xyz)<_Distance){
					float3 v = GetVector(_PersonPos.xyz,posp);
					posmed+=v;
				}

				g2f o;

				for(int i=0;i<3;i++){
					float4 v0 = IN[i].vertex;
					int inext = (i+1)%3;
					float4 v1 = IN[inext].vertex;
					float4 v2 = float4(posmed+plus,1.0);

					float3 normalface = CalculateNormalFromTriangle(v0,v1,v2);
					difuseReflection = max(0.0,dot(normalface,lightDirection));

					o.pos = UnityObjectToClipPos(v0);
					o.uv = IN[i].uv;
					o.col = _Color * _Atten * float4(difuseReflection,1.0);
					stream.Append(o);

					o.pos = UnityObjectToClipPos(v1);
					o.uv = IN[inext].uv;
					o.col = _Color * _Atten * float4(difuseReflection,1.0);
					stream.Append(o);

					o.pos = UnityObjectToClipPos(v2);
					o.uv = texmed;
					o.col = _Color * _Atten * float4(difuseReflection,1.0);
					stream.Append(o);

					stream.RestartStrip();
				}
			}

			fixed4 frag (g2f i) : SV_Target
			{
				float4 col = i.col;//*tex2D(_MainTex,i.uv)*;
				// sample the texture
				// apply fog
				return col;
			}
			ENDCG
		}
	}
}
