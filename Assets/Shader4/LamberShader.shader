// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Light/Lambert"{
	Properties{
		_Color ("Color",Color) = (1,1,1,1)
		_LightPos("LightPos",Vector) = (0,0,0,0)
		_Atten("Atten",float) = 1.0
	}
	Subshader{
		Pass{
			Tags{"LightMode" = "forwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			//user defined variables
			uniform float4 _Color;
			uniform float4 _LightPos;
			uniform float _Atten;

			//unity defined variables
			uniform float4 _LightColor0;
			//float4x4 _World2Object;
			//float4x4 _Object2World;
			//float4 _WorldSpaceLightPos0;

			struct vertexInput{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct vertexOutput{
				float4 pos : SV_POSITION;
				float4 col : COLOR;
			};

			vertexOutput vert(vertexInput v){
				vertexOutput o;
				float3 normalDirection = normalize(mul(float4(v.normal,1.0),unity_WorldToObject).xyz);
				float3 lightDirection = normalize(_LightPos.xyz);
				float3 difuseReflection =  _Atten * _LightColor0.xyz * _Color.rgb * max(0.0,dot(normalDirection,lightDirection));
				o.col = float4(difuseReflection,1.0);
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}

			float4 frag(vertexOutput i) : COLOR{
				return i.col;
			}

			ENDCG
		}

	}

}