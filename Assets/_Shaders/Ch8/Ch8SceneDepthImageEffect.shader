Shader "CookbookShaders/Ch08/SceneDepthImageEffect.shader"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_DepthPower ("Depth Power", Range(1, 5)) = 1
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
			fixed _DepthPower;
			sampler2D _CameraDepthTexture;	// this is a built-in Unity variable provided by the UnityCG cginclude file

			fixed4 frag(v2f_img i) : COLOR
			{
				// Get the depth information from the DepthTexture and the UVs from the v2f_img struct
				fixed4 depthTex = tex2D(_CameraDepthTexture, i.uv.xy);

				float d = UNITY_SAMPLE_DEPTH(depthTex);		// produces a single float depth value for each pixel
				d = Linear01Depth(d);						// makes sure our values are within the 0-1 range 
				d = pow(Linear01Depth(d), _DepthPower);		// takes the final depth to a power that we can control

				return d;
			}

			ENDCG
		}
	}
}
