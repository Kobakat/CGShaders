Shader "Custom/LerpTransparency" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_TransparencyMax("Max Transparency", Range(0,1)) = 0.9
		_TransparencyMin("Min Transparency", Range(0,1)) = 0.1
		_Gradient("Gradient Strength", Range(0.01,1)) = 1
		_Height("Mesh Height", float) = 1.0
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows alpha:blend

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
		};

		half _Glossiness;
		half _Metallic;
		float _TransparencyMin;
		float _TransparencyMax;
		float _Height;
		float _Gradient;

		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)


		void surf (Input IN, inout SurfaceOutputStandard o) {
			
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			
			//Convert world position to local space relative to mesh
			float3 localPos = IN.worldPos - mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz;
			float localY = (localPos.y + (_Height * _Gradient * 0.5));

			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;

			o.Alpha = lerp(_TransparencyMin, _TransparencyMax, localY / _Gradient);
		}
		ENDCG
	}
	FallBack "Diffuse"
}
