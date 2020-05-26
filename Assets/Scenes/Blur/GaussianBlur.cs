using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess(typeof(GaussianBlurRenderer), PostProcessEvent.AfterStack, "Custom/GaussianBlur")]
public sealed class GaussianBlurSettings : PostProcessEffectSettings
{
    public FloatParameter blurSize = new FloatParameter { value = 0.5f };
}

public sealed class GaussianBlurRenderer : PostProcessEffectRenderer<GaussianBlurSettings> {
    int _tempRTID;
    public override void Init() {
        _tempRTID = Shader.PropertyToID("_TempRT");
    }
    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/Gaussian"));
        context.command.GetTemporaryRT(_tempRTID, context.width, context.height, 0, FilterMode.Bilinear, context.sourceFormat);
        sheet.properties.SetFloat("_BlurSize", settings.blurSize);
        context.command.BlitFullscreenTriangle(context.source, _tempRTID, sheet, 0);
        context.command.BlitFullscreenTriangle(_tempRTID, context.destination, sheet, 1);
        context.command.ReleaseTemporaryRT(_tempRTID);
    }
}
