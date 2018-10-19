Shader "ChromaKey/Standard/Cutout" 
{

Properties 
{
	[Header(Material)]
	_Color ("Color", Color) = (1, 1, 1, 1)
	_MainTex ("Albedo (RGB)", 2D) = "white" {}
	_Glossiness ("Smoothness", Range(0, 1)) = 0.5
	_Metallic ("Metallic", Range(0, 1)) = 0.0

	[Header(Chroma Key)]
	_ChromaKeyColor("Color", Color) = (0.0, 0.0, 1.0, 0.0)
	_ChromaKeyHueRange("Hue Range", Range(0, 1)) = 0.1
	_ChromaKeySaturationRange("Saturation Range", Range(0, 1)) = 0.5
	_ChromaKeyBrightnessRange("Brightness Range", Range(0, 1)) = 0.5
}

SubShader 
{

Tags 
{ 
	"RenderType" = "Opaque" 
    "PreviewType" = "Plane"
}

CGPROGRAM

#pragma surface surf Standard addshadow fullforwardshadows
#pragma target 3.0

#include "./ChromaKey.cginc"

sampler2D _MainTex;

struct Input 
{
	float2 uv_MainTex;
};

half _Glossiness;
half _Metallic;
fixed4 _Color;

void surf(Input IN, inout SurfaceOutputStandard o) 
{
	fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
	ChromaKeyApplyCutout(c);
	o.Albedo = c.rgb;
	o.Metallic = _Metallic;
	o.Smoothness = _Glossiness;
	o.Alpha = c.a;
}

ENDCG

}

FallBack "Diffuse"

}
