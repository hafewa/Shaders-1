Shader "Mesh/TerrainShader" {
	Properties{
		_MountainColor("MountainColor",Color) = (1.0,0.0,0.0,1.0)
		_RiverColor("RiverColor",Color) = (0.0,0.0,1.0,1.0)
		_Intensity("Intensity",float) = 1.0
		_LightPos("LightPos",Vector)  = (0.0,0.0,0.0,0.0)
		_MaxHeight("MaxHeight",Range(1.0,500.0)) = 1.0
	}
	SubShader{
	Cull off
		Pass{
			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag

			uniform float4 _MountainColor;
			uniform float4 _RiverColor;
			uniform float _Intensity;
			uniform float4 _LightPos;
			uniform float _MaxHeight;

			struct data {
				float3 pos;
				float3 normal;
			};

			uniform StructuredBuffer<data> buffer;

			struct vertexOutput{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
				float4 col : COLOR;
			};

			vertexOutput vert(uint id : SV_VertexID){
				vertexOutput o;
				float4 pos = float4(buffer[id].pos,1);
				o.pos = UnityObjectToClipPos(pos);
				float3 lightDirection = normalize(_LightPos.xyz);
				float diff = max(0.0,dot(normalize(buffer[id].normal),lightDirection));
				if(pos.y<5){
					o.col = _RiverColor*diff;
				}else{
					o.col = _MountainColor*diff;
				}

				return o;
			}

			float4 frag(vertexOutput i) : COLOR {
				return i.col;
			}

			ENDCG
		}
	}

}