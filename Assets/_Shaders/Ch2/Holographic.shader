Shader "CookbookShaders/HolographicShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_DotProduct ("Rim Effect", Range(-1, 1)) = 0.25
	}
	SubShader {
		Tags 
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType"="Transparent" 
		}
		LOD 200

		Cull Off
		
		CGPROGRAM

		// Lambert cheap lighting model (this is not a realistic material).
		// Signal to Cg that this is a transparent shader with alpha:fade.
		#pragma surface surf Lambert alpha:fade

		#pragma target 3.0

		fixed4 _Color;
		sampler2D _MainTex;
		float _DotProduct;

		// New Input struct variables!
		struct Input {
			float2 uv_MainTex;
			float3 worldNormal;
			float3 viewDir;
		};

		// Since we're using Lambertian reflectance, use SurfaceOutput (not SurfaceOutputStandard).
		void surf (Input IN, inout SurfaceOutput o) {
			float4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;

			// Using the dot product, we can determine how close to 
			// orthogonal the view direction and the surface's normal is at this point.
			float border = 1 - (abs(dot(IN.viewDir, IN.worldNormal)));
			// Interpolate the alpha near the edge of the model using its orthogonality.
			// This gives a gentle fade to transparency rather than a sharp cutoff.
			float alpha = (border * (1 - _DotProduct) + _DotProduct);
			o.Alpha = c.a * alpha;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
