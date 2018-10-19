Shader "ChromaKey/Unlit/TransparentShadow"
{

Properties
{
	[Header(Material)]
    _MainTex("Texture", 2D) = "white" {}
	[Enum(UnityEngine.Rendering.CullMode)] _Cull("Culling", Int) = 2
	[Enum(UnityEngine.Rendering.BlendMode)] _BlendSrc("Blend Src", Float) = 5 
	[Enum(UnityEngine.Rendering.BlendMode)] _BlendDst("Blend Dst", Float) = 10
	[Toggle][KeyEnum(Off, On)] _ZWrite("ZWrite", Float) = 1

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
	"Queue" = "Transparent"
	"RenderType" = "Transparent" 
    "IgnoreProjector" = "True" 
    "PreviewType" = "Plane"
}

CGINCLUDE

#include "UnityCG.cginc"
#include "./ChromaKey.cginc"

struct appdata
{
    float4 vertex : POSITION;
	float3 normal : NORMAL;
    float2 uv : TEXCOORD0;
};

struct v2f
{
	V2F_SHADOW_CASTER;
	float2 uv : TEXCOORD1;
};

sampler2D _MainTex;
float4 _MainTex_ST;

v2f vert(appdata v)
{
    v2f o;
	TRANSFER_SHADOW_CASTER_NORMALOFFSET(o);
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    return o;
}

float4 frag(v2f i) : SV_Target
{
    float4 col = tex2D(_MainTex, i.uv);
	ChromaKeyApplyCutout(col);
	SHADOW_CASTER_FRAGMENT(i);
}

ENDCG

UsePass "ChromaKey/Unlit/Transparent/ForwardBase"

Pass
{
	Name "ShadowCaster"
	Tags { "LightMode" = "ShadowCaster" }
	ZWrite On 
	ZTest LEqual 
	Cull Off

	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#pragma multi_compilecaster
	ENDCG
}

}

Fallback "Unlit/Texture"

}
