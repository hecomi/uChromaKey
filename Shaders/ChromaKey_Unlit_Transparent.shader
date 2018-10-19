﻿Shader "ChromaKey/Unlit/Transparent"
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
    float2 uv : TEXCOORD0;
};

struct v2f
{
    float4 vertex : SV_POSITION;
    float2 uv : TEXCOORD0;
    UNITY_FOG_COORDS(1)
};

sampler2D _MainTex;
float4 _MainTex_ST;

v2f vert(appdata v)
{
    v2f o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    UNITY_TRANSFER_FOG(o,o.vertex);
    return o;
}

fixed4 frag(v2f i) : SV_Target
{
    float4 col = tex2D(_MainTex, i.uv);
	ChromaKeyApplyAlpha(col);
    UNITY_APPLY_FOG(i.fogCoord, col);
    return col;
}

ENDCG

Pass
{
	Name "ForwardBase"
	Tags { "LightMode" = "ForwardBase" }
	Cull [_Cull]
	Blend [_BlendSrc] [_BlendDst]
	ZWrite [_ZWrite]

    CGPROGRAM
    #pragma vertex vert
    #pragma fragment frag
    #pragma multi_compile_fog
    ENDCG
}

}

Fallback "Unlit/Texture"

}