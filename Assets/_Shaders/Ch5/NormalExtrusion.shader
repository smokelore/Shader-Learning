Shader "CookbookShaders/Ch05/NormalExtrusion" 
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
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

			v.vertex.xyz += v.normal * _Amount/10000 * sineValue;
		}

		void surf (Input IN, inout SurfaceOutput o) 
		{
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
