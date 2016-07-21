Shader "CookbookShaders/SnowRabbit" 
{
	Properties 
	{
		_MainColor ("Main Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Bump ("Bump", 2D) = "bump" {}
		_SnowLevel ("Level of Snow", Range(-1.0, 1.0)) = 0.25
		_SnowColor ("Color of Snow", Color) = (1.0, 1.0, 1.0, 1.0)
		_SnowDirection ("Direction of Snow", Vector) = (0, 1, 0, 0)
		_SnowDepth ("Depth of Snow", Range(0, 2)) = 0
		_SnowPuffiness ("Snow Puffiness", Range(0, 1)) = 0.5
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM

		#pragma surface surf Standard vertex:vert
		//#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _Bump;
		float _SnowLevel;
		float4 _SnowColor;
		float4 _MainColor;
		float4 _SnowDirection;
		float _SnowDepth;
		float _SnowPuffiness;

		struct Input 
		{
			float2 uv_MainTex;
			float2 uv_Bump;
			float3 worldNormal;
			INTERNAL_DATA
		};

		void vert (inout appdata_full v)
		{
			// perform vertex modification

			float3 vn = v.normal.xyz;
			// Convert the snow direction to object coordinates
			float3 sn = normalize(mul(_World2Object, float4(_SnowDirection.xyz, 0))).xyz;

			// snowAlignment is the amount that the vertex's normal aligns with the snow direction (-1 means opposite vector, +1 means identical vector)
			float snowAlignment = dot(vn, sn);

			if (snowAlignment >= _SnowLevel)
			{
				// _SnowPuffiness determines how much the vertex is offset by its normal vs the snow fall direction
				float3 vertOffset = lerp(sn, vn, _SnowPuffiness); // normalize(sn + sn + vn);

				// snowFactor determines how much snow this vertex should receive
				float snowFactor = lerp(0, _SnowDepth, snowAlignment * snowAlignment * snowAlignment);

				// vertex displacement calculation
				v.vertex.xyz += vertOffset * snowFactor;
			}
		}

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			half4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump));

			float3 snowDir = normalize(_SnowDirection.xyz);
			float snowAlignment = dot(WorldNormalVector(IN, o.Normal), snowDir);

			if (snowAlignment >= _SnowLevel)
			{
				o.Albedo = _SnowColor.rgb;
			}
			else
			{
				o.Albedo = c.rgb * _MainColor;
			}

			o.Alpha = 1;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
