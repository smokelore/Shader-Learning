Shader "CookbookShaders/Radius" 
{
	Properties 
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}	// the terrain's texture

		_Center ("Center", Vector) = (0,0,0,0)
		_Radius ("Radius", Float) = 1
		_RadiusColor ("Radius Color", Color) = (1, 1, 1, 1)
		_RadiusWidth ("Radius Width", Float) = 2
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows

		#pragma target 3.0

		sampler2D _MainTex;
		fixed4 _Color;

		float3 _Center;
		float _Radius;
		fixed4 _RadiusColor;
		float _RadiusWidth;

		struct Input 
		{
			float2 uv_MainTex;	// The UV of the terrain texture
			float3 worldPos;	// The in-world position
		};

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			float d = distance(_Center, IN.worldPos);

			if (d > _Radius && d < _Radius + _RadiusWidth)
			{
				o.Albedo = _RadiusColor;
			}
			else
			{
				o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
			}
		}
		ENDCG
	}
	FallBack "Diffuse"
}
