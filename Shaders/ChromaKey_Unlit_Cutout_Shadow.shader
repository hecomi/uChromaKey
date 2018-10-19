Shader "ChromaKey/Unlit/CutoutShadow"
{

Properties
{
	[Header(Material)]
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

CGINCLUDE
ENDCG

Tags 
{ 
	"Queue" = "AlphaTest"
	"RenderType" = "TransparentCutout" 
	"IgnoreProjector" = "True" 
    "PreviewType" = "Plane"
}

UsePass "ChromaKey/Unlit/Cutout/ForwardBase"
UsePass "ChromaKey/Unlit/TransparentShadow/ShadowCaster"

}

Fallback "Unlit/Texture"

}
