#ifndef CHROMA_KEY_STANDARD_CGINC
#define CHROMA_KEY_STANDARD_CGINC

#include "UnityCG.cginc"
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
#ifdef CHROMA_KEY_ALPHA
    ChromaKeyApplyAlpha(c);
#else
    ChromaKeyApplyCutout(c);
#endif
    o.Albedo = c.rgb;
    o.Metallic = _Metallic;
    o.Smoothness = _Glossiness;
    o.Alpha = c.a;
}

#endif