using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess(typeof(Grayscale2Renderer), PostProcessEvent.AfterStack, "Custom/Grayscale2")]
public sealed class Grayscale2 : PostProcessEffectSettings
{
    [Range(0f, 1f), Tooltip("Grayscale2 effect Intensity")]
    public FloatParameter blend2 = new FloatParameter{value = 0.5f};
}

public sealed class Grayscale2Renderer : PostProcessEffectRenderer<Grayscale2>{
    public override void Render(PostProcessRenderContext context){
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/Grayscale"));
        sheet.properties.SetFloat("_Blend", settings.blend2);
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}