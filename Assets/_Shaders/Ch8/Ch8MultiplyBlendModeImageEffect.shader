Shader "CookbookShaders/Ch08/Blend Mode/MultiplyImageEffect.shader"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BlendTex ("Blend Texture", 2D) = "white" {}
		_BlendOpacity ("Blend Opacity", Range(0, 1)) = 1
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"

			// declare corresponding CGPROGRAM variables
			uniform sampler2D _MainTex;
			uniform sampler2D _BlendTex;
			fixed _BlendOpacity;

			fixed4 frag(v2f_img i) : COLOR
			{
				// Get the colors from the RenderTexture and the UVs from the v2f_img struct
				fixed4 renderTex = tex2D(_MainTex, i.uv);
				fixed4 blendTex = tex2D(_BlendTex, i.uv);

				// perform Multiply blend mode
				fixed4 blendedTex = renderTex * blendTex;

				// lerp between no blending and full blending
				renderTex = lerp(renderTex, blendedTex, _BlendOpacity);
	
				return renderTex;
			}

			ENDCG
		}
	}
}
