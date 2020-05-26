Shader "Hidden/Custom/Gaussian"
{
    HLSLINCLUDE

        #include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"
		// #include "UnityCG.cginc"

        // TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
        
		sampler2D _MainTex;  
		half4 _MainTex_TexelSize;
		float _BlurSize;

		struct a2v {
			float4 vertex : POSITION;
		};
		  
		struct v2f {
			float4 pos : SV_POSITION;
			half2 uv[5]: TEXCOORD0;
		};
		  
		v2f vertBlurVertical(a2v v) {
			v2f o;
			o.pos = float4(v.vertex.xy, 0.0, 1.0);
			
			float2 uv = TransformTriangleVertexToUV(v.vertex.xy);
#if UNITY_UV_STARTS_AT_TOP
    		uv = uv * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif
			
			o.uv[0] = uv;
			o.uv[1] = uv + float2(0.0, _MainTex_TexelSize.y * 1.0) * _BlurSize;
			o.uv[2] = uv - float2(0.0, _MainTex_TexelSize.y * 1.0) * _BlurSize;
			o.uv[3] = uv + float2(0.0, _MainTex_TexelSize.y * 2.0) * _BlurSize;
			o.uv[4] = uv - float2(0.0, _MainTex_TexelSize.y * 2.0) * _BlurSize;
					 
			return o;
		}
		
		v2f vertBlurHorizontal(a2v v) {
			v2f o;
			o.pos = float4(v.vertex.xy, 0.0, 1.0);
			
			float2 uv = TransformTriangleVertexToUV(v.vertex.xy);
#if UNITY_UV_STARTS_AT_TOP
    		uv = uv * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif
			
			o.uv[0] = uv;
			o.uv[1] = uv + float2(_MainTex_TexelSize.x * 1.0, 0.0) * _BlurSize;
			o.uv[2] = uv - float2(_MainTex_TexelSize.x * 1.0, 0.0) * _BlurSize;
			o.uv[3] = uv + float2(_MainTex_TexelSize.x * 2.0, 0.0) * _BlurSize;
			o.uv[4] = uv - float2(_MainTex_TexelSize.x * 2.0, 0.0) * _BlurSize;
					 
			return o;
		}
		
		float4 fragBlur(v2f i) : SV_Target {
			float weight[3] = {0.4026, 0.2442, 0.0545};
			
			float3 sum = tex2D(_MainTex, i.uv[0]).rgb * weight[0];
			
			for (int it = 1; it < 3; it++) {
				sum += tex2D(_MainTex, i.uv[it*2-1]).rgb * weight[it];
				sum += tex2D(_MainTex, i.uv[it*2]).rgb * weight[it];
			}
			
			return float4(sum, 1.0);
		}

    ENDHLSL

    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            HLSLPROGRAM

                #pragma vertex vertBlurVertical
                #pragma fragment fragBlur

            ENDHLSL
        }

        Pass
        {
            HLSLPROGRAM

                #pragma vertex vertBlurHorizontal
                #pragma fragment fragBlur

            ENDHLSL
        }
    }
}