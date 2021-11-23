Shader "ChromaKey/Standard/Transparent" 
{

Properties 
{
    [Header(Material)]
    _Color ("Color", Color) = (1, 1, 1, 1)
    _MainTex ("Albedo (RGB)", 2D) = "white" {}
    _Glossiness ("Smoothness", Range(0, 1)) = 0.5
    _Metallic ("Metallic", Range(0, 1)) = 0.0
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
        "Queue" = "Transparent"
        "RenderType" = "Transparent" 
        "IgnoreProjector" = "True" 
        "PreviewType" = "Plane"
    }

    Cull [_Cull]

    CGPROGRAM
    #pragma surface surf Standard alpha:blend addshadow fullforwardshadows
    #pragma target 3.0
    #define CHROMA_KEY_ALPHA
    #include "./ChromaKey_Standard.cginc"
    ENDCG

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

FallBack "Diffuse"

}
