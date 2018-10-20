Shader "ChromaKey/Unlit/Cutout"
{

Properties
{
    [Header(Material)]
    _Color ("Color", Color) = (1, 1, 1, 1)
    _MainTex("Texture", 2D) = "white" {}
    [Enum(UnityEngine.Rendering.CullMode)] _Cull("Culling", Int) = 2

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
        "Queue" = "AlphaTest"
        "RenderType" = "TransparentCutout" 
        "IgnoreProjector" = "True" 
        "PreviewType" = "Plane"
    }

    Pass
    {
        Tags { "LightMode" = "ForwardBase" }
        Cull [_Cull]
        ZWrite On

        CGPROGRAM
        #include "./ChromaKey_Unlit.cginc"
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
