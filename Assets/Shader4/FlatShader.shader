Shader "Unlit/CubeShader"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
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
			
			#include "UnityCG.cginc"

			struct inputVertex
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct outputVertex
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			float4 _Color;
			
			outputVertex vert (inputVertex v)
			{
				outputVertex o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (outputVertex i) : SV_Target
			{
				return _Color;
			}
			ENDCG
		}
	}
}
