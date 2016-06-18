Shader "CookbookShaders/NormalDiffuse" {
	Properties 
	{
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)
		// the "bump" keyword tells Unity that the texture will contain a normal map
		_NormalTex ("Normal Map", 2D) = "bump" {}
		_NormalIntensity ("Normal Intensity", Range(0,1)) = 1
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Lambert

		#pragma target 3.0

		struct Input 
		{
			float2 uv_NormalTex;
		};

		sampler2D _NormalTex;
		float4 _MainTint;
		float _NormalIntensity;

		void surf (Input IN, inout SurfaceOutput o) 
		{
			// Get the normal data out of the normal map texture
			// using the UnpackNormal function
			float3 NormalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex)).rgb;
			NormalMap.x * _NormalIntensity;
			NormalMap.y * _NormalIntensity;

			// Apply the new normal to the lighting model
			o.Normal = NormalMap;

			o.Albedo = _MainTint.rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
