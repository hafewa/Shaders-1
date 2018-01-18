// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/PlaneShader"
{
	Properties{
		_Texture ("Texture",2D) = "White" {}
		_Texture1 ("Texture1",2D) = "White" {}
		_Tween ("Tween", Range(0,1)) = 0
	}
	SubShader
	{
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			float _Tween;
			sampler2D _Texture;
			sampler2D _Texture1;
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 sand = tex2D(_Texture,i.uv);
				fixed4 water = tex2D(_Texture1,i.uv);
				float4 col = (1,1,1,_Tween);
				float4 col1 = (1,1,1,1-_Tween);
				return water*col + sand*col1;
			}
			ENDCG
		}
	}
}