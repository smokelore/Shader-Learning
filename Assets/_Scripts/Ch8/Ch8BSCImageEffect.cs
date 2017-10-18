using System.Collections;
using UnityEngine;

[ExecuteInEditMode] // makes the Screen Effect editable within the Editor without entering Play mode.
public class Ch8BSCImageEffect : MonoBehaviour
{
    #region Variables
    public Shader curShader;

    [Range(0.0f, 2.0f)]
    public float brightnessAmount = 1.0f;
    [Range(0.0f, 2.0f)]
    public float saturationAmount = 1.0f;
    [Range(0.0f, 3.0f)]
    public float contrastAmount = 1.0f;

    private Material curMaterial;
    #endregion

    #region Properties
    Material material
    {
        // material getter checks for a material, creates one if it doesn't find one.
        get
        {
            if (curMaterial == null)
            {
                curMaterial = new Material(curShader);
                curMaterial.hideFlags = HideFlags.HideAndDontSave;
            }

            return curMaterial;
        }
    }
    #endregion

    private void Start()
    {
        // check that the target platform supports image effects.
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }

        // script disables itself if image effects aren't supported.
        if (curShader && !curShader.isSupported)
        {
            enabled = false;
        }
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        // access the render texture from the Unity Renderer.
        if (curShader != null)
        {
            material.SetFloat("_BrightnessAmount", brightnessAmount);
            material.SetFloat("_SaturationAmount", saturationAmount);
            material.SetFloat("_ContrastAmount", contrastAmount);

            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }

    private void Update()
    {
        brightnessAmount = Mathf.Clamp(brightnessAmount, 0.0f, 2.0f);
        saturationAmount = Mathf.Clamp(saturationAmount, 0.0f, 2.0f);
        contrastAmount = Mathf.Clamp(contrastAmount, 0.0f, 3.0f);
    }

    private void OnDisable()
    {
        // clean up the curMaterial object we created in the material getter if this script is disabled.
        if (curMaterial)
        {
            DestroyImmediate(curMaterial);
        }
    }
}
