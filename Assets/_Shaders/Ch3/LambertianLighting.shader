Shader "CookbookShaders/SimpleLambert" 
{
	Properties 
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Instead of Standard, use a custom lighting model
		#pragma surface surf SimpleLambert

		#pragma target 3.0

		sampler2D _MainTex;

		struct Input 
		{
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
		}

		half4 LightingSimpleLambert (SurfaceOutput s, half3 lightDir, half atten)
		{
			half NdotL = dot(s.Normal, lightDir);
			half4 c;
			// _LightColor0 variable contains the color of the light that is calculated
			c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten * 1);
			c.a = s.Alpha;

			return c;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
