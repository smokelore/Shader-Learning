Shader "CookbookShaders/NormalExtrusionMap" 
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_ExtrusionTex("Extrusion map", 2D) = "white" {}
		_Amount ("Extrusion Amount", Range(-2,2)) = 0
		_Frequency ("Frequency", Range(0,10)) = 0
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM

		#pragma surface surf Lambert vertex:vert

		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _ExtrusionTex;
		float _Amount;
		float _Frequency;

		struct Input 
		{
			float2 uv_MainTex;
			float3 vertColor;
		};

		void vert (inout appdata_full v, out Input o)
		{
			// perform vertex modification
			UNITY_INITIALIZE_OUTPUT(Input, o);	// compiler was throwing an error without this!
												// "output parameter 'o' not completely initialized (on d3d11)"
			float sineValue = sin(_Time * _Frequency * 10);

			// use tex2Dlod() instead of tex2D() to sample a texture within the vertex modifier.
			float4 tex = tex2Dlod (_ExtrusionTex, float4(v.texcoord.xy, 0, 0));
			float extrusion = tex.r * 2 - 1; 	// equivalent to UnpackNormal()
												// maps a value in the range of (0,1) on the range (-1,1)

			v.vertex.xyz += v.normal * _Amount/10000 * extrusion * sineValue;
		}

		void surf (Input IN, inout SurfaceOutput o) 
		{
			float sineValue = sin(_Time * _Frequency * 10);

			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			float extrusion = abs(c.r * 2 - 1);
			
			o.Albedo = c.rgb;
			o.Alpha = lerp(o.Albedo.rgb, float3(0,0,0), extrusion * _Amount * 100000 * 1.1 * sineValue);
		}
		ENDCG
	}
	FallBack "Diffuse"
}
