Shader "Unlit/GeometryShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Factor ("Factor",float) = 0.0
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
				
				float3 sideA = IN[1].vertex - IN[0].vertex;
				float3 sideB = IN[2].vertex - IN[0].vertex;
				float3 norm = normalize(cross(sideA,sideB));
				float4 plus = float4(norm,0.0)*_Factor;

				g2f o;

				for(int i=0;i<3;i++){
					o.pos = UnityObjectToClipPos(IN[i].vertex+plus);
					o.uv = IN[i].uv;
					o.col = (1.0,0.0,0.0,1.0);
					stream.Append(o);
				}
				stream.RestartStrip();

				for(int i=0;i<3;i++){
					o.pos = UnityObjectToClipPos(IN[i].vertex);
					o.uv = IN[i].uv;
					o.col = (1.0,0.0,0.0,1.0);
					stream.Append(o);
				}
                stream.RestartStrip();
			}

			fixed4 frag (g2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
