#ifndef CHROMA_KEY_SHADOW_CGINC
#define CHROMA_KEY_SHADOW_CGINC

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

#endif