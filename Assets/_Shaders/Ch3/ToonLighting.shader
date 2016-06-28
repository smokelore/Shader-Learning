Shader "CookbookShaders/ToonLighting" 
{
	Properties 
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_RampTex ("Ramp", 2D) = "white" {}
		_CelShadingLevels ("Cel Shading Levels", Range(0,15)) = 5
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Instead of Standard, point to a function called LightingToon()
		#pragma surface surf Toon

		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _RampTex;
		float _CelShadingLevels;

		struct Input 
		{
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
		}

		half4 LightingToon (SurfaceOutput s, half3 lightDir, half atten)
		{
			half NdotL = dot(s.Normal, lightDir);
			// Snap the lighting level
			half cel = floor(NdotL * _CelShadingLevels) / (_CelShadingLevels - 0.5);

			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * (cel * atten * 1);
			c.a = s.Alpha;

			return c;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
