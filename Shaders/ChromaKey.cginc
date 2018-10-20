#ifndef CHROMA_KEY_COMMON_CGINC
#define CHROMA_KEY_COMMON_CGINC

// Refer to the following website regarding conversions between RGB and HSV:
// https://www.laurivan.com/rgb-to-hsv-to-rgb-for-shaders/

float4 _ChromaKeyColor;
float _ChromaKeyHueRange;
float _ChromaKeySaturationRange;
float _ChromaKeyBrightnessRange;

inline float3 ChromaKeyRGB2HSV(float3 rgb)
{
    float4 k = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    float4 p = lerp(float4(rgb.bg, k.wz), float4(rgb.gb, k.xy), step(rgb.b, rgb.g));
    float4 q = lerp(float4(p.xyw, rgb.r), float4(rgb.r, p.yzx), step(p.x, rgb.r));
    float d = q.x - min(q.w, q.y);
    float e = 1e-10;
    return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

inline float3 ChromaKeyHSV2RGB(float3 hsv)
{
    float4 k = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    float3 p = abs(frac(hsv.xxx + k.xyz) * 6.0 - k.www);
    return hsv.z * lerp(k.xxx, clamp(p - k.xxx, 0.0, 1.0), hsv.y);
}

inline float3 ChromaKeyCalcDiffrence(float4 col)
{
    float3 hsv = ChromaKeyRGB2HSV(col);
    float3 key = ChromaKeyRGB2HSV(_ChromaKeyColor);
    return abs(hsv - key);
}

inline float3 ChromaKeyGetRange()
{
    return float3(_ChromaKeyHueRange, _ChromaKeySaturationRange, _ChromaKeyBrightnessRange);
}

inline void ChromaKeyApplyCutout(float4 col)
{
    float3 d = ChromaKeyCalcDiffrence(col);
    if (all(step(0.0, ChromaKeyGetRange() - d))) discard;
}

inline void ChromaKeyApplyAlpha(inout float4 col)
{
    float3 d = ChromaKeyCalcDiffrence(col);
    if (all(step(0.0, ChromaKeyGetRange() - d))) discard;
    col.a *= saturate(length(d / ChromaKeyGetRange()) - 1.0);
}

#endif