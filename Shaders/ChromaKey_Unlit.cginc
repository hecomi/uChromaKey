#ifndef CHROMA_KEY_UNLIT_CGINC
#define CHROMA_KEY_UNLIT_CGINC

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

float4 _Color;
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
    float4 col = tex2D(_MainTex, i.uv) * _Color;
#ifdef CHROMA_KEY_ALPHA
    ChromaKeyApplyAlpha(col);
#else
    ChromaKeyApplyCutout(col);
#endif
    UNITY_APPLY_FOG(i.fogCoord, col);
    return col;
}

#endif