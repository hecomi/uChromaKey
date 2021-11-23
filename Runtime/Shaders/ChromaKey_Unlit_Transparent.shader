Shader "ChromaKey/Unlit/Transparent"
{

Properties
{
    [Header(Material)]
    _Color ("Color", Color) = (1, 1, 1, 1)
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

    Pass
    {
        Tags { "LightMode" = "ForwardBase" }
        Cull [_Cull]
        Blend [_BlendSrc] [_BlendDst]
        ZWrite [_ZWrite]

        CGPROGRAM
        #define CHROMA_KEY_ALPHA
        #include "./Chromakey_Unlit.cginc"
        #pragma vertex vert
        #pragma fragment frag
        #pragma multi_compile_fog
        ENDCG
    }

    Pass
    {
        Tags { "LightMode" = "ShadowCaster" }
        ZWrite On 
        ZTest LEqual 
        Cull Off

        CGPROGRAM
        #include "./Chromakey_Shadow.cginc"
        #pragma vertex vert
        #pragma fragment frag
        #pragma multi_compilecaster
        ENDCG
    }
}

Fallback "Unlit/Texture"

}
