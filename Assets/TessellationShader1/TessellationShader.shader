Shader "Tessellation/tessellation1"
{
	Properties{
		_TessEdge("TessEdge",Range(1,62)) = 2
	}
	SubShader{
		Pass{
			CGPROGRAM
			#pragma target 5.0

			#pragma vertex vert
			#pragma fragment frag
			#pragma hull hs
			#pragma domain ds

			#pragma enable_d3d11_debug_symbols

			//#include "UnityCG.cginc"

			float _TessEdge;

			// STRUCTS
			struct VS_INPUT{
				float3 pos : POSITION;
			};

			struct HS_INPUT{
				float4 pos : POS;
			};

			struct HS_CONSTANT_OUTPUT{
				float edges[3]    : SV_TessFactor;
				float inside[1] : SV_InsideTessFactor;
			};

			struct HS_CONTROLPOINT_OUTPUT{
				float3 pos : POS;
			};

			struct DS_OUTPUT{
				float4 pos : SV_Position;
			};

			struct FS_INPUT {
				float4 pos : SV_Position;
			};

			struct FS_Output
    		{		
        		fixed4 color : SV_Target0;
    		};     

			// PIPELINE STAGES
			HS_INPUT vert(VS_INPUT v){
				HS_INPUT o;
				o.pos = float4(v.pos,1);
				return o;
			}

			HS_CONSTANT_OUTPUT hs_constant(InputPatch<HS_INPUT, 3> ip, uint pid : SV_PrimitiveID){
				HS_CONSTANT_OUTPUT output;

				 output.edges[0] = _TessEdge;
				 output.edges[1] = _TessEdge;
				 output.edges[2] = _TessEdge;

				 output.inside[0] = _TessEdge;

				 return output;
			}

			[domain("tri")]
    		[partitioning("integer")]
    		[outputtopology("triangle_cw")]
    		[patchconstantfunc("hs_constant")]
    		[outputcontrolpoints(3)]
			HS_CONTROLPOINT_OUTPUT hs(InputPatch<HS_INPUT,3> input, uint uCPID : SV_OutputControlPointID){
				HS_CONTROLPOINT_OUTPUT o = (HS_CONTROLPOINT_OUTPUT)0;
				o.pos = input[uCPID].pos.xyz;
				return o;
			}

			[domain("tri")]
			DS_OUTPUT ds(HS_CONSTANT_OUTPUT i, const OutputPatch<HS_CONTROLPOINT_OUTPUT,3> input, float3 BarycentricCoords : SV_DomainLocation){
				DS_OUTPUT o = (DS_OUTPUT)0;

				float fU = BarycentricCoords.x;
				float fV = BarycentricCoords.y;
				float fW = BarycentricCoords.z;

				float3 pos = fU * input[0].pos + fV * input[1].pos + fW * input[2].pos;

				o.pos = UnityObjectToClipPos(float4(pos,1.0));

				return o;

			}

			FS_Output frag( FS_INPUT I )
    		{
        		FS_Output Output;
       			Output.color = fixed4(1, 0, 0, 1);
       			return Output;
    		}

			ENDCG
		}
	}
}