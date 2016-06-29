Shader "CookbookShaders/PhongSpecular" 
{
	Properties 
	{
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SpecularColor ("Specular Color", Color) = (1,1,1,1)
		_SpecPower ("Specular Power", Range(0,30)) = 1
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Instead of Standard, use a custom lighting model
		#pragma surface surf Phong

		#pragma target 3.0

		float4 _MainTint;
		sampler2D _MainTex;
		float4 _SpecularColor;
		float _SpecPower;

		struct Input 
		{
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
		}

		// View-dependent lighting function
		fixed4 LightingPhong (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			half NdotL = dot(s.Normal, lightDir);

			// Reflection
			float3 reflectionVector = normalize(2.0 * s.Normal * NdotL - lightDir);

			// Specular
			float spec = pow(max(0, dot(reflectionVector, viewDir)), _SpecPower);
			float3 finalSpec = _SpecularColor.rgb * spec;

			// Final effect
			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * max(0, NdotL) * atten) + (_LightColor0.rgb * finalSpec);
			c.a = s.Alpha;

			return c;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
